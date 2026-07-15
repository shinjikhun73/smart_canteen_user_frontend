import 'package:dio/dio.dart';

import '../local/token_storage.dart';
import 'api_config.dart';

/// Builds the shared HTTP client used by every NestJS repository.
///
/// Interceptors:
/// - **onRequest** — attaches the stored access token as a `Bearer` header.
/// - **onError** — on a `401`, transparently refreshes the token via
///   `POST /auth/refresh` (using the stored refresh token) and retries the
///   original request **once**. If refreshing fails, the stored tokens are
///   cleared so the next launch falls back to sign-in.
Dio createApiClient({TokenStorage? tokenStorage}) {
  final storage = tokenStorage ?? TokenStorage.instance;

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.readAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final is401 = error.response?.statusCode == 401;
        final isRefreshCall =
            error.requestOptions.path == ApiConfig.refreshToken;
        final alreadyRetried = error.requestOptions.extra['__retried'] == true;

        // Only try to recover from a genuine 401 that isn't itself the refresh
        // call and hasn't already been retried once.
        if (!is401 || isRefreshCall || alreadyRetried) {
          return handler.next(error);
        }

        final refreshToken = await storage.readRefreshToken();
        if (refreshToken == null) {
          await storage.clear();
          return handler.next(error);
        }

        try {
          // A bare client (no interceptors) so the refresh call can't recurse.
          final refreshDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
          final resp = await refreshDio.post(
            ApiConfig.refreshToken,
            data: {'refresh_token': refreshToken},
          );
          final data = resp.data['data'] as Map<String, dynamic>;
          final newAccess = data['access_token'] as String;
          final newRefresh = data['refresh_token'] as String;
          await storage.saveTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );

          // Retry the original request once with the fresh token.
          final req = error.requestOptions;
          req.headers['Authorization'] = 'Bearer $newAccess';
          req.extra['__retried'] = true;
          final retried = await dio.fetch(req);
          return handler.resolve(retried);
        } catch (_) {
          // Refresh failed — the session is dead; clear it.
          await storage.clear();
          return handler.next(error);
        }
      },
    ),
  );

  return dio;
}

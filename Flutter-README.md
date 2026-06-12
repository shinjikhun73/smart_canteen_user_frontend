# Smart Canteen Management System — Mobile Frontend

Flutter mobile frontend for the Smart Canteen Management System (SCMS). User-facing app for students and staff at CADT, ITC, and MPTC.

---

## Tech Stack

| Concern          | Choice                          |
|------------------|---------------------------------|
| Framework        | Flutter (Dart)                  |
| State management | MVVM (ViewModel + States)       |
| HTTP client      | Dio                             |
| Local storage    | Hive (offline cache)            |
| Secure storage   | flutter_secure_storage (JWT)    |
| Navigation       | GoRouter                        |
| QR display       | qr_flutter                      |
| QR scanning      | mobile_scanner                  |
| Push notifications | firebase_messaging             |

---

## Quick Start

```bash
flutter pub get
cp .env.example .env
flutter run
```

Backend must be running on port 3000 — see `../backend/README.md`.  
Admin dashboard (Next.js) runs separately — see `../frontend-admin/README.md`.

---

## Project Structure

```
lib/
├── core/                        # App-wide infrastructure
│   ├── network/                 # Dio client, interceptors, token refresh
│   ├── storage/                 # Hive boxes, flutter_secure_storage wrappers
│   ├── router/                  # GoRouter route definitions and guards
│   └── theme/                   # app_theme.dart — colors, typography, spacing
│
├── data/                        # Data layer
│   ├── models/                  # JSON-serializable DTOs (per feature)
│   ├── services/                # API service classes (per feature)
│   └── repositories/            # Repository interfaces and implementations
│
├── ui/
│   ├── screens/                 # Feature screens — co-located with ViewModel & State
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── welcome/
│   │   ├── login/
│   │   │   └── sign_in_screen.dart
│   │   ├── signup/
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── menu/
│   │   ├── order/
│   │   │   └── order_summary_screen.dart
│   │   ├── wallet/
│   │   ├── notifications/
│   │   └── profile/
│   │
│   └── widgets/                 # Shared reusable widgets only
│
├── view_model/                  # ViewModels (one per feature screen)
├── states/                      # State classes (one per feature)
└── main.dart
```

---

## Layer Communication

```
Screen  (ui/screens/...)
  │  listens to state, calls ViewModel methods
  ▼
ViewModel  (view_model/...)
  │  updates state, calls repository
  ▼
Repository  (data/repositories/...)
  │  abstracts data source
  ▼
Service  (data/services/...)
  │  HTTP request
  ▼
core/network/dio_client.dart         [Dio instance + interceptors]
  │
  ▼
NestJS Backend  →  http://localhost:3000/api/v1
```

**Rules:**
- Screens listen to state and call ViewModel methods only — never services directly.
- ViewModels own business logic, update state, and call repositories.
- Services are stateless — pure HTTP wrappers around `core/network/dio_client`.
- JWT access token is stored in `flutter_secure_storage`. Dio interceptor handles attachment and silent refresh automatically.

---

## Route Map

| Screen                  | Path                  | Auth Required |
|-------------------------|-----------------------|---------------|
| Splash                  | `/`                   | No            |
| Welcome                 | `/welcome`            | No            |
| Sign In                 | `/login`              | No            |
| Sign Up                 | `/signup`             | No            |
| Home                    | `/home`               | Yes           |
| Weekly Menu             | `/menu`               | Yes           |
| Order Summary           | `/order/summary`      | Yes           |
| Digital Wallet / QR     | `/wallet`             | Yes           |
| Notifications           | `/notifications`      | Yes           |
| Profile                 | `/profile`            | Yes           |

GoRouter guards redirect unauthenticated users to `/login` by checking token presence in `flutter_secure_storage`.

---

## Offline Support

| Feature              | Strategy                                      |
|----------------------|-----------------------------------------------|
| QR coupon display    | QR payload cached in Hive on purchase         |
| Recent purchase history | Hive cache, refreshed on app foreground    |
| Weekly menu          | Hive cache, TTL-based refresh                 |
| Auth token           | flutter_secure_storage (persists across sessions) |

---

## How to Add a New Feature

1. `data/models/<name>/<name>_model.dart` — define the DTO with `fromJson`.
2. `data/services/<name>/<name>_service.dart` — HTTP calls via `dio_client`.
3. `data/repositories/<name>/<name>_repository.dart` — repository implementation.
4. `states/<name>_state.dart` — define state classes (initial, loading, success, error).
5. `view_model/<name>_viewmodel.dart` — ViewModel consuming the repository.
6. `ui/screens/<name>/<name>_screen.dart` — screen listening to ViewModel state.
7. Register the route in `core/router/app_router.dart`.

---

## Environment Variables

Create a `.env` file at the project root:

| Variable            | Description                        |
|---------------------|------------------------------------|
| `BASE_URL`          | NestJS backend base URL            |
| `FIREBASE_PROJECT`  | Firebase project ID for FCM        |

> Use the `flutter_dotenv` package to load variables. Access via `dotenv.env['BASE_URL']`.

---

## Related Repositories

| Repo                     | Description                          |
|--------------------------|--------------------------------------|
| `backend/`               | NestJS API — auth, coupons, payments |
| `frontend-admin/`        | Next.js admin dashboard (Super Admin, Manager, Staff) |

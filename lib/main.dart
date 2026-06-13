// Default entry point — delegates to the dev flavour.
// Run with mock repositories: flutter run -t lib/main_dev.dart
// Run with live backend:      flutter run -t lib/main_prod.dart
import 'main_dev.dart' as dev;

void main() => dev.main();

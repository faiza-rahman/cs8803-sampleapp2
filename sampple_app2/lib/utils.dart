import 'package:firebase_core/firebase_core.dart';
import 'package:sampple_app2/firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:sampple_app2/services/auth_service.dart';
import 'package:sampple_app2/services/navigation_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerService() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
      AuthService()
    );
  getIt.registerSingleton<NavigationService>(
    NavigationService()
  );
}
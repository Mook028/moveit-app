import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/app_provider.dart';
import 'features/auth/auth_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'landing/landing_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  runApp(const MoveItApp());
}

class MoveItApp extends StatelessWidget {
  const MoveItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AppProvider();

            Future.microtask(() async {
              await provider.loadProfileImage();
              await provider.loadStatus();
            });

            return provider;
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'MoveIT',
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );
  }
}

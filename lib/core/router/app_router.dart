import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/routes.dart';
import '../providers/app_provider.dart';
import '../../features/auth/auth_provider.dart' as app_auth;
import '../../features/mood/mood_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/profile/profile_screen.dart';

// auth
import '../../features/auth/login_screen.dart';
import '../../features/auth/splash_screen.dart';

import '../../landing/landing_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),

  redirect: (context, state) {
    final appProvider = context.read<AppProvider>();
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final location = state.matchedLocation;

    final isAuthRoute = location == Routes.login || location == Routes.register;

    // Splash
    if (location == '/') return null;

    // อนุญาต login/register
    if (isAuthRoute) return null;

    // ยังไม่ login
    if (!isLoggedIn) return Routes.login;

    // mood logic
    if (isLoggedIn &&
        appProvider.shouldRedirectToMoodForNewDay &&
        location != Routes.mood) {
      return Routes.mood;
    }

    if (location == Routes.mood && appProvider.shouldRedirectToMoodForNewDay) {
      unawaited(appProvider.markMoodRedirectHandled());
    }

    return null;
  },

  routes: [
    GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
    GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: Routes.register,
      builder: (_, _) => const LoginScreen(isLogin: false),
    ),
    GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    GoRoute(path: Routes.mood, builder: (_, _) => const MoodScreen()),
    GoRoute(path: Routes.profile, builder: (_, _) => ProfileScreen()),
    GoRoute(path: Routes.progress, builder: (_, _) => const ProgressScreen()),
    GoRoute(path: '/landingpage', builder: (_, _) => const LandingPage()),
  ],
);

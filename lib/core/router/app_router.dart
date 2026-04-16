import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../constants/routes.dart';
import '../providers/app_provider.dart';
import '../../features/mood/mood_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/progress/progress_screen.dart';
import '../../features/profile/profile_screen.dart';

// auth
import '../../features/auth/login_screen.dart';
import '../../features/auth/auth_provider.dart';

import '../../landing/landing_page.dart';
import '../../core/theme/app_theme.dart';

final GoRouter appRouter = GoRouter(
  // ignore initialLocation -- redirect logic will handle unauthenticated users
  initialLocation: Routes.login,
  redirect: (context, state) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final isLoggedIn = auth.user != null;

    // Prefer matchedLocation for route checks and fall back to URI matching for web/hash URLs.
    final matchedLocation = state.matchedLocation;
    final currentUri = state.uri.toString();

    final isLandingPage =
        matchedLocation == '/landingpage' ||
        currentUri.contains('/landingpage');

    final isAuthRoute =
        matchedLocation == Routes.login ||
        matchedLocation == Routes.register ||
        currentUri.contains('/login') ||
        currentUri.contains('/register');

    if (kDebugMode) {
      debugPrint(
        'Router redirect => loggedIn: $isLoggedIn, matched: $matchedLocation, uri: $currentUri, isAuthRoute: $isAuthRoute',
      );
    }

    // Evaluate date-only boundary to detect a new day on app open/resume.
    appProvider.evaluateDayBoundaryOnAppOpen();

    // If not logged in, allow only auth routes (login/register).
    if (!isLoggedIn && !isAuthRoute && !isLandingPage) {
      return Routes.login;
    }

    // Keep login as first screen on app start.
    if (matchedLocation == Routes.login) {
      return null;
    }

    // Redirect once per day to Mood screen when a new day is detected.
    if (isLoggedIn && appProvider.shouldRedirectToMoodForNewDay) {
      if (matchedLocation != Routes.mood) {
        return Routes.mood;
      }

      // When user has reached Mood, persist lastActiveDate and stop redirecting.
      unawaited(appProvider.markMoodRedirectHandled());
    }

    return null;
  },
  routes: [
    GoRoute(path: Routes.mood, builder: (context, state) => const MoodScreen()),
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const LandingPage(),
    ),

    // auth routes
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const LoginScreen(isLogin: false),
    ),
  ],
);

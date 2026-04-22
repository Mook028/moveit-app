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
import '../../features/auth/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', //  Splash

  redirect: (context, state) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final isLoggedIn = auth.user != null;

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

    // อนุญาต Splash เสมอ
    if (matchedLocation == '/') {
      return null;
    }

    // ตรวจวันใหม่
    appProvider.evaluateDayBoundaryOnAppOpen();

    // ยังไม่ login → ไป login
    if (!isLoggedIn && !isAuthRoute && !isLandingPage) {
      return Routes.login;
    }

    //  อยู่หน้า login แล้ว → ไม่ต้อง redirect
    if (matchedLocation == Routes.login) {
      return null;
    }

    // redirect ไป mood ถ้าเป็นวันใหม่
    if (isLoggedIn &&
        appProvider.shouldRedirectToMoodForNewDay &&
        matchedLocation != Routes.mood &&
        matchedLocation != Routes.profile) {
      return Routes.mood;
    }

    // mark ว่าเข้า mood แล้ว
    if (matchedLocation == Routes.mood) {
      unawaited(appProvider.markMoodRedirectHandled());
    }

    // login แล้ว → ห้ามกลับ login
    if (isLoggedIn && isAuthRoute) {
      return Routes.home;
    }

    return null;
  },

  routes: [
    /// Splash Screen (หน้าแรกสุด)
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

    ///  Login
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    /// Register
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const LoginScreen(isLogin: false),
    ),

    /// Home
    GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),

    ///  Mood
    GoRoute(path: Routes.mood, builder: (context, state) => const MoodScreen()),

    /// Profile
    GoRoute(
      path: Routes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),

    /// Progress
    GoRoute(
      path: Routes.progress,
      builder: (context, state) => const ProgressScreen(),
    ),

    ///  Landing Page
    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const LandingPage(),
    ),
  ],
);

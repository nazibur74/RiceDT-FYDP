import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/scan/presentation/pages/scan_page.dart';
import 'package:rice_dt/features/prediction/presentation/pages/image_preview_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),

      GoRoute(path: '/home', builder: (context, state) => const HomePage()),

      GoRoute(path: '/scan', builder: (context, state) => const ScanPage()),

      GoRoute(
        path: '/preview',
        builder: (context, state) {
          final imagePath = state.extra as String;

          return ImagePreviewPage(imagePath: imagePath);
        },
      ),
    ],
  );
}

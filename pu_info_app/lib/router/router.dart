import 'package:go_router/go_router.dart';

import '../screen/screen.dart';

final appRouter = GoRouter(
  initialLocation: '/test',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/utils',
      name: 'utils',
      builder: (context, state) => const UtilsScreen(),
    ),
    GoRoute(
      path: '/test',
      name: 'test',
      builder: (context, state) => const TestScreen(),
    ),
  ],
);

import 'package:go_router/go_router.dart';

import '../screen/screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: "home",
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
import 'package:go_router/go_router.dart';

import '../features/schedule/presentation/schedule_detail_screen.dart';
import '../features/schedule/presentation/schedule_form_screen.dart';
import '../features/schedule/presentation/schedule_list_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ScheduleListScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ScheduleDetailScreen(itemId: id);
      },
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) {
        final idParam = state.uri.queryParameters['id'];
        final editingId = idParam != null ? int.tryParse(idParam) : null;
        return ScheduleFormScreen(editingId: editingId);
      },
    ),
  ],
);

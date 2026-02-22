import 'package:intl/intl.dart';

/// Section header: e.g. "2026년 2월 22일 일요일" (Korean long date)
final sectionFormatter = DateFormat.yMMMMEEEEd('ko_KR');

/// List tile time: e.g. "오후 3:30" (Korean short time)
final timeFormatter = DateFormat.jm('ko_KR');

/// Detail view: e.g. "26. 2. 22. 오후 3:30:00" (short date + medium time)
final detailFormatter = DateFormat('yy. M. d. a h:mm:ss', 'ko_KR');

/// Date-only key for grouping (not displayed)
final groupingKeyFormatter = DateFormat('yyyy-MM-dd');

import '../../../core/storage/database_helper.dart';
import '../domain/schedule_item.dart';
import 'schedule_dto.dart';

class ScheduleRepository {
  final DatabaseHelper _dbHelper;

  ScheduleRepository([DatabaseHelper? dbHelper])
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<ScheduleItem>> getAllItems() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DatabaseHelper.tableSchedule,
      orderBy: 'timestamp ASC',
    );
    return rows.map(ScheduleDto.fromMap).toList();
  }

  Future<ScheduleItem?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      DatabaseHelper.tableSchedule,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return ScheduleDto.fromMap(rows.first);
  }

  Future<int> insert(ScheduleItem item) async {
    final db = await _dbHelper.database;
    return db.insert(DatabaseHelper.tableSchedule, ScheduleDto.toMap(item));
  }

  Future<int> update(ScheduleItem item) async {
    final db = await _dbHelper.database;
    return db.update(
      DatabaseHelper.tableSchedule,
      ScheduleDto.toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      DatabaseHelper.tableSchedule,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:sqflite/sqflite.dart';
import '../models/event.dart';
import '../services/event_database_helper.dart'; // Ensure you have the database initialized

class EventDAO {
  final EventDatabaseHelper _databaseHelper = EventDatabaseHelper();

  Future<int> insertEvent(Event event) async {
    Database db = await _databaseHelper.database;
    return await db.insert('events', event.toMap());
  }

  Future<List<Event>> getEvents() async {
    Database db = await _databaseHelper.database;
    final List<Map<String, dynamic>> eventMaps = await db.query('events');
    return List.generate(eventMaps.length, (i) {
      return Event(
        id: eventMaps[i]['id'],
        name: eventMaps[i]['name'],
        date: DateTime.parse(eventMaps[i]['date']),
      );
    });
  }

  Future<int> updateEvent(Event event) async {
    Database db = await _databaseHelper.database;
    return await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int id) async {
    Database db = await _databaseHelper.database;
    return await db.delete(
        'events',
        where: 'id = ?',
        whereArgs: [id],
        );
    }
}
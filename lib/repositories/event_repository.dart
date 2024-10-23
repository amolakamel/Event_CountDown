import '../dao/event_dao.dart';
import '../models/event.dart';
import '../services/event_database_helper.dart';

class EventRepository {
  final EventDAO _eventDAO;

  // Add constructor to accept EventDAO or EventDatabaseHelper if needed
  EventRepository({required EventDAO eventDAO}) : _eventDAO = eventDAO;

  Future<List<Event>> getEvents() async {
    return await _eventDAO.getEvents();
  }

  Future<void> addEvent(Event event) async {
    await _eventDAO.insertEvent(event);
  }

  Future<void> editEvent(Event event) async {
    await _eventDAO.updateEvent(event);
  }

  Future<void> deleteEvent(int id) async {
    await _eventDAO.deleteEvent(id);
    }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../repositories/event_repository.dart';

class EventViewModel extends ChangeNotifier {
  final EventRepository _repository;
  final List<Event> _events = [];
  Timer? _timer;

  // Modify constructor to accept EventRepository
  EventViewModel({required EventRepository repository}) : _repository = repository {
    _startTimer();
    fetchEvents(); // Load events from the repository on initialization
  }

  List<Event> get events => List.unmodifiable(_events);

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Fetch events from the repository
  Future<void> fetchEvents() async {
    _events.clear();
    final eventList = await _repository.getEvents();
    _events.addAll(eventList);
    notifyListeners();
  }

  // Add a new event using the repository
  Future<void> addEvent(String name, DateTime date) async {
    final newEvent = Event(name: name, date: date);
    await _repository.addEvent(newEvent);
    await fetchEvents(); // Refresh the events list
  }

  // Edit an existing event using the repository
  Future<void> editEvent(int id, String name, DateTime date) async {
    final updatedEvent = Event(id: id, name: name, date: date);
    await _repository.editEvent(updatedEvent);
    await fetchEvents(); // Refresh the events list
  }

  // Delete an event by its ID using the repository
  Future<void> deleteEvent(int id) async {
    await _repository.deleteEvent(id);
    await fetchEvents(); // Refresh the events list
  }

  String getCountdown(DateTime eventDate) {
    final Duration difference = eventDate.difference(DateTime.now());
    if (difference.isNegative) {
      return 'Event passed';
    }
    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    return '$days days, $hours hours, $minutes minutes, $seconds seconds';
    }
}
import 'dart:developer';
import 'package:event/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationViewModel extends ChangeNotifier {
  // Store notification state for each event by their ID
  final Map<int, bool> _notificationStates = {};

  NotificationViewModel() {
    _loadNotificationStates();
  }

  bool isNotificationOn(int eventId) => _notificationStates[eventId] ?? false;

  Future<void> _loadNotificationStates() async {
    final prefs = await SharedPreferences.getInstance();
    notifyListeners(); // Notify listeners that the state has been loaded
  }

  Future<void> toggleNotification(int eventId, DateTime eventDate) async {
    // Toggle the notification state for the specific event ID
    _notificationStates[eventId] = !isNotificationOn(eventId);

    // Save the updated state in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_$eventId', _notificationStates[eventId]!);

    // Debug log to verify the state
    log('Notification state changed for event $eventId: ${_notificationStates[eventId]}');

    if (_notificationStates[eventId]!) {
      // Schedule notification if it's being turned on
      LocalNotificationService.showScheduledNotification(eventDate);
      log('Notification scheduled for event $eventId: $eventDate');
    } else {
      // Cancel the notification
      LocalNotificationService.flutterLocalNotificationsPlugin.cancel(eventId);
      log('Notification canceled for event $eventId');
    }

    notifyListeners(); // Notify listeners about the change
  }
}
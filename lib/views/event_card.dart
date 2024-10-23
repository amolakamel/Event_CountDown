import 'package:event/view_models/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/local_notification_service.dart';

class EventCard extends StatelessWidget {
  final String eventName;
  final DateTime eventDate;
  final String countdown;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final int eventId; // Add this to uniquely identify each event

  EventCard({
    required this.eventName,
    required this.eventDate,
    required this.countdown,
    required this.onEdit,
    required this.onDelete,
    required this.eventId, // Pass the event ID
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final notificationViewModel = Provider.of<NotificationViewModel>(
        context); // Access the NotificationViewModel

    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.teal.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  countdown,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // Responsive font size
                    color: Colors.white70,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Event Date: ${DateFormat('yyyy-MM-dd').format(eventDate)}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    color: Colors.white70,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: onEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.teal),
                          SizedBox(width: 5),
                          Text('Edit', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 5),
                          Text('Delete', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Toggle notification state for this specific event ID
                        notificationViewModel.toggleNotification(eventId, eventDate); // Call the method on the instance
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: notificationViewModel.isNotificationOn(eventId)
                            ? Colors.green // Color when enabled
                            : Colors.red,  // Color when disabled
                        foregroundColor: Colors.white, // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                        ),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.white, size: 20),
                          // Icon
                          SizedBox(width: 3),
                          // Spacing between icon and text
                          Text(
                            notificationViewModel.isNotificationOn(eventId)
                                ? 'ON'
                                : 'OFF', // Button text
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ),
    );
  }
}
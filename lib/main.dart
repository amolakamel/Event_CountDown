import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Device Preview package
import 'package:provider/provider.dart';
import '../services/local_notification_service.dart';
import '../view_models/event_view_model.dart';
import '../repositories/event_repository.dart';
import '../services/event_database_helper.dart';
import '../dao/event_dao.dart'; // Import EventDAO
import '../views/event_home_page.dart'; // Corrected the path to EventHomePage
import '../view_models/notification_view_model.dart';


void main() async {
  // Ensure that everything is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notification service
  await LocalNotificationService.init();

  // Initialize the database helper and repository
  final databaseHelper = EventDatabaseHelper(); // Initialize the database helper
  final eventDAO = EventDAO(); // Initialize EventDAO
  final eventRepository = EventRepository(eventDAO: eventDAO); // Pass DAO to repository
  final eventViewModel = EventViewModel(repository: eventRepository); // Pass repository to view model

  // Run the app with DevicePreview
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventViewModel(repository: eventRepository), // Provide EventViewModel
        ),
        ChangeNotifierProvider(create: (_) => eventViewModel),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: DevicePreview(
        enabled: true, // Set this to 'false' in production or when not needed
        builder: (context) => const EventCountdown(),
      ),
    ),
  );
}

class EventCountdown extends StatelessWidget {
  const EventCountdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Event Countdown',
        useInheritedMediaQuery: false, // Enable media query for DevicePreview
        locale: DevicePreview.locale(context), // Use DevicePreview locale
        builder: DevicePreview.appBuilder, // Use DevicePreview app builder
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Poppins'),
            bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
          ),
        ),
        home: const EventHomePage(), // No need to pass eventViewModel
    );
  }
}

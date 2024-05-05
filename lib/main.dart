import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note/pages/add_note.dart';
import 'package:note/pages/edit_note.dart';
import 'package:note/pages/home.dart';
import 'package:note/pages/welcome.dart';
import 'package:note/pages/wrapper.dart';
import 'package:note/serives/local_notification_service.dart';

import 'firebase_options.dart';


final navigatorKey = GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotifications.init();

// Get notification details that launched the app
  var initialNotification = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

// Check if the app was launched from a notification
  if (initialNotification?.didNotificationLaunchApp == true) {
    // Add a delay of 1 second before executing the navigation
    Future.delayed(Duration(seconds: 1), () {
      // Access the current navigator and push a named route '/another'
      navigatorKey.currentState!.pushNamed('/wrapper',
          // Pass the payload from the notification as arguments to the new screen
          arguments: initialNotification?.notificationResponse?.payload
      );
    });
  }

  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: 'Flutter Demo',
    routes: {
      "/" : (context) => Welcome(),
      '/home' : (context) => Home(),
      "/wrapper" : (context) => Wrapper(),
      '/create' : (context) => AddNote(),
      '/edit' : (context) => EditNote(),
    },
  )
  );
}
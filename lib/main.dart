
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/add_event_viewmodel.dart';
import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import 'package:catas_univalle/view_models/admin_event_list_viewmodel.dart';
import 'package:catas_univalle/view_models/admin_list_viewmodel.dart';
import 'package:catas_univalle/view_models/cata_events_viewmodel.dart';
import 'package:catas_univalle/view_models/client_list_viewmodel.dart';
import 'package:catas_univalle/view_models/edit_client_viewmodel.dart';
import 'package:catas_univalle/view_models/judge_viewmodel.dart';
import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/view_models/register_admin_viewmodel.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:catas_univalle/view_models/selected_judges_viewmodel.dart';
import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:catas_univalle/widgets/initial_screen_decider.dart';
import 'package:intl/date_symbol_data_local.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _setupFirebaseMessaging();
  _setupNotificationListeners();
  runApp(const MyApp());
}

Future<void> _setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void _setupNotificationListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'General Notifications',
            channelDescription: 'All important notifications',
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => JudgeViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ClientListViewModel()),
        ChangeNotifierProvider(create: (context) => AddEventViewModel()),
        ChangeNotifierProvider(create: (_) => CataEventsViewModel()),
        ChangeNotifierProvider(create: (context) => AdminEventListViewModel()),
        ChangeNotifierProvider(
            create: (context) => SelectJudgesViewModel('eventId')),
        ChangeNotifierProvider(
            create: (context) => AdminEventDetailsViewModel()),
        ChangeNotifierProvider(
            create: (context) => SelectedJudgesViewModel(Event.placeholder())),
        ChangeNotifierProvider(create: (context) => EditClientViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ClientListViewModel()),
        ChangeNotifierProvider(create: (_) => AddEventViewModel()),
        ChangeNotifierProvider(create: (_) => TrainingEventListViewModel()),
        ChangeNotifierProvider(create: (_) => AdminEventListViewModel()),
        ChangeNotifierProvider(create: (_) => AdminEventDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterAdminViewModel()),
        ChangeNotifierProvider(create: (_) => AdminListViewModel()),
        ChangeNotifierProvider(create: (_) => VerificationViewModel(() => {},)),
        Provider<EventService>(create: (_) => EventService()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Catas Univalle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 232, 137, 158),
            primary: const Color.fromARGB(255, 232, 137, 158),
          ),
          useMaterial3: true,
        ),
        home: const InitialScreenDecider(),
      ),
    );
  }
}

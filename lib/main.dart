import 'package:catas_univalle/view_models/admin_list_viewmodel.dart';
import 'package:catas_univalle/view_models/cata_events_viewmodel.dart';
import 'package:catas_univalle/view_models/register_admin_viewmodel.dart';
import 'package:catas_univalle/view_models/select_judges_viewmodel.dart';
import 'package:catas_univalle/view_models/selected_judges_viewmodel.dart';
import 'package:catas_univalle/view_models/training_event_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:catas_univalle/models/event.dart';
import 'package:catas_univalle/services/event_service.dart';
import 'package:catas_univalle/view_models/add_event_viewmodel.dart';
import 'package:catas_univalle/view_models/admin_event_details_viewmodel.dart';
import 'package:catas_univalle/view_models/admin_event_list_viewmodel.dart';
import 'package:catas_univalle/view_models/client_list_viewmodel.dart';
import 'package:catas_univalle/view_models/edit_client_viewmodel.dart';
import 'package:catas_univalle/view_models/profile_viewmodel.dart';
import 'package:catas_univalle/view_models/register_viewmodel.dart';
import 'package:catas_univalle/view_models/judge_viewmodel.dart';
import 'package:catas_univalle/widgets/initial_screen_decider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
        ChangeNotifierProvider(create: (_) => ClientListViewModel()),
        ChangeNotifierProvider(create: (_) => AddEventViewModel()),
        ChangeNotifierProvider(create: (_) => TrainingEventListViewModel()),
        ChangeNotifierProvider(create: (_) => AdminEventListViewModel()),
        ChangeNotifierProvider(create: (_) => AdminEventDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterAdminViewModel()),
        ChangeNotifierProvider(create: (_) => AdminListViewModel()),
        Provider<EventService>(create: (_) => EventService()),
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

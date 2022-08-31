import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';
import 'package:radio_player/player.dart';
import 'package:radio_player/providers/animation_provider.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:radio_player/services/decode_radio_data.dart';
import 'package:radio_player/views/home.dart';
import 'package:rive/rive.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import 'firebase_options.dart';

late final PageManager pageManager;
late FirebaseDatabase firebaseDatabase;
final progressStream = BehaviorSubject<WaveformProgress>();
late RiveAnimationController animationController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'radio-player-stations',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "flutter_background example app",
    notificationText: "Background notification for keeping the example app running in the background",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => RadioModel()),
      ChangeNotifierProvider(create: (context) => AnimationProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    pageManager = PageManager();
    firebaseDatabase = FirebaseDatabase.instance;
    fetchDataFromFirebase();
    initWaveForm();
  }

  @override
  void dispose() {
    pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(brightness: Brightness.dark, canvasColor: const Color.fromARGB(255, 35, 35, 35)
          /* dark theme settings */
          ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: home(
            context,
          ),
        ),
      ),
    );
  }

  fetchDataFromFirebase() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('/');
    dbRef.onValue.listen((DatabaseEvent event) {
      decodeRadioData(context, event);
    });
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';
import 'package:radio_player/player.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:radio_player/services/decode_radio_data.dart';
import 'package:radio_player/views/home.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import 'firebase_options.dart';

late final PageManager pageManager;
late FirebaseDatabase firebaseDatabase;
final progressStream = BehaviorSubject<WaveformProgress>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'radio-player-stations',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => RadioModel()),
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
    return MaterialApp(home: Scaffold(body: Padding(padding: const EdgeInsets.all(20.0), child: home(context))));
  }

  fetchDataFromFirebase() async {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('/');
    dbRef.onValue.listen((DatabaseEvent event) {
      decodeRadioData(context, event);
    });
  }
}

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:radio_player/views/home.dart';

import 'firebase_options.dart';

late final PageManager pageManager;
late FirebaseDatabase firebaseDatabase;

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
    var radioModel = Provider.of<RadioModel>(context, listen: false);
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('/');
    dbRef.onValue.listen((DatabaseEvent event) {
      dynamic data = json.decode(json.encode(event.snapshot.value));
      List<dynamic> radioMapList = data.toList();
      List<Map<String, String>> mappedList = [];
      for (var item in radioMapList) {
        mappedList.add({'name': item['name'], 'url': item['url'].toString().replaceAll(RegExp(r"\s+"), "")});
      }
      radioModel.radioList = mappedList;
    });
  }
}

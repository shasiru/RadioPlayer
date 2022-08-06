// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';
import 'package:radio_player/providers/player_model.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:radio_player/providers/views/home.dart';

late final PageManager pageManager;

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => RadioModel()),
        ChangeNotifierProvider(create: (context) => PlayerModel()),
      ], child: const MyApp()),
    );

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
}

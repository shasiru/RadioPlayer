// ignore_for_file: avoid_print

import 'package:radio_player/player.dart';
import 'package:radio_player/providers/player_model.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => RadioModel()),
        ChangeNotifierProvider(create: (context) => PlayerModel()),
      ], child: const MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

enum RadioStationProps { stationName, url }

late final PageManager _pageManager;

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _pageManager = PageManager();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var radioModel = Provider.of<RadioModel>(context, listen: true);

    return MaterialApp(
      home: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: radioModel.radioList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Station: ${radioModel.radioList[index]['name']}'),
                          onTap: () {
                            _handleListItemTap(index);
                          },
                          tileColor: radioModel.selectedStation['url'] == radioModel.radioList[index]['url']
                              ? const Color.fromARGB(248, 175, 175, 242)
                              : null,
                        );
                      }),
                ),
                SizedBox(height: 100, child: player(context, _pageManager)),
              ],
            )),
      ),
    );
  }

  _handleListItemTap(int index) {
    var radioModel = Provider.of<RadioModel>(context, listen: false);
    radioModel.selectedStation = radioModel.radioList[index];
    _pageManager.play(context);
  }
}

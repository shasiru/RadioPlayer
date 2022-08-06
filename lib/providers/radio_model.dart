import 'package:flutter/material.dart';

class RadioModel extends ChangeNotifier {
  List<Map<String, String>> _radioList = [];
  Map<String, String> _selectedStation = {};

  List<Map<String, String>> get radioList => _radioList;

  set radioList(List<Map<String, String>> data) {
    _radioList = data;
    notifyListeners();
  }

  Map<String, String> get selectedStation => _selectedStation;

  set selectedStation(Map<String, String> selectedStation) {
    _selectedStation = selectedStation;
    notifyListeners();
  }
}

// const json = {
//   [
//     {'name': '1.FM Top 40', 'url': 'http://185.33.21.111:80/top40_64'},
//     {'name': 'JOY Hits2', 'url': 'http://51.210.241.217:8880/joyhits.mp3'},
//     {'name': 'POWERHITZ.COM', 'url': 'http://216.235.89.134:80/officemix'},
//     {'name': 'ANTENNE BAYERN Top 40', 'url': 'http://stream.antenne.de:80/top-40'},
//   ]
// };

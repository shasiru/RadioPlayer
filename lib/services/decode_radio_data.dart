import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/radio_model.dart';

decodeRadioData(BuildContext context, DatabaseEvent event) {
  var radioModel = Provider.of<RadioModel>(context, listen: false);
  dynamic data = json.decode(json.encode(event.snapshot.value));
  List<dynamic> radioMapList = data.toList();
  List<Map<String, String>> mappedList = [];
  for (var item in radioMapList) {
    mappedList.add({'name': item['name'], 'url': item['url'].toString().replaceAll(RegExp(r"\s+"), "")});
  }
  radioModel.radioList = mappedList;
}

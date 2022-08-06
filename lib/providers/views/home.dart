import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/player.dart';
import 'package:radio_player/providers/radio_model.dart';

import '../../main.dart';

Widget home(BuildContext context) {
  var radioModel = Provider.of<RadioModel>(context, listen: true);
  return (Column(
    children: [
      Expanded(
        child: ListView.builder(
            itemCount: radioModel.radioList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Station: ${radioModel.radioList[index]['name']}'),
                onTap: () {
                  _handleListItemTap(context, index);
                },
                tileColor: radioModel.selectedStation['url'] == radioModel.radioList[index]['url'] ? const Color.fromARGB(248, 175, 175, 242) : null,
              );
            }),
      ),
      SizedBox(height: 100, child: player(context, pageManager)),
    ],
  ));
}

_handleListItemTap(BuildContext context, int index) {
  var radioModel = Provider.of<RadioModel>(context, listen: false);
  radioModel.selectedStation = radioModel.radioList[index];
  pageManager.play(context);
}

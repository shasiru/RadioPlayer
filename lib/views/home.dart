import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:radio_player/views/animated_canvas.dart';

import '../../main.dart';
import '../player.dart';
import '../providers/animation_provider.dart';

Widget home(BuildContext context) {
  var radioModel = Provider.of<RadioModel>(context, listen: true);
  final animationProvider = Provider.of<AnimationProvider>(context, listen: false);
  return Stack(
    fit: StackFit.expand,
    children: [
      const AnimatedCanvas(),
      Container(
        color: Colors.black.withAlpha(50),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: radioModel.radioList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        radioModel.radioList[index]['name'] ?? 'N/A',
                        style: TextStyle(
                          fontWeight: radioModel.selectedStation['url'] == radioModel.radioList[index]['url'] ? FontWeight.w900 : FontWeight.w300,
                        ),
                      ),
                      onTap: () {
                        _handleListItemTap(context, index);
                        animationProvider.isRadioPlaying = true;
                      },
                      style: ListTileStyle.drawer,
                      textColor: radioModel.selectedStation['url'] == radioModel.radioList[index]['url'] ? Colors.limeAccent.shade700 : null,

                      // tileColor: radioModel.selectedStation['url'] == radioModel.radioList[index]['url'] ? Colors.limeAccent.shade700 : null,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25))),
                    );
                  }),
            ),
            SizedBox(height: 300, child: player(context, pageManager)),
          ],
        ),
      ),
    ],
  );
}

_handleListItemTap(BuildContext context, int index) {
  var radioModel = Provider.of<RadioModel>(context, listen: false);
  radioModel.selectedStation = radioModel.radioList[index];
  pageManager.play(context);
}

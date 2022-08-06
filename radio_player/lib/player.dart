import 'package:radio_player/page_manager.dart';
import 'package:radio_player/providers/radio_model.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget player(
  BuildContext context,
  PageManager pageManager,
) {
  return Column(
    children: [const Spacer(), progressBar(pageManager), playIcon(context, pageManager)],
  );
}

Widget progressBar(PageManager pageManager) {
  return (ValueListenableBuilder<ProgressBarState>(
    valueListenable: pageManager.progressNotifier,
    builder: (_, value, __) {
      return ProgressBar(
        progress: value.current,
        buffered: value.buffered,
        total: value.total,
        onSeek: pageManager.seek,
      );
    },
  ));
}

Widget playIcon(BuildContext context, PageManager pageManager) {
  return (ValueListenableBuilder<ButtonState>(
    valueListenable: pageManager.buttonNotifier,
    builder: (_, value, __) {
      switch (value) {
        case ButtonState.loading:
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 32.0,
            height: 32.0,
            child: const CircularProgressIndicator(),
          );
        case ButtonState.paused:
          return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: () {
                _handleSettingSelectedStation(context);
                pageManager.play(context);
              });
        case ButtonState.playing:
          return IconButton(
            icon: const Icon(Icons.pause),
            iconSize: 32.0,
            onPressed: pageManager.pause,
          );
      }
    },
  ));
}

_handleSettingSelectedStation(BuildContext context) {
  var radioModel = Provider.of<RadioModel>(context, listen: false);
  if (radioModel.selectedStation.isEmpty) {
    radioModel.selectedStation = radioModel.radioList[0];
  }
}

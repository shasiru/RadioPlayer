import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/page_manager.dart';
import 'package:radio_player/providers/animation_provider.dart';
import 'package:radio_player/providers/radio_model.dart';

import 'components/audio_wave_form_widget.dart';
import 'main.dart';

Widget player(BuildContext context, PageManager pageManager) {
  return Column(
    children: [
      const Spacer(),
      Container(padding: const EdgeInsets.only(bottom: 20), child: playIcon(context, pageManager)),
    ],
  );
}

Future<void> initWaveForm() async {
  final audioFile = File(p.join((await getTemporaryDirectory()).path, 'waveform.mp3'));
  try {
    await audioFile.writeAsBytes((await rootBundle.load('audio/waveform.mp3')).buffer.asUint8List());
    final waveFile = File(p.join((await getTemporaryDirectory()).path, 'waveform.wave'));
    JustWaveform.extract(audioInFile: audioFile, waveOutFile: waveFile).listen(progressStream.add, onError: progressStream.addError);
  } catch (e) {
    progressStream.addError(e);
  }
}

Widget waveFormContainer() {
  return (Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      child: Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.limeAccent.shade700,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.all(16.0),
          width: double.maxFinite,
          child: StreamBuilder<WaveformProgress>(
            stream: progressStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final progress = snapshot.data?.progress ?? 0.0;
              final waveform = snapshot.data?.waveform;
              if (waveform == null) {
                return Center(
                  child: Text(
                    '${(100 * progress).toInt()}%',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
              return AudioWaveformWidget(
                waveform: waveform,
                start: Duration.zero,
                duration: waveform.duration,
              );
            },
          ))));
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

      // var currentInSecs = minAndSecondsConvertor(value.current.inSeconds) != null ? '${minAndSecondsConvertor(value.current.inSeconds)}s' : '';
      // var currentInMins = minAndSecondsConvertor(value.current.inMinutes) != null ? '${minAndSecondsConvertor(value.current.inMinutes)}m :' : '';
      // var currentInHours = value.current.inHours != 0 ? value.current.inHours : null;
      // var currentInHoursDynamic = currentInHours != null ? '${currentInHours}h :' : '';
      // var simplifiedDuration = currentInHoursDynamic + currentInMins + currentInSecs;

      // return Text(simplifiedDuration);
    },
  ));
}

String? minAndSecondsConvertor(int value) {
  if (value >= 60) {
    return (value & 60).toString().padLeft(2, '0');
  }
  if (value == 0) {
    return null;
  }
  return value.toString().padLeft(2, '0');
}

Widget playIcon(BuildContext context, PageManager pageManager) {
  final animationProvider = Provider.of<AnimationProvider>(context, listen: false);
  return (ValueListenableBuilder<ButtonState>(
    valueListenable: pageManager.buttonNotifier,
    builder: (_, value, __) {
      switch (value) {
        case ButtonState.loading:
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 50.0,
            height: 50.0,
            child: const CircularProgressIndicator(),
          );
        case ButtonState.paused:
          return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 50.0,
              onPressed: () {
                _handleSettingSelectedStation(context);
                pageManager.play(context);
                animationProvider.isRadioPlaying = true;
              });
        case ButtonState.playing:
          return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 50.0,
              onPressed: () {
                pageManager.pause();
                animationProvider.isRadioPlaying = false;
              });
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

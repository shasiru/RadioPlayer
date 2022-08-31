import 'package:flutter/material.dart';

class AnimationProvider extends ChangeNotifier {
  bool _isRadioPlaying = false;

  bool get isRadioPlaying => _isRadioPlaying;

  set isRadioPlaying(bool data) {
    _isRadioPlaying = data;
    notifyListeners();
  }
}

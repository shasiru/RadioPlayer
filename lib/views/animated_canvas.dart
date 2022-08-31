import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_player/providers/animation_provider.dart';
import 'package:rive/rive.dart';

import '../main.dart';

class AnimatedCanvas extends StatefulWidget {
  const AnimatedCanvas({Key? key}) : super(key: key);

  @override
  State<AnimatedCanvas> createState() => _AnimatedCanvasState();
}

class _AnimatedCanvasState extends State<AnimatedCanvas> {
  @override
  void initState() {
    super.initState();
    animationController = SimpleAnimation(
      // the name of the animation should be matched to the name of the same animation on rive editor
      'Animation 1',
      autoplay: false,
      // mix: 0.01,
    );
  }

  void _togglePlay() {
    // setState(() => animationController.isActive = !animationController.isActive);
    final animationProvider = Provider.of<AnimationProvider>(context);
    animationController.isActive = animationProvider.isRadioPlaying;
  }

  bool get isPlaying => animationController.isActive;

  @override
  Widget build(BuildContext context) {
    _togglePlay();

    return animatedCanvas(context);
  }

  Widget animatedCanvas(
    BuildContext context,
  ) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            child: RiveAnimation.asset(
              'assets/3071-6499-planet-of-another-universe.riv',
              controllers: [animationController],
            )),
        // child: RiveAnimation.network(
        //   'https://cdn.rive.app/animations/vehicles.riv',
        //   controllers: [controller],
        // )),
        // waveFormContainer(),
      ],
    );
  }
}

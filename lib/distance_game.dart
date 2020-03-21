import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'the_world.dart';

class DistanceGame extends Game with TapDetector, PanDetector {

  final TheWorld ninjaWorld = TheWorld();

  Size size;

  DistanceGame(Size size) {
    this.size = size;
    print("size: $size");
    ninjaWorld.initializeWorld();
  }

  @override
  void render(Canvas canvas) {
    ninjaWorld.render(canvas);
  }

  @override
  void update(double t) {
    ninjaWorld.update(t);
  }

  @override
  void resize(Size size) {
    ninjaWorld.resize(size);
  }

  @override
  void onTapUp(TapUpDetails details) {
    ninjaWorld.handleTap(details.globalPosition);
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    ninjaWorld.handleDragUpdate(details);
  }

  @override
  void onPanEnd(DragEndDetails details) {
    ninjaWorld.handleDragEnd(details);
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'person_component.dart';


class TheWorld extends Box2DComponent {
  PersonComponent person0;
  PersonComponent ninja2;
  Random random = Random();
  TheWorld() : super(scale: 1.0, gravity: 0);

  void initializeWorld() {

    person0 = PersonComponent(this, 0, 0);
    person0.infected = true;
    add(person0);
    add(PersonComponent(this, -100, -100));
    add(PersonComponent(this, 100, 100));
    for (var nn = 0; nn < 12; nn++) {
      add(PersonComponent(
          this,
          50 + 20 * random.nextDouble(),
          50 + 20 * random.nextDouble(),
      ));
    }

    for (var nn = 0; nn < 12; nn++) {
      add(PersonComponent(
          this,
          100 + 20 * random.nextDouble(),
          100 + 20 * random.nextDouble(),
      ));
    }
  }

  @override
  void update(t) {
    super.update(t);
    //cameraFollow(ninja1, horizontal: 0.4, vertical: 1.0);
  }

  @override
  void render(canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, viewport.width, viewport.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff33aa33);
    canvas.drawRect(bgRect, bgPaint);
    super.render(canvas);
  }

  @override
  void resize(Size size) {
    print("resize: $size");
    super.resize(size);
  }

  void handleTap(Offset position) {
    print("handleTap: $position");
  }

  void handleDragUpdate(DragUpdateDetails details) {
    person0.handleDragUpdate(details);
  }

  void handleDragEnd(DragEndDetails details) {
    person0.handleDragEnd(details);
  }
}

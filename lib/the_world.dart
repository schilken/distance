import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'person_component.dart';

class TheWorld extends Box2DComponent implements ContactListener {
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;

  World world;

  PersonComponent person0;
  PersonComponent ninja2;
  Random random = Random();
  TheWorld() : super(scale: 1.0, gravity: 0);

  void initializeWorld() {
    final Vector2 _gravity = Vector2.zero();
    world = new World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    world.setContactListener(this);

    person0 = PersonComponent(this, -50, -50);
    person0.infected = true;

    person0.setVelocity(Vector2(1, 1), 10000.0);
    add(person0);

    for (var nn = 0; nn < 12; nn++) {
      add(PersonComponent(
        this,
        50 + 20 * random.nextDouble(),
        50 + 20 * random.nextDouble(),
      ));

      add(PersonComponent(
        this,
        50 + 20 * random.nextDouble(),
        150 + 20 * random.nextDouble(),
      ));

      add(PersonComponent(
        this,
        200 + 20 * random.nextDouble(),
        200 + 20 * random.nextDouble(),
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
    print("person0: $person0");
  }

  void handleDragUpdate(DragUpdateDetails details) {
    person0.handleDragUpdate(details);
  }

  void handleDragEnd(DragEndDetails details) {
    person0.handleDragEnd(details);
  }

  @override
  void beginContact(Contact contact) {
    var fudA = contact.fixtureA.userData as PersonComponent;
    var fudB = contact.fixtureB.userData as PersonComponent;
    //print("beginContact ${fudA.infected} ${fudB.infected}");
    if (fudA.infected || fudB.infected) {
      fudA.infected = true;
      fudB.infected = true;
    }
  }

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'person_component.dart';

class TheWorld extends Box2DComponent implements ContactListener {
  static const int WORLD_POOL_SIZE = 100;
  static const int WORLD_POOL_CONTAINER_SIZE = 10;
  static const double scale = 10.0;
  World world;

  PersonComponent person0;
  PersonComponent person1;
  Random random = Random();
  Timer impulsTrigger;
  TheWorld() : super(scale: scale, gravity: 0);

  int get random_7_14 {
    return 7 + random.nextInt(7);
  }

  PersonComponent addMovingPerson(Vector2 position, Offset impulse, PersonType type) {
    var person = PersonComponent(this, position, impulse, type);
//    person.impulse(impuls);
    add(person);
    return person;
  }

  void initializeWorld() {
    final Vector2 _gravity = Vector2.zero();
    world = World.withPool(
        _gravity, DefaultWorldPool(WORLD_POOL_SIZE, WORLD_POOL_CONTAINER_SIZE));
    world.setContactListener(this);

    person0 = addMovingPerson(Vector2(-28, -40), Offset(0.3, 0.4), PersonType.infected);
    impulsTrigger = Timer(Duration(seconds: 7), () {
      person0.impulse(Offset(-0.01, 0.01));
    });
    person1 = addMovingPerson(Vector2(-30, -39), Offset(0.3, 0.4), PersonType.insane);

    addMovingPerson(Vector2(-25, 20), Offset(0.05, 0.0), PersonType.sane);
    addMovingPerson(Vector2(-25, 19), Offset(0.05, 0.0), PersonType.sane);

    addMovingPerson(Vector2(25, 15), Offset(-0.05, 0.02), PersonType.sane);
    addMovingPerson(Vector2(-45, 6), Offset(0.05, 0.02), PersonType.sane);

    addMovingPerson(Vector2(15, -35), Offset(0.015, 0.06), PersonType.sane);
    addMovingPerson(Vector2(14, -35), Offset(-0.05, 0.02), PersonType.sane);

    List<Vector2> groupPositions = [
      Vector2(-12, 10),
      Vector2(5, 4),
      Vector2(-5, 3),
      Vector2(-14, 0),
      Vector2(-5, -10),
      Vector2(7, -5),
      Vector2(5, -15),
      Vector2(-3, 12),
    ];

    for (var position in groupPositions) {
      for (var nn = 0; nn < random_7_14; nn++) {
        add(
          PersonComponent(
            this,
            Vector2(
              position.x + 2 * random.nextDouble(),
              position.y + 2 * random.nextDouble(),
            ),
          ),
        );
      }
    }
  }

  @override
  void update(t) {
    super.update(t);
    //cameraFollow(person0, horizontal: 0.4, vertical: 1.0);
  }

  @override
  void render(canvas) {
    Rect bgRect = Rect.fromLTWH(0, 0, viewport.width * viewport.scale,
        viewport.height * viewport.scale);
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

  void handleTap(Offset position, {bool down}) {
    print("position: $position $down");
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
    if (fudA.personType == PersonType.infected || fudB.personType == PersonType.infected) {
      fudA.personType = PersonType.infected;
      fudB.personType = PersonType.infected;
    }
  }

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}

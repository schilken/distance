import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:box2d_flame/box2d.dart' hide Timer;
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'utils.dart';

class PersonComponent extends BodyComponent {
  static const num PERSON_RADIUS = 1.0;
  static int personCount = 0;

  ImagesLoader images = ImagesLoader();
  Random random = Random();
  bool infected = false;
  int id;
  Timer impulsTrigger;

  PersonComponent(box2d, double x0, double y0) : super(box2d) {
    id = personCount++;
    _loadImages();
    _createBody(x0, y0);
    if (random.nextInt(100) < 5) {
      impulsTrigger =
          Timer.periodic(Duration(seconds: random.nextInt(20) + 10), (_) {
        impulse(Offset(random.nextDouble() * 0.03, random.nextDouble() * 0.03));
      });
    }
    if (id == 0) {
      impulsTrigger = Timer(Duration(seconds: 3), () {
        impulse(Offset(-0.01, -0.01));
      });
    }
  }

  void _loadImages() {
    images.load("neutral", "icons8-neutral.png");
    images.load("sad", "icons8-sad.png");
  }

  @override
  void update(double t) {}

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }
    var image = infected ? images.get("sad") : images.get("neutral");
    paintImage(
        canvas: canvas,
        image: image,
        rect: Rect.fromCircle(center: center, radius: radius),
        flipHorizontally: false,
        fit: BoxFit.contain);
  }

  void _createBody(double x0, double y0) {
    final shape = CircleShape();
    shape.radius = PersonComponent.PERSON_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.99;
    activeFixtureDef.friction = 0.01;
    activeFixtureDef.userData = this;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = BodyDef();
    activeBodyDef.linearVelocity = Vector2(0.0, 0.0);
    activeBodyDef.position = Vector2(x0, y0);
    activeBodyDef.type = BodyType.DYNAMIC;
    //activeBodyDef.bullet = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    impulse(details.delta);
  }

  void handleDragEnd(DragEndDetails details) {
    impulse(details.velocity.pixelsPerSecond);
  }

  void impulse(Offset velocity) {
    print("impulse on person $id $velocity");
    Vector2 force = Vector2(velocity.dx, -velocity.dy)..scale(100.0);
    body.applyLinearImpulse(force, center, true);
  }

  void stop() {
    body.linearVelocity = Vector2(0.0, 0.0);
    body.angularVelocity = 0.0;
  }

  void setVelocity(Vector2 direction, double speed) {
    body.linearVelocity = direction;
    body.angularVelocity = speed;
//    body.applyForce(direction..scale(speed), center);
  }

  @override
  String toString() {
    return "linearVelocity ${body.linearVelocity} angularVelocity: ${body.angularVelocity}";
  }
}

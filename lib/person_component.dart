import 'dart:ui';

import 'package:box2d_flame/box2d.dart';
import 'package:flame/box2d/box2d_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

import 'utils.dart';

class PersonComponent extends BodyComponent {
  static const num PERSON_RADIUS = 10.0;

  ImagesLoader images = new ImagesLoader();

  bool idle;
  bool forward;
  bool infected = false;

  PersonComponent(box2d, double x0, double y0) : super(box2d) {
    _loadImages();
    _createBody(x0, y0);
  }

  void _loadImages() {
    images.load("neutral", "icons8-neutral.png");
    images.load("sad", "icons8-sad.png");
  }

  @override
  void update(double t) {
     this.idle = body.linearVelocity.x.abs() < 0.1 && body.linearVelocity.y.abs() < 0.1;
     this.forward = body.linearVelocity.x >= 0.0;
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    if (images.isLoading) {
      return;
    }
    var image = infected ? images.get("sad") : images.get("neutral");
    paintImage(
        canvas: canvas,
        image: image,
        rect: new Rect.fromCircle(center: center, radius: radius),
        flipHorizontally: false,
        fit: BoxFit.contain);
  }

  void _createBody(double x0, double y0) {
    final shape = new CircleShape();
    shape.radius = PersonComponent.PERSON_RADIUS;
    shape.p.x = 0.0;

    final activeFixtureDef = new FixtureDef();
    activeFixtureDef.shape = shape;
    activeFixtureDef.restitution = 0.0;
    activeFixtureDef.density = 0.75;
    activeFixtureDef.friction = 0.1;
    activeFixtureDef.userData = this;
    FixtureDef fixtureDef = activeFixtureDef;
    final activeBodyDef = new BodyDef();
    activeBodyDef.linearVelocity = new Vector2(0.0, 0.0);
    activeBodyDef.position = new Vector2(x0, y0);
    activeBodyDef.type = BodyType.DYNAMIC;
    activeBodyDef.bullet = true;
    BodyDef bodyDef = activeBodyDef;

    this.body = world.createBody(bodyDef)
      ..createFixtureFromFixtureDef(fixtureDef);
  }

  void input(Offset position) {
    Vector2 force =
    position.dx < 250 ? new Vector2(-1.0, 0.0) : new Vector2(1.0, 0.0);
    body.applyForce(force..scale(10000.0), center);
  }

  void handleDragUpdate(DragUpdateDetails details) {
    impulse(details.delta);
  }

  void handleDragEnd(DragEndDetails details) {
    impulse(details.velocity.pixelsPerSecond);
  }

  void impulse(Offset velocity) {
    Vector2 force = new Vector2(velocity.dx, -velocity.dy)..scale(100.0);
    body.applyLinearImpulse(force, center, true);
  }

  void stop() {
    body.linearVelocity = new Vector2(0.0, 0.0);
    body.angularVelocity = 0.0;
  }
}

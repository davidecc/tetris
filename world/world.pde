import shiffman.box2d.*; //<>//
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing world;
ArrayList<Polygon> polygons;
ArrayList<Boundary> boundaries;

void setup() {
  size(650, 650);
  smooth();

  world = new Box2DProcessing(this);
  world.createWorld();
  world.setGravity(0, -10);
  world.listenForCollisions();

  polygons = new ArrayList<Polygon>();
  boundaries = new ArrayList<Boundary>();

  // Add boundaries
  boundaries.add(new Boundary(0, height/2, height, 2, 0));
  boundaries.add(new Boundary(width, height/2, height, 4, 0));
  boundaries.add(new Boundary(width/2, height, 4, width, 0));
}

void draw() {
  background(255);
  world.step();

  for (Boundary b : boundaries) {
    b.display();
  }

  for (Polygon p : polygons) {
    p.display();
  }
}

void keyPressed() {
  if (key == ' ') {
    Polygon p = new Polygon(height / 2, width / 2);
    polygons.add(p);
  } else {
    Vec2 forceLeft = boundaries.get(0).attract(polygons.get(polygons.size() - 1));
    Vec2 forceRight = boundaries.get(1).attract(polygons.get(polygons.size() - 1));
    if (key == 'a') {
      polygons.get(polygons.size() - 1).applyForce(forceLeft);
    } else if (key == 'd') {
      polygons.get(polygons.size() - 1).applyForce(forceRight);
    }
  }
}

void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Polygon.class) {
    if (o2.getClass() == Boundary.class) {
      DistanceJointDef djd = new DistanceJointDef();
      djd.bodyA = b1;
      djd.bodyB = b2;
      djd.length = world.scalarPixelsToWorld(1000);
      djd.frequencyHz = 100;
      djd.dampingRatio = 1000;
    }
  } else if (o2.getClass() == Polygon.class) {
    if (o1.getClass() == Boundary.class) {
      Boundary b = (Boundary)o1;
      Polygon p = (Polygon)o2;
      b2.setGravityScale(0);
      b2.setLinearVelocity(new Vec2(0, 0));
      DistanceJointDef djd = new DistanceJointDef();
      djd.bodyA = b1;
      djd.bodyB = b2;
      djd.length = world.scalarPixelsToWorld(0);
      djd.frequencyHz = 0;
      djd.dampingRatio = 100;
    }
  }
}

void endContact(Contact cp) {
}
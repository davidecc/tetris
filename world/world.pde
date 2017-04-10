import java.awt.Color;
import java.util.concurrent.ThreadLocalRandom;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

int bgColor;
int windForce;
float centerWidth;
float centerHeight;
PImage bg;
boolean atStartup;
Center center;
Box2DProcessing world;
ArrayList<Polygon> polygons;
ArrayList<Boundary> boundaries;


void setup() {
  size(950, 650);
  smooth();
  
  bgColor = 25;
  windForce = 5000;
  centerWidth = width/4;
  centerHeight = height/4;
  atStartup = true;

  world = new Box2DProcessing(this);
  world.createWorld();
  world.listenForCollisions();
  world.setGravity(0, 0);

  center = new Center(width/2, height/2, centerWidth, centerHeight, new Color(0, 0, 0));
  polygons = new ArrayList<Polygon>();
  boundaries = new ArrayList<Boundary>();

  // Add boundaries
  boundaries.add(new Boundary(width/2, 0, 2, width, 0)); // ceilling
  boundaries.add(new Boundary(0, height/2, height, 2, 0)); // left wall
  boundaries.add(new Boundary(width, height/2, height, 4, 0)); // right wall
  boundaries.add(new Boundary(width/2, height, 4, width, 0)); // floor
  
  bg = loadImage("instruc.jpg");
}

void draw() {
  if (atStartup) {
    background(bg);
    return;
  }
  
  background(bgColor);
  world.step();
  
  if (frameCount % 200 == 0) {
    int randY = getRandomCorner();
    int randX = getRandomCorner();
    Polygon p = new Polygon(center.x + (randX*centerWidth), center.y + (randY*centerHeight));
    polygons.add(p);
    return;
  }

  displayObject(center);

  for (Boundary b : boundaries) {
    displayObject(b);
  }

  for (Polygon p : polygons) {
    displayObject(p);
    p.update();
  }
  
  for (int i = polygons.size() - 1; i >= 0; i--) {
    Polygon ply = polygons.get(i);
    if (ply.done()) {
      polygons.remove(i);
    }
  }
}

void displayObject(Object object) {
  Body body;
  if (object instanceof Polygon) {
    Polygon p = (Polygon)object;
    body = p.getBody();
    displayPolygonalObject(body, p.fillColor, true, 255);
  } else if (object instanceof Center) {
    Center c = (Center)object;
    displayBox(bgColor, 255, 1, c.x, c.y, c.w, c.h);
  } else if (object instanceof Boundary) {
    Boundary b = (Boundary)object;
    displayBox(255, 255, 1, b.x, b.y, b.w, b.h);
  } else { 
    println("Unknown object class");
    return;
  }
}

void displayPolygonalObject(Body body, Color colr, boolean wantFill, int stroke) {
  Vec2 position = world.getBodyPixelCoord(body);
  Fixture f = body.getFixtureList();
  PolygonShape ps = (PolygonShape) f.getShape();
  
  rectMode(CENTER);
  pushMatrix();
  translate(position.x, position.y);
  if (wantFill) {
    fill(colr.getRed(), colr.getGreen(), colr.getBlue());
  } else noFill();
  stroke(stroke);
  
  beginShape();
  for (int i = 0; i < ps.getVertexCount(); i++) {
    Vec2 v = world.vectorWorldToPixels(ps.getVertex(i));
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
  popMatrix();
}

void displayBox(int fillColor, int stroke, int strokeWeight, float x, float y, float w, float h) {
  fill(fillColor);
  stroke(stroke);
  strokeWeight(strokeWeight);
  rectMode(CENTER);
  pushMatrix();
  translate(x, y);
  rect(0,0, w, h);
  popMatrix();
}

int getRandomCorner() {
  int corner;
  int[] nums = {-1, 1};
  corner = nums[ThreadLocalRandom.current().nextInt(0, 1 + 1)];
  
  return corner;
}

void keyPressed() {
  Polygon p;
  Vec2 wind = null;
  
  switch (key) {
    case ' ': atStartup = false;
              wind = new Vec2(0, 0);
              break;
    case 'a': wind = new Vec2(windForce * -1, 0);
              break;
    case 's': wind = new Vec2(0, windForce * -1);
              break;
    case 'd': wind = new Vec2(windForce, 0);
              break; 
    case 'w': wind = new Vec2(0, windForce);
              break;
    case 'f': for (int i = polygons.size() - 1; i >= 0; i--) {
                Polygon ply = polygons.get(i);
                if (ply.done()) {
                  polygons.remove(i);
                }
               }
               break;
    case CODED: switch (keyCode) {

                  case LEFT: wind = new Vec2(windForce * -1, 0);
                             break;
                  case DOWN: wind = new Vec2(0, windForce * -1);
                            break;
                  case RIGHT: wind = new Vec2(windForce, 0);
                            break;
                  case UP: wind = new Vec2(0, windForce);
                            break;
                  default: wind = new Vec2(0, 0);
                }
                break;
    default: wind = new Vec2(0, 0);
  }
  
  try {
    p = polygons.get(polygons.size() -1);
  } catch (ArrayIndexOutOfBoundsException e) {
    println("Maybe polygons ArrayList is empty");
    p = null;
  }
  
  assert(wind != null);
  
  try {
    p.applyForce(wind);
  } catch (NullPointerException e) {
    println("Couldn't select any polygon");
  }
}

void gameOver() {
  textSize(48);
  fill(255);
  text(" ¡Perdiste!", center.x - centerWidth/2,  center.y - centerHeight);
  noLoop();
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  Body b1 = f1.getBody();
  Body b2 = f2.getBody(); 
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Polygon.class) {
    Polygon p = (Polygon)o1;
    if (o2.getClass() == Polygon.class) {
      Polygon p2 = (Polygon)o2;
      p2.hasCollided();
      p.hasCollided();
    } else if (o2.getClass() == Center.class) {
      gameOver();      
    } else if (o1.getClass() == Boundary.class) {
      p.hasCollided();
    }
  } else if (o2.getClass() == Polygon.class) {
    Polygon p = (Polygon)o2;
    if (o1.getClass() == Polygon.class) {
      Polygon p2 = (Polygon)o1;
      p2.hasCollided();
      p.hasCollided();
    } else if (o1.getClass() == Center.class) {
      gameOver();
    } else if (o1.getClass() == Boundary.class) {
      p.hasCollided();
    }
  }
}

void endContact(Contact cp) {}
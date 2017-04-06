class Polygon {
  Body body;
  Polygon(float x, float y) {
    makeBody(new Vec2(x, y));
  }
  
  void makeBody(Vec2 center) {
    PolygonShape ps = new PolygonShape();
    
    int nVertices = (int)random(3, 7);
    Vec2[] vertices = new Vec2[nVertices];
    
    for (int i = 0; i < nVertices; i++) {
      vertices[i] = world.vectorPixelsToWorld(new Vec2(random(-40, 40),random(-40, 40)));
    }
    
    ps.set(vertices, vertices.length);
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(world.coordPixelsToWorld(center));
    body = world.createBody(bd);
    
    body.createFixture(ps, 1.0);
    
    body.setUserData(this);
  }
  
  void display() {
    Vec2 pos = world.getBodyPixelCoord(body);
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();
    
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    fill(175);
    stroke(0);
    beginShape();
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = world.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }
  
  void applyForce(Vec2 v) {
    body.applyForce(v, body.getWorldCenter());
  }
}
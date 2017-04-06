class Boundary {
  float x, y, w, h;
  Body body;
  
  Boundary(float x, float y, float h, float w, float a) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    // Define the polygon
    PolygonShape ps = new PolygonShape();
    float worldWidth = world.scalarPixelsToWorld(w/2);
    float worldHeight = world.scalarPixelsToWorld(h/2);
    ps.setAsBox(worldWidth, worldHeight);
    
    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(world.coordPixelsToWorld(this.x, this.y));
    body = world.createBody(bd);
    
    // Attached the shapee to the body using a Fixture
    body.createFixture(ps, 1);
    
    body.setUserData(this);
  }
  
  void display() {
    fill(0);
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    pushMatrix();
    translate(this.x, this.y);
    rect(0,0, this.w, this.h);
    popMatrix();
  }
  
  // Formula for gravitational attraction
  Vec2 attract(Polygon p) {
    float G = 1000;
    Vec2 pos = body.getWorldCenter();
    Vec2 polygonPos = p.body.getWorldCenter();
    // Vector pointing from polygon to boundary
    Vec2 force = pos.sub(polygonPos);
    float distance = force.length();
    // Keep force within bounds
    distance = constrain(distance, 1, 5);
    force.normalize();
    float strength = (G * 1 * p.body.m_mass) / (distance * distance); // Calculate gravitational force magnitude
    force.mulLocal(strength); // Get force vector --> magnitude * direction
    
    return force;
  }
}
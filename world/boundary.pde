class Boundary {
  float x, y, w, h;
  Body body;
  int type = 100;
  
  Boundary(float x, float y, float h, float w, float a) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    float worldWidth = world.scalarPixelsToWorld(w/2);
    float worldHeight = world.scalarPixelsToWorld(h/2);
    
    // Define the polygon
    PolygonShape ps = new PolygonShape();
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
  
  public Body getBody() {
    return this.body;
  }
}
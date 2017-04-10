class Center {
  public Color fillColor;
  public float x, y, w, h;
  private Body body;
  private Fixture fixture;
  
  Center(float x, float y, float w, float h, Color fillColor) {
    this.x = x;
    this.y = y;
    this.w = w;    
    this.h = h; 
    Vec2 location = new Vec2(x, y);
    this.fillColor = fillColor;
    this.body = BodyUtility.makeBoxBody(world, this, BodyType.STATIC, location);
    this.fixture = BodyUtility.createBoxFixture(this.body, world.scalarPixelsToWorld(w/2), world.scalarPixelsToWorld(h/2));
    //this.body.setActive(true);
    //this.body.setAwake(false);
    //this.fixture.setFriction(0);
    //this.fixture.setDensity(0);
}
  
  public Body getBody() {
    return this.body;
  }
}
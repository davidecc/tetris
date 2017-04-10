class Polygon {
  int type;
  int ofSameType;
  boolean isStatic;
  Body body;
  Color[] colors = {new Color(168, 164, 160), new Color(84, 83, 81), new Color(142, 120, 105)};
  Color fillColor;
  Fixture fixture;
  
  Polygon(float x, float y) {
    Vec2 location = new Vec2(x, y);
    this.isStatic = false;
    this.type = ThreadLocalRandom.current().nextInt(0, 2 + 1);
    this.fillColor = colors[type];
    this.body = BodyUtility.makePolygonalBody(world, this, BodyType.DYNAMIC, location);
    this.fixture = BodyUtility.createPolygonalFixture(world, this.body, 8, 40);

    Vec2 vel = BodyUtility.generateVelocityVec(10);
    this.body.setLinearVelocity(vel);
  }
  
  public Body getBody() {
    return this.body;
  }
 
  void applyForce(Vec2 v) {
    ContactEdge cl = body.getContactList();
    if (cl == null)
      body.applyForce(v, body.getWorldCenter());
      //body.applyLinearImpulse(v, body.getWorldCenter(), true);
  }

  void update() {
    ofSameType = howManyCanReachOfSameType(type, null);
  }

  int howManyCanReachOfSameType(int t, ArrayList<Polygon> v) {
    
    ArrayList<Polygon> visited = v;
    int ofSameType = 1;
    ContactEdge cl = body.getContactList();
    if (visited == null) {
      visited = new ArrayList<Polygon>();
    }
    
    if(visited.contains(this)) return 0;
    else visited.add(this);
    
    if (type != t) return 0;
        
    while (cl != null) {
      Body otherBody = cl.other;
      Polygon otherPolygon;
      try {
        otherPolygon = (Polygon)otherBody.getUserData();
      } catch (ClassCastException e) {
        cl = cl.next;
        continue;
      } 
      ofSameType += otherPolygon.howManyCanReachOfSameType(t, visited);
      cl = cl.next;
    }
    
    return ofSameType;
  }

  boolean done() { 
    Polygon p = (Polygon)body.getUserData();
    if (p.ofSameType >= 3) {
      killBody();
      return true;
    }
    
    return false;
  }
  
  void killBody() {
    world.destroyBody(body);
  }
  
  void hasCollided() {
    isStatic = true;
    fixture.setFriction(1000000);
    body.setLinearVelocity(new Vec2(0, 0));
  }
}
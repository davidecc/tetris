// TODO: Implement a way to build boundaries also

public static class BodyUtility {
  public static Body makePolygonalBody(Box2DProcessing world, Object caller, BodyType type, Vec2 center) {
    Body body;
    BodyDef definition = definePolygonalBody(world, type, center);
    body = world.createBody(definition);
    body.setUserData(caller);
    
    return body;
  }
  
  public static Fixture createPolygonalFixture(Box2DProcessing world, Body body, int nVertices, int vSize) {
    Fixture fixture;
    PolygonShape ps = new PolygonShape();
    Vec2[] vertices = makeVertices(world, nVertices, vSize);
    ps.set(vertices, vertices.length);
    fixture = body.createFixture(ps, 1.0);
    
    return fixture;
  }
  
  private static BodyDef definePolygonalBody(Box2DProcessing world, BodyType bodyType, Vec2 position) {
    BodyDef definition = new BodyDef();
    definition.type = bodyType;
    definition.position.set(world.coordPixelsToWorld(position));
    
    return definition;
  }
  
  private static Vec2[] makeVertices(Box2DProcessing world, int nVertices, int vSize) {
    Vec2[] vertices = new Vec2[nVertices];
    for (int i = 0; i < nVertices; i++) {
      int randInt1 = ThreadLocalRandom.current().nextInt(vSize * -1, vSize + 1);
      int randInt2 = ThreadLocalRandom.current().nextInt(vSize * -1, vSize + 1);
      Vec2 v = new Vec2(randInt1, randInt2);
        vertices[i] = world.vectorPixelsToWorld(v);
    }
    
    return vertices;
  }
  
  public static Body makeBoxBody(Box2DProcessing world, Object caller, BodyType type, Vec2 center) {
    Body body;
    BodyDef definition = defineBoxBody(world, type, center);
    body = world.createBody(definition);
    body.setUserData(caller);
    
    return body;
  }
  
  public static Fixture createBoxFixture(Body body, float w, float h) {
    Fixture fixture;
    PolygonShape ps = new PolygonShape();
    ps.setAsBox(w, h);
    fixture = body.createFixture(ps, 1.0);
    
    return fixture;
  }
  
  private static BodyDef defineBoxBody(Box2DProcessing world, BodyType bodyType, Vec2 position) {
    BodyDef definition = new BodyDef();
    definition.type = bodyType;
    definition.position.set(world.coordPixelsToWorld(position));
    
    return definition;
  }
  
  public static Vec2 generateVelocityVec(int multiplier) {
    int randInt1 = ThreadLocalRandom.current().nextInt(-360, 360);
    int randInt2 = ThreadLocalRandom.current().nextInt(-360, 360);
    Vec2 vel = new Vec2(randInt1, randInt2);
    vel.normalize();
    vel.mulLocal(multiplier);
    
    return vel;
  }
}
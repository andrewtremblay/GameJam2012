//
//  BulletSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "BulletSprite.h"

@implementation BulletSprite
@synthesize velocity = _velocity;
- (void)updatePhysicsBoxWithPoint:(CGPoint)p {
    
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_dynamicBody;
    bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&bodyDefPoly);
    
    b2PolygonShape polygon;
    polygon.SetAsBox(4.0f/PTM_RATIO, 4.0f/PTM_RATIO);
    
    b2FixtureDef fixtureDefPoly;
    fixtureDefPoly.shape = &polygon;
    fixtureDefPoly.density = 1.0f;
    fixtureDefPoly.friction = 0.3f;
    polyBody->CreateFixture(&fixtureDefPoly);
    
	[self setPhysicsBody:polyBody];
}


@end

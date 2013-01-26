//
//  BulletSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "BulletSprite.h"
#import "SpriteManager.h"

@implementation BulletSprite
@synthesize velocity = _velocity;
@synthesize shot = _shot;

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
    
    fixtureDefPoly.filter.categoryBits = kBulletCategoryBit;
    fixtureDefPoly.filter.maskBits = kBulletCollideMask;
    polyBody->CreateFixture(&fixtureDefPoly);
    
    polyBody->SetUserData(self);
    
	[self setPhysicsBody:polyBody];
}

-(bool)outOfBounds
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    b2Vec2 bodyPos = self.getPhysicsBody->GetPosition();
   // NSLog(@"%f, %f", bodyPos.x, bodyPos.y);
     
    
    return (bodyPos.x > s.width/PTM_RATIO  || bodyPos.x < 0)
    || (bodyPos.y > s.height/PTM_RATIO  || bodyPos.y < 0);
}

@end

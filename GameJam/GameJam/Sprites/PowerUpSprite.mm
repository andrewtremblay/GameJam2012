//
//  PowerUpSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "PowerUpSprite.h"

@implementation PowerUpSprite


- (void)updatePhysicsBoxWithPoint:(CGPoint)p {
    
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_dynamicBody;
    bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&bodyDefPoly);
    
    b2CircleShape circle;
    circle.m_radius = 10.0f/PTM_RATIO;
    
//    b2PolygonShape polygon;
//    polygon.SetAsBox(4.0f/PTM_RATIO, 4.0f/PTM_RATIO);
    
    b2FixtureDef fixtureDefPoly;
    fixtureDefPoly.shape = &circle;
    fixtureDefPoly.density = 1.0f;
    fixtureDefPoly.friction = 0.3f;
    fixtureDefPoly.filter.categoryBits = kPowerupCategoryBit; 
    fixtureDefPoly.filter.maskBits = kPowerupCollideMask;
    polyBody->CreateFixture(&fixtureDefPoly);
    polyBody->SetUserData(self);

	[self setPhysicsBody:polyBody];
}


@end

//
//  CharacterSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CharacterSprite.h"
#import "MinionSprite.h"
#import "PowerUpSprite.h"
#import "EventsManager.h"

#define kMAXHEIGHT  40.0f
#define kMAXWIDTH   40.0f

@implementation CharacterSprite
@synthesize vert = _vert;
@synthesize vertCount = _vertCount;

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count {
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_dynamicBody;//b2_dynamicBody; //b2_kinematicBody
    bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&bodyDefPoly);
    
    b2PolygonShape polygon;
    float w = kMAXWIDTH;
    switch (count) {
        case 3: {
            b2Vec2 vertices[3];
            vertices[0].Set(w/2 / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(w / PTM_RATIO,w/PTM_RATIO);
            vertices[2].Set(0.0f/PTM_RATIO,w/PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
        case 4: {
            b2Vec2 vertices[4];
            vertices[0].Set(0.0f / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(kMAXWIDTH / PTM_RATIO,0.0f/PTM_RATIO);
            vertices[2].Set(kMAXWIDTH/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
        case 5: {
            b2Vec2 vertices[4];
            vertices[0].Set((w/2) / PTM_RATIO , 0.0f / PTM_RATIO);
            vertices[1].Set(w / PTM_RATIO,(w/3)/PTM_RATIO);
            vertices[2].Set((w*(3/4))/PTM_RATIO,w/PTM_RATIO);
            vertices[3].Set(w*(1/4)/PTM_RATIO,w/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,(w/3)/PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
    }

    
    b2FixtureDef fixtureDefPoly;
    fixtureDefPoly.shape = &polygon;
    fixtureDefPoly.density = 1.0f;
    fixtureDefPoly.friction = 0.3f;
    fixtureDefPoly.filter.categoryBits = kMainCharCategoryBit;
    fixtureDefPoly.filter.maskBits = kMainCharCollideMask;
    polyBody->CreateFixture(&fixtureDefPoly);
    polyBody->SetUserData(self);

	[self setPhysicsBody:polyBody];
}

- (void)createBullets {
    for (int i=0; i<self.vertCount ; i++) {
        CGPoint p = CGPointMake(self.vert[i].x, self.vert[i].y);
        [[SpriteManager shared] makeBulletAtPosition:p];
    }
}

- (void)shoot
{
    
}


//helper getters
-(CGPoint)positionMeters
{
    b2Vec2 charPos = self.getPhysicsBody->GetPosition();
    return CGPointMake(charPos.x, charPos.y);
}
-(CGPoint)positionPixels
{
    return ccpMult(self.positionMeters, PTM_RATIO);
}

//collision
-(void)collidedWith:(PhysicsSprite*)collidee
{
    if([collidee isKindOfClass:[MinionSprite class]]){
        [[EventsManager shared] aCharacterSprite:self hitEnemy:(MinionSprite *)collidee];
    }else if([collidee isKindOfClass:[PowerUpSprite class]]){
        [[EventsManager shared] aCharacterSprite:self hitPowerup:(PowerUpSprite *)collidee];        
    }else {
        //default no action
    }
}

@end

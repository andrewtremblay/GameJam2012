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

#define kMaxVerts 10
#define kMinVerts 3


#define kMAXHEIGHT  40.0f
#define kMAXWIDTH   40.0f



@implementation CharacterSprite
@synthesize vert = _vert;
@synthesize vertCount = _vertCount; //alweays holds the most up to date desired vert count
@synthesize lastVertCount = _lastVertCount; //for update safety/speed

@synthesize polygon = _polygon;
@synthesize bodyDefPoly = _bodyDefPoly;
@synthesize fixtureDefPoly = _fixtureDefPoly;

- (void)safeUpdateVertices
{
    if(self.lastVertCount != self.vertCount){
        [self updateVertCount:self.vertCount];
        self.lastVertCount = self.vertCount;
    }
}


-(void)updateVertCount:(int)vertCount
{
    //TODO: clamp this
    self.vertCount = vertCount;
    
    float w = kMAXWIDTH;
    
    b2PolygonShape shape;

    switch (vertCount) {
        case 3: {
            b2Vec2 vertices[3];
            vertices[0].Set(w/2 / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(w / PTM_RATIO,w/PTM_RATIO);
            vertices[2].Set(0.0f/PTM_RATIO,w/PTM_RATIO);
            shape.Set(vertices, vertCount);
            self.vert = vertices;
        }break;
        case 4: {
            b2Vec2 vertices[4];
            vertices[0].Set(0.0f / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(kMAXWIDTH / PTM_RATIO,0.0f/PTM_RATIO);
            vertices[2].Set(kMAXWIDTH/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            shape.Set(vertices, vertCount);
            self.vert = vertices;
        }break;
        case 5: {
            b2Vec2 vertices[5];
            vertices[0].Set((w/2) / PTM_RATIO , 0.0f / PTM_RATIO);
            vertices[1].Set(w / PTM_RATIO,(w/3)/PTM_RATIO);
            vertices[2].Set((w*(3/4))/PTM_RATIO,w/PTM_RATIO);
            vertices[3].Set(w*(1/4)/PTM_RATIO,w/PTM_RATIO);
            vertices[4].Set(0.0f/PTM_RATIO,(w/3)/PTM_RATIO);
            shape.Set(vertices, vertCount);
            self.vert = vertices;
        }break;
    }


    b2Vec2 charPos; //previous char Position;
    float charRot; //previous char Rotation;
    if(self.getPhysicsBody){
        charPos = self.getPhysicsBody->GetPosition();
        charRot = self.getPhysicsBody->GetAngle();
        self.getPhysicsBody->SetActive(false);
        [SpriteManager shared].worldLayer.getWorld->DestroyBody(self.getPhysicsBody);
    }
    
    //we will make a new body
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&_bodyDefPoly);
//    fixtureDefPoly b2FixtureDef
    _fixtureDefPoly.shape = &shape;
    _fixtureDefPoly.density = 1.0f;
    _fixtureDefPoly.friction = 0.3f;
    _fixtureDefPoly.filter.categoryBits = kMainCharCategoryBit;
    _fixtureDefPoly.filter.maskBits = kMainCharCollideMask;
    polyBody->CreateFixture(&_fixtureDefPoly);
    polyBody->SetUserData(self);
    polyBody->SetTransform(charPos, charRot);
    [self setPhysicsBody:polyBody];

    
}

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count {
    _bodyDefPoly.type = b2_dynamicBody;//b2_dynamicBody; //b2_kinematicBody
    _bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&_bodyDefPoly);
    
    //just put in whatever it's just gonna get blown away
    b2Vec2 vertices[3];
    float w = kMAXWIDTH;
    vertices[0].Set(w/2 / PTM_RATIO,0.0f / PTM_RATIO);
    vertices[1].Set(w / PTM_RATIO,w/PTM_RATIO);
    vertices[2].Set(0.0f/PTM_RATIO,w/PTM_RATIO);
    _polygon.Set(vertices, count);

    
    _fixtureDefPoly.shape = &_polygon;
    _fixtureDefPoly.density = 1.0f;
    _fixtureDefPoly.friction = 0.3f;
    _fixtureDefPoly.filter.categoryBits = kMainCharCategoryBit;
    _fixtureDefPoly.filter.maskBits = kMainCharCollideMask;
    polyBody->CreateFixture(&_fixtureDefPoly);
    [self setPhysicsBody:polyBody];

    [self updateVertCount:count];
    
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

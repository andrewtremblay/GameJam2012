//
//  MinionSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "MinionSprite.h"
#define kMAXHEIGHT  30.0f
#define kMAXWIDTH   30.0f


@implementation MinionSprite
@synthesize vert = _vert;
@synthesize vertCount = _vertCount;
- (void)createBullets {
    for (int i=0; i<self.vertCount ; i++) {
        CGPoint p = CGPointMake(self.vert[i].x, self.vert[i].y);
        [[SpriteManager shared] makeBulletAtPosition:p];
    }
}

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count {
    
    
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_dynamicBody;
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
    fixtureDefPoly.filter.categoryBits = kEnemyCategoryBit; 
    fixtureDefPoly.filter.maskBits = kEnemyCollideMask; 
    polyBody->CreateFixture(&fixtureDefPoly);
    
	[self setPhysicsBody:polyBody];
}


@end

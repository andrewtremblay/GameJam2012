//
//  CharacterSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CharacterSprite.h"
#import <GLKit/GLKit.h>
#import "SpriteManager.h"
#define PTM_RATIO 32
#define kMAXHEIGHT  40.0f
#define kMAXWIDTH   40.0f

@implementation CharacterSprite


- (void) draw {
    // open yellow poly
	glColor4ub(255, 255, 0, 255);
	glLineWidth(10);
	CGPoint vertices[] = { ccp(0,0), ccp(10,10), ccp(10,20), ccp(20,20), ccp(10,30) };
	ccDrawPoly( vertices, 5, NO);
    
    // closed purble poly
	glColor4ub(255, 0, 255, 255);
	glLineWidth(2);
	CGPoint vertices2[] = { ccp(30,130), ccp(30,230), ccp(50,200) };
	ccDrawPoly( vertices2, 3, YES);
}


- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count {
    
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_kinematicBody;//b2_dynamicBody;
    bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&bodyDefPoly);
    
    b2PolygonShape polygon;
    
    switch (count) {
        case 3: {
            b2Vec2 vertices[3];
            vertices[0].Set(kMAXWIDTH/2 / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(kMAXWIDTH / PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[2].Set(0.0f/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            polygon.Set(vertices, count);
        }break;
        case 4: {
            b2Vec2 vertices[4];

            vertices[0].Set(0.0f / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(kMAXWIDTH / PTM_RATIO,0.0f/PTM_RATIO);
            vertices[2].Set(kMAXWIDTH/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            polygon.Set(vertices, count);
        }break;
        case 5: {
            b2Vec2 vertices[4];
            
            vertices[0].Set((kMAXWIDTH/2) / PTM_RATIO,0.0f / PTM_RATIO);
            vertices[1].Set(kMAXWIDTH / PTM_RATIO,(kMAXWIDTH/3)/PTM_RATIO);
            vertices[2].Set((kMAXWIDTH*(3/4))/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[3].Set(kMAXWIDTH*(1/4)/PTM_RATIO,kMAXWIDTH/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,(kMAXWIDTH/3)/PTM_RATIO);
            polygon.Set(vertices, count);
        }break;
    }

    b2FixtureDef fixtureDefPoly;
    fixtureDefPoly.shape = &polygon;
    fixtureDefPoly.density = 1.0f;
    fixtureDefPoly.friction = 0.3f;
    fixtureDefPoly.userData = self;
    polyBody->CreateFixture(&fixtureDefPoly);
    
	[self setPhysicsBody:polyBody];
}

@end

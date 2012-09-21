//
//  CharacterSprite.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CCSprite.h"
#import "PhysicsSprite.h"
#import <GLKit/GLKit.h>
#import "SpriteManager.h"


@interface CharacterSprite : PhysicsSprite

@property (nonatomic, assign) int health;
-(void)getHealth;
-(void)getBulletVelocitites;


@property (nonatomic, assign)b2Vec2* vert;
@property (nonatomic, assign) int vertCount;
@property (nonatomic, assign) int lastVertCount;

@property (nonatomic, strong) NSMutableArray* bulletVectors; //(current) forces for the bullets to use on initialization (adjust for rotation)
@property (nonatomic, strong) NSMutableArray* bulletEmitPoints; //(current) points for the bullets to pop out from (adjust for rotation)

@property (nonatomic, strong) NSDictionary* bulletMasterVars; //master dictionary for the initital positions and velocities for the different bullet types

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count;
- (void)updateVertCount:(int)vertCount;


- (void)safeUpdateVertices;

- (void)createBullets;
- (void)shoot; //separate from create for when we eventually want to recycle

//helper getters
-(CGPoint)positionMeters;
-(CGPoint)positionPixels;


@property (nonatomic, assign) b2PolygonShape polygon;
@property (nonatomic, assign) b2BodyDef bodyDefPoly;
@property (nonatomic, assign) b2FixtureDef fixtureDefPoly;

@end

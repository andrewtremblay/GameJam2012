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

@property (nonatomic, assign)b2Vec2* vert;
@property (nonatomic, assign) int vertCount;

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count;
- (void)createBullets;
- (void)shoot; //separate from create for when we eventually want to recycle

//helper getters
-(CGPoint)positionMeters;
-(CGPoint)positionPixels;

@end

//
//  MinionSprite.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CCSprite.h"
#import "PhysicsSprite.h"
#import <GLKit/GLKit.h>
#import "SpriteManager.h"

@interface MinionSprite : PhysicsSprite
@property (nonatomic, assign) BOOL dead;


@property (nonatomic, assign)b2Vec2* vert;
@property (nonatomic, assign) int vertCount;

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count;
- (void)createBullets;
@end

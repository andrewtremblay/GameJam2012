//
//  BulletSprite.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CCSprite.h"
#import "PhysicsSprite.h"
#import <GLKit/GLKit.h>
#import "SpriteManager.h"

@interface BulletSprite : PhysicsSprite
@property (nonatomic, assign)CGPoint velocity;

- (void)updatePhysicsBoxWithPoint:(CGPoint)p;

@end

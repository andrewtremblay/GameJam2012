//
//  CharacterSprite.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "CCSprite.h"
#import "PhysicsSprite.h"

@interface CharacterSprite : PhysicsSprite

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count;

@end

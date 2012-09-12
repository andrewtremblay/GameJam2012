//
//  SpriteManager.h
//  jamTestGo
//
//  Created by Andrew Tremblay on 9/11/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
#import "PhysicsSprite.h"
#import "CharacterSprite.h"


@interface SpriteManager : NSObject
    +(SpriteManager*)shared;
    @property (strong, nonatomic) CCTexture2D* spriteTexture;
    @property (strong, nonatomic) GameLayer *worldLayer;
    -(PhysicsSprite *) addNewSpriteAtPosition:(CGPoint)p;   
    -(CharacterSprite *) addNewCharacterSpriteAtPosition:(CGPoint)p;

//
@end

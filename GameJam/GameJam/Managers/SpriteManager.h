//
//  SpriteManager.h
//  jamTestGo
//
//  Created by Andrew Tremblay on 9/11/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLayer.h"
#import "CharacterSprite.h"
#import "MinionSprite.h"
#import "PowerUpSprite.h"
#import "BulletSprite.h"

@interface SpriteManager : NSObject
    +(SpriteManager*)shared;
    @property (strong, nonatomic) CCTexture2D* spriteTexture;
    @property (strong, nonatomic) GameLayer *worldLayer;

    @property (strong, nonatomic) NSMutableArray *enemiesArray;

#pragma mark Makers
    -(void)makeNewSpriteAtPosition:(CGPoint)p;
    -(id)makeCharacterAtPosition:(CGPoint)p;
    -(id)makeBulletAtPosition:(CGPoint)p;
    -(id)makePowerUpAtPosition:(CGPoint)p;
    -(id)makeMinionAtPosition:(CGPoint)p;

#pragma mark Updaters
    -(void)stopAllEnemies;
    -(void)updateAllEnemySeekPosition:(CGPoint)p; //no flags for this, just setting velocity
    -(void)updateAllEnemyAvoidPosition:(CGPoint)p;

#pragma mark Cleanups
    -(void)cleanSpentPowerups;
    -(void)cleanEnemyCorpses;
    -(void)cleanBullets;

@end

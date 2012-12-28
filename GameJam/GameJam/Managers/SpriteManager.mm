//
//  SpriteManager.m
//  jamTestGo
//
//  Created by Andrew Tremblay on 9/11/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//
#import "PhysicsSprite.h"
#import "SpriteManager.h"
#import "ControlManager.h"


#define kEnemyMaxSpeed 5.0f

static SpriteManager* s_spriteManager;

@implementation SpriteManager
    @synthesize spriteTexture = _spriteTexture;
    @synthesize worldLayer = _worldLayer;

    @synthesize enemiesArray = _enemiesArray;
    @synthesize bulletArray = _bulletArray;
    @synthesize powerUpArray = _powerUpArray;

    +(SpriteManager*)shared {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_spriteManager = [[SpriteManager alloc] init];
        });
        return s_spriteManager;
    }

    -(void)setWorldLayer:(GameLayer *)worldLayer
    {
        _worldLayer = worldLayer;
        //Set up spritesheet and CCSpriteBatchNode
        // Use batch node. Faster
        CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blackTexture.png" capacity:100];
        self.spriteTexture = [parent texture];
        [self.worldLayer addChild:parent z:0 tag:kTagParentNode];
        self.enemiesArray = [NSMutableArray array];
        self.bulletArray = [NSMutableArray array];
        self.powerUpArray = [NSMutableArray array];
    //    CGSize s = [CCDirector sharedDirector].winSize;
    //    [self addNewSpriteAtPosition:ccp(s.width/2, s.height/2)]; //delete this, but good for debugging
    }

    #pragma mark Makers
    - (CharacterSprite *)makeCharacterAtPosition:(CGPoint)p
    {
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        CharacterSprite* cSprite = [[CharacterSprite alloc] initWithTexture:self.spriteTexture];
        [parent addChild:cSprite];
        cSprite.position = ccp(p.x,p.y);
        [cSprite updatePhysicsBoxWithPoint:p numberOfVertex:3];
        return cSprite;
    }
    - (BulletSprite *)makeBulletAtPosition:(CGPoint)p
    {
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        BulletSprite* sprite = [[BulletSprite alloc] initWithTexture:self.spriteTexture];
        [parent addChild:sprite];
        sprite.position = ccp(p.x,p.y);
        [sprite updatePhysicsBoxWithPoint:p];
        [self.bulletArray addObject:sprite];

        return sprite;
    }

    - (PowerUpSprite *)makePowerUpAtPosition:(CGPoint)p
    {
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        PowerUpSprite* sprite = [[PowerUpSprite alloc] initWithTexture:self.spriteTexture];
        [parent addChild:sprite];
        sprite.position = ccp(p.x,p.y);
        [sprite updatePhysicsBoxWithPoint:p];
        
        [self.powerUpArray addObject:sprite];
        
        return sprite;
    }

    - (MinionSprite *)makeMinionAtPosition:(CGPoint)p
    {
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        MinionSprite* sprite = [[MinionSprite alloc] initWithTexture:self.spriteTexture];
        [parent addChild:sprite];
        sprite.position = ccp(p.x,p.y);
        [sprite updatePhysicsBoxWithPoint:p numberOfVertex:3];
        
        [self.enemiesArray addObject:sprite]; 
        
        return sprite;
    }

    -(void) makeNewSpriteAtPosition:(CGPoint)p
    {
        CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        
        //We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
        //just randomly picking one of the images
        int idx = (CCRANDOM_0_1() > .5 ? 0:1);
        int idy = (CCRANDOM_0_1() > .5 ? 0:1);
        PhysicsSprite *sprite = [PhysicsSprite spriteWithTexture:self.spriteTexture rect:CGRectMake(32 * idx,32 * idy,32,32)];
        [parent addChild:sprite];
   
        sprite.position = ccp( p.x, p.y);
        
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;//b2_dynamicBody; //b2_kinematicBody
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        b2Body *body = self.worldLayer.getWorld->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
    //    fixtureDef.filter. //none given, default 
        body->CreateFixture(&fixtureDef);
        
        [sprite setPhysicsBody:body];
    }

#pragma mark Updaters
    -(void)setVelocityOfBullet:(BulletSprite *)bulletToChange newVelocity:(CGPoint)newVel relativeToCharSprite:(BOOL)adjust{
        b2Body *b = bulletToChange.getPhysicsBody;
        b2Vec2 velVect = b2Vec2(newVel.x,newVel.y);
        
        if(adjust){
          b2Body *charB = [[[ControlManager shared] charSprite] getPhysicsBody]; 
          float angle = charB->GetAngle();
            b2Rot r; 
            r.Set(angle);
            velVect = b2Mul(r, velVect);
        } 
        b->SetLinearVelocity(velVect);

    }


    -(void)stopAllEnemies
    {
        for(MinionSprite* enemySprite in self.enemiesArray){
            b2Body *b = enemySprite.getPhysicsBody;
            b->SetLinearVelocity(b2Vec2(0,0));
        }
    }

    -(void)updateAllEnemySeekPosition:(CGPoint)p;
    {
        for(MinionSprite* enemySprite in self.enemiesArray){
            //calc velocity (look into gravity instead?)
            CGPoint adjustedPoint = ccp(p.x/PTM_RATIO, p.y/PTM_RATIO);
            b2Vec2 enemPos = enemySprite.getPhysicsBody->GetPosition();
            CGPoint vel = CGPointZero;
            if(fabsf(enemPos.x - adjustedPoint.x) > 1){
                vel.x = (adjustedPoint.x - enemPos.x);
            }
            if(fabsf(enemPos.y - adjustedPoint.y) > 1){
                vel.y = (adjustedPoint.y - enemPos.y);
            }
            vel.x = clampf(vel.x, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            vel.y = clampf(vel.y, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            b2Body *b = enemySprite.getPhysicsBody;
            b->SetLinearVelocity(b2Vec2(vel.x,vel.y));

        }
    }

    -(void)updateAllEnemyAvoidPosition:(CGPoint)p;
    {
        for(MinionSprite* enemySprite in self.enemiesArray){
            //calc velocity (look into gravity instead?)
            CGPoint adjustedPoint = ccp(p.x/PTM_RATIO, p.y/PTM_RATIO);
            b2Vec2 enemPos = enemySprite.getPhysicsBody->GetPosition();
            CGPoint vel = CGPointZero;
            if(fabsf(enemPos.x - adjustedPoint.x) > 1){
                vel.x = -(adjustedPoint.x - enemPos.x);
            }
            if(fabsf(enemPos.y - adjustedPoint.y) > 1){
                vel.y = -(adjustedPoint.y - enemPos.y);
            }
            vel.x = clampf(vel.x, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            vel.y = clampf(vel.y, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            b2Body *b = enemySprite.getPhysicsBody;
            b->SetLinearVelocity(b2Vec2(vel.x,vel.y));
            
        }
    }

    #pragma mark- Swarm Stuff
    -(void)updateAllEnemySwarmSeekPosition:(CGPoint)p
    {
        //for a swarm effect enemy sprites must must keep a maximum/minimum distance from each other
        for(MinionSprite* enemySprite in self.enemiesArray){
            CGPoint adjustedPoint = ccp(p.x/PTM_RATIO, p.y/PTM_RATIO);
            b2Vec2 enemPos = enemySprite.getPhysicsBody->GetPosition();
            CGPoint vel = CGPointZero;
            if(fabsf(enemPos.x - adjustedPoint.x) > 1){
                vel.x = (adjustedPoint.x - enemPos.x);
            }
            if(fabsf(enemPos.y - adjustedPoint.y) > 1){
                vel.y = (adjustedPoint.y - enemPos.y);
            }
            vel.x = clampf(vel.x, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            vel.y = clampf(vel.y, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            b2Body *b = enemySprite.getPhysicsBody;
            b->SetLinearVelocity(b2Vec2(vel.x,vel.y));
            
            [enemySprite updateForSwarm:[self.enemiesArray mutableCopy]];
        }
    }

    -(void)updateAllEnemySwarmAvoidPosition:(CGPoint)p
    {
        //for a swarm effect enemy sprites must must keep a maximum/minimum distance from each other
        for(MinionSprite* enemySprite in self.enemiesArray){
            CGPoint adjustedPoint = ccp(p.x/PTM_RATIO, p.y/PTM_RATIO);
            b2Vec2 enemPos = enemySprite.getPhysicsBody->GetPosition();
            CGPoint vel = CGPointZero;
            if(fabsf(enemPos.x - adjustedPoint.x) > 1){
                vel.x = -(adjustedPoint.x - enemPos.x);
            }
            if(fabsf(enemPos.y - adjustedPoint.y) > 1){
                vel.y = -(adjustedPoint.y - enemPos.y);
            }
            vel.x = clampf(vel.x, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            vel.y = clampf(vel.y, -kEnemyMaxSpeed, kEnemyMaxSpeed);
            b2Body *b = enemySprite.getPhysicsBody;
            b->SetLinearVelocity(b2Vec2(vel.x,vel.y));
            
            [enemySprite updateForSwarm:[self.enemiesArray mutableCopy]];
        }
    }



    -(void)removePhysicsSprite:(PhysicsSprite *)spriteToRemove
    {
        CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
        if(spriteToRemove.getPhysicsBody){
            spriteToRemove.getPhysicsBody->SetActive(false);
            [SpriteManager shared].worldLayer.getWorld->DestroyBody(spriteToRemove.getPhysicsBody);
        }
        [parent removeChild:spriteToRemove cleanup:YES];
    }


#pragma mark Cleanups
    -(void)cleanSpentPowerups
    {
        NSMutableArray *toRemove = [NSMutableArray array]; 
        for (PowerUpSprite* pS in self.powerUpArray) {
            if (pS.spent) {
                [toRemove addObject:pS];
                [self removePhysicsSprite:pS];
            }
        }
        [self.powerUpArray removeObjectsInArray:toRemove];
    }

    -(void)cleanEnemyCorpses
    {
        NSMutableArray *toRemove = [NSMutableArray array]; 
        for (MinionSprite* mS in self.enemiesArray) {
            if (mS.dead) {
                [toRemove addObject:mS];
                [self removePhysicsSprite:mS];
            }
        }
        [self.enemiesArray removeObjectsInArray:toRemove];
    }

    -(void)cleanBullets
    {
        NSMutableArray *toRemove = [NSMutableArray array]; 
        for (BulletSprite* bS in self.bulletArray) {
            if (bS.shot) {
                [toRemove addObject:bS];
                [self removePhysicsSprite:bS];
            }
        }
        [self.bulletArray removeObjectsInArray:toRemove];
    }



@end

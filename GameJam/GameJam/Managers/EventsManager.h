//
//  EventsManager.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "PhysicsSprite.h"
#import "CharacterSprite.h"
#import "MinionSprite.h"
#import "PowerUpSprite.h"
#import "BulletSprite.h"



#pragma mark - SpriteContactListener
class SpriteContactListener : public b2ContactListener
{ 
    private :
    void BeginContact(b2Contact* contact);
//    void EndContact(b2Contact* contact);
//    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);    
//    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};

#pragma mark - EventsManager
@interface EventsManager : NSObject
    +(EventsManager*)shared;
    -(b2ContactListener *)makeSpriteListener;
    @property (assign, nonatomic) b2ContactListener* spriteContactListener;

    #pragma mark - collisions
    #pragma mark collision handling
    -(void)aCharacterSprite:(CharacterSprite*)charSprite hitEnemy:(MinionSprite*)enemySprite;
    -(void)aCharacterSprite:(CharacterSprite*)charSprite hitPowerup:(PowerUpSprite*)powerUpSprite;
    -(void)aBulletSprite:(BulletSprite*)bulletSprite hitEnemy:(MinionSprite*)enemySprite;

    #pragma mark collision checking 
    -(PhysicsSprite *)findCollideeInUserDataA:(id)userDataA orUserDataB:(id)userDataB;
    //Character and Enemy checking should handle every contact combination we'll need., add more when this becomes untrue
    -(bool)checkCharSpriteUserData:(id)userDataA contact:(id)userDataB;
    -(bool)checkEnemySpriteUserData:(id)userDataA contact:(id)userDataB;
    //-(bool)checkBulletSpriteUserData:(id)userDataA contact:(id)userDataB

    
@end

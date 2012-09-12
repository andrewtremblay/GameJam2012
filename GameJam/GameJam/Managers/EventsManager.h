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


/*
 What EventsManager should do:
 Handle collsion checking/handling and higher level behavior descsions
 What EventsManager should not do:
 Create sprites directly or directly control fine sprite behavior like movement, that's for SpriteManager
 */
#pragma mark - EventsManager
@interface EventsManager : NSObject
    +(EventsManager*)shared;
    -(b2ContactListener *)makeSpriteListener;
    @property (assign, nonatomic) b2ContactListener* spriteContactListener;
    #pragma mark - "AI" "behavior"
    //if this gets too complicated move it out to an AIManager
    #pragma mark AI reactions
    //right now just simple seek/avoid for the enemies, 
    //maybe some shooting/greed later too
    -(void)enemiesSeekToPoint:(CGPoint) destPoint;
    -(void)enemiesRunFromPoint:(CGPoint) destPoint;

    #pragma mark AI triggers
    //right now just watch the character
    //maybe have a call for item spawning or powerup grabbed later, too.
    -(void)aCharacterSprite:(CharacterSprite*)charSprite movedToPoint:(CGPoint)destPoint;

    #pragma mark - collisions
    #pragma mark collision handling
    -(void)aCharacterSprite:(CharacterSprite*)charSprite hitEnemy:(MinionSprite*)enemySprite;
    -(void)aCharacterSprite:(CharacterSprite*)charSprite hitPowerup:(PowerUpSprite*)powerUpSprite;
    -(void)aBulletSprite:(BulletSprite*)bulletSprite hitEnemy:(MinionSprite*)enemySprite;

    -(void)cleanUpCollisions;

    #pragma mark collision checking 
    -(PhysicsSprite *)findCollideeInUserDataA:(id)userDataA orUserDataB:(id)userDataB;
    //Character and Enemy checking should handle every contact combination we'll need., add more when this becomes untrue
    -(bool)checkCharSpriteUserData:(id)userDataA contact:(id)userDataB;
    -(bool)checkEnemySpriteUserData:(id)userDataA contact:(id)userDataB;
    //-(bool)checkBulletSpriteUserData:(id)userDataA contact:(id)userDataB
@end

//You could really put this anywhere, but I put it here. It jusrt Made Sense.
#pragma mark - SpriteContactListener
class SpriteContactListener : public b2ContactListener
{ 
    private :
    void BeginContact(b2Contact* contact);
    //don't need this, we just have immediate reactions 
    //    void EndContact(b2Contact* contact);
    //    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);    
    //    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};


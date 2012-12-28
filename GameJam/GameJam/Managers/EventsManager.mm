//
//  EventsManager.mm
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "EventsManager.h"
#import "SpriteManager.h"
#import "ControlManager.h"

static EventsManager* s_eventsManager;

@implementation EventsManager

@synthesize spriteContactListener = _spriteContactListener;

    +(EventsManager*)shared
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_eventsManager = [[EventsManager alloc] init];
        });
        return s_eventsManager;
    }

    -(b2ContactListener *)makeSpriteListener
    {
        self.spriteContactListener = new SpriteContactListener();
        return self.spriteContactListener;        
    }
    
    @synthesize mainGameState = _mainGameState;
    #pragma mark - BIG EVENTS
    -(void)GAME_BEGIN { //(re)initializaion
        self.mainGameState = gameRunning;
        self.enemyMode = aiSwarmSeekCharacter;
    }

    -(void)GAME_OVER {
        self.mainGameState = gameOverScreen;
    }

    -(void)GAME_PAUSE {
        self.mainGameState = gamePauseMenu;
    }

    -(void)GAME_RESUME { //any resuming logic
       self.mainGameState = gameRunning;
    }

    -(void)GAME_QUIT {
        self.mainGameState = gameMainMenu;
    }

    #pragma mark - timer/stepper logic
    @synthesize timeLastShot = _timeLastShot;
    -(void)checkIfTimeToShoot
    {
        double doubleTimeThisIsAPun = (double) kMinimumTimeToShoot;
        double secomndsSinceLastShot = self.timeLastShot.timeIntervalSinceNow / -1;
        
        if(secomndsSinceLastShot > doubleTimeThisIsAPun || self.timeLastShot == nil)
        {
            [self timeToShoot];
        }
    }

    -(void)timeToShoot{
        self.timeLastShot = [NSDate date];
        [ [[ControlManager shared]  charSprite ] shoot];
    }

    #pragma mark - "AI" "behavior"
    @synthesize enemyMode = _enemyMode;
    #pragma mark AI reactions
    -(void)enemiesSeekToPoint:(CGPoint) destPoint
    {
       // [[SpriteManager shared] setSwarmOff];
        [[SpriteManager shared] updateAllEnemySeekPosition:destPoint];
    }
    -(void)enemiesRunFromPoint:(CGPoint) destPoint
    {
       // [[SpriteManager shared] setSwarmOff];
        [[SpriteManager shared] updateAllEnemyAvoidPosition:destPoint];
    }
    -(void)enemiesSwarmToPoint:(CGPoint) destPoint
    {
       // [[SpriteManager shared] setSwarmOn];
        [[SpriteManager shared] updateAllEnemySwarmSeekPosition:destPoint];
    }
    -(void)enemiesSwarmFromPoint:(CGPoint) destPoint
    {
       // [[SpriteManager shared] setSwarmOn];
        [[SpriteManager shared] updateAllEnemySwarmAvoidPosition:destPoint];
    }


    #pragma mark AI triggers
    -(void)aCharacterSprite:(CharacterSprite*)charSprite movedToPoint:(CGPoint)destPoint
    {
        if(self.enemyMode == aiSeekCharacter){
            [self enemiesSeekToPoint:destPoint];
        }else if(self.enemyMode == aiAvoidCharacter){
            [self enemiesRunFromPoint:destPoint];
        }else if(self.enemyMode == aiSwarmSeekCharacter){
            [self enemiesSwarmToPoint:destPoint];
        }else if(self.enemyMode == aiSwarmAvoidCharacter){
            [self enemiesSwarmFromPoint:destPoint];
        }else {
            //should never be reached
            [[SpriteManager shared] stopAllEnemies];
        }
    }



#pragma mark - collisions
#pragma mark collision handling
-(void)aCharacterSprite:(CharacterSprite*)charSprite hitEnemy:(MinionSprite*)enemySprite
{
    //NSLog(@"CHAR HIT ENEMY / ENEMY HIT CHAR");
    //you have game logic now
    if(!enemySprite.dead){
        if(charSprite.vertCount > 3){
            int newVertCount = charSprite.vertCount - 1;
            [charSprite setVertCount:newVertCount];
            enemySprite.dead = YES;
        }else{
            //GAME OVER, 
            //or not, maybe invincibility is on?
            [[EventsManager shared] GAME_OVER];
        }
    }
}

-(void)aCharacterSprite:(CharacterSprite*)charSprite hitPowerup:(PowerUpSprite*)powerUpSprite
{
    //NSLog(@"CHAR HIT ITEM / ITEM HIT CHAR");
    if(!powerUpSprite.spent){
        powerUpSprite.spent = true;
        [charSprite setVertCount:4];
    }
}

-(void)aBulletSprite:(BulletSprite*)bulletSprite hitEnemy:(MinionSprite*)enemySprite
{
    //NSLog(@"ENEMY HIT BULLET / BULLET HIT ENEMY");
    if(!bulletSprite.shot){
        bulletSprite.shot = YES;
        if(!enemySprite.dead){
            enemySprite.dead = YES;
        }
    }
}

-(void)cleanUpCollisions
{ 
    //kill the dead, after all collisions are resolved
    [[SpriteManager shared] cleanSpentPowerups];
    [[SpriteManager shared] cleanEnemyCorpses];
    [[SpriteManager shared] cleanBullets];
    
}


#pragma mark collision checking 
-(PhysicsSprite *)findCollideeInUserDataA:(id)userDataA orUserDataB:(id)userDataB
{
    PhysicsSprite *toReturn = nil;
    if(userDataA != nil && [userDataA isKindOfClass:[PhysicsSprite class]]){
        toReturn = userDataA;
    }else if(userDataB != nil && [userDataB isKindOfClass:[PhysicsSprite class]]){
        toReturn = userDataB;
    }
    return toReturn;
}

//check for char sprite interaction with a valid agent
-(bool)checkCharSpriteUserData:(id)userDataA contact:(id)userDataB
{
    CharacterSprite *foundCharSprite =  nil; //faster (and messier) to do the nil/class check in each function 
    if([userDataA isKindOfClass:[CharacterSprite class]]){
        foundCharSprite = userDataA;
        userDataA = nil;
    }else if([userDataB isKindOfClass:[CharacterSprite class]]){
        foundCharSprite = userDataB;
        userDataB = nil;
    }
    if(foundCharSprite == nil){ 
        return false;    //a valid character was not found 
    }

    PhysicsSprite *collidee = [self findCollideeInUserDataA:userDataA orUserDataB:userDataB];
    if(collidee == nil){ 
        return false; //a valid collidee was not found 
    }
    
    [foundCharSprite collidedWith:collidee]; //collision with valid sprite
    return true; //a character and valid collidee was found
}

-(bool)checkEnemySpriteUserData:(id)userDataA contact:(id)userDataB
{
    MinionSprite *foundMinionSprite =  nil;
    if([userDataA isKindOfClass:[MinionSprite class]]){
        foundMinionSprite = userDataA;
        userDataA = nil;
    }else if([userDataB isKindOfClass:[MinionSprite class]]){
        foundMinionSprite = userDataB;
        userDataB = nil;
    }
    if(foundMinionSprite == nil){ 
        return false;    //a valid character was not found 
    }
    
    PhysicsSprite *collidee = [self findCollideeInUserDataA:userDataA orUserDataB:userDataB];
    if(collidee == nil){ 
        return false; //a valid collidee was not found 
    }
    
    [foundMinionSprite collidedWith:collidee]; //collision handling with valid collidee
    return true; //a character and valid collidee was found
}


@end

#pragma mark - SpriteContactListener
void SpriteContactListener::BeginContact(b2Contact* contact) {
        //check if a fixture was a character
        void* bodyAUserData = contact->GetFixtureA()->GetBody()->GetUserData();
        void* bodyBUserData = contact->GetFixtureB()->GetBody()->GetUserData();
        PhysicsSprite *tempSpriteA = nil;
        PhysicsSprite *tempSpriteB = nil;
        if(bodyAUserData){
            tempSpriteA = static_cast<PhysicsSprite*>( bodyAUserData );
        }
        if(bodyBUserData){
            tempSpriteB = static_cast<PhysicsSprite*>( bodyBUserData );
        }
    if([[EventsManager shared] checkCharSpriteUserData:tempSpriteA contact:tempSpriteB])
        return;
    if([[EventsManager shared] checkEnemySpriteUserData:tempSpriteA contact:tempSpriteB])
        return; //Maybe more here.
}

//don't need this, we just have immediate reactions 
//SpriteContactListener::EndContact(b2Contact* contact) {
//    void* bodyAUserData = contact->GetFixtureA()->GetBody()->GetUserData();
//    void* bodyBUserData = contact->GetFixtureB()->GetBody()->GetUserData();
//    [[EventsManager shared] endContactUserData:bodyAUserData];
//    [[EventsManager shared] endContactUserData:bodyBUserData];
//}



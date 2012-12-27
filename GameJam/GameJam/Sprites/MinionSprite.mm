//
//  MinionSprite.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "MinionSprite.h"
#import "EventsManager.h"

#define kMinionMAXHEIGHT  30.0f
#define kMinionMAXWIDTH   30.0f

//distance from center point the enemy should swarm,
//minimum should probably be greater than the dimensions, as a rule
#define kMinionMAX_SWARMDIST 60.0f
#define kMinionMIN_SWARMDIST 40.0f


@implementation MinionSprite
@synthesize dead = _dead;
@synthesize vert = _vert;
@synthesize vertCount = _vertCount;
- (void)createBullets {
    for (int i=0; i<self.vertCount ; i++) {
        CGPoint p = CGPointMake(self.vert[i].x, self.vert[i].y);
        [[SpriteManager shared] makeBulletAtPosition:p];
    }
}

- (void)updatePhysicsBoxWithPoint:(CGPoint)p numberOfVertex:(int)count {
    
    
    b2BodyDef bodyDefPoly;
    bodyDefPoly.type = b2_dynamicBody;
    bodyDefPoly.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    b2Body *polyBody = [SpriteManager shared].worldLayer.getWorld->CreateBody(&bodyDefPoly);
    
    b2PolygonShape polygon;
    float w = kMinionMAXWIDTH;
    switch (count) {
        case 3: {
            b2Vec2 vertices[3];
            vertices[0].Set(w/2     /PTM_RATIO,    0.0f /PTM_RATIO);
            vertices[1].Set(w       /PTM_RATIO,    w    /PTM_RATIO);
            vertices[2].Set(0.0f    /PTM_RATIO,    w    /PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
        case 4: {
            b2Vec2 vertices[4];
            vertices[0].Set(0.0f    /PTM_RATIO,     0.0f /PTM_RATIO);
            vertices[1].Set(w       /PTM_RATIO,     0.0f /PTM_RATIO);
            vertices[2].Set(w       /PTM_RATIO,     w   /PTM_RATIO);
            vertices[3].Set(0.0f    /PTM_RATIO,     w   /PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
        case 5: {
            b2Vec2 vertices[4];
            vertices[0].Set((w/2) / PTM_RATIO , 0.0f / PTM_RATIO);
            vertices[1].Set(w / PTM_RATIO,(w/3)/PTM_RATIO);
            vertices[2].Set((w*(3/4))/PTM_RATIO,w/PTM_RATIO);
            vertices[3].Set(w*(1/4)/PTM_RATIO,w/PTM_RATIO);
            vertices[3].Set(0.0f/PTM_RATIO,(w/3)/PTM_RATIO);
            polygon.Set(vertices, count);
            self.vertCount = count;
            self.vert = vertices;
        }break;
    }
    
    
    b2FixtureDef fixtureDefPoly;
    fixtureDefPoly.shape = &polygon;
    fixtureDefPoly.density = 1.0f;
    fixtureDefPoly.friction = 0.3f;
    fixtureDefPoly.filter.categoryBits = kEnemyCategoryBit; 
    fixtureDefPoly.filter.maskBits = kEnemyCollideMask; 
    polyBody->CreateFixture(&fixtureDefPoly);
    polyBody->SetUserData(self);

	[self setPhysicsBody:polyBody];
}


-(void)collidedWith:(PhysicsSprite*)collidee
{
    if([collidee isKindOfClass:[BulletSprite class]]){
        [[EventsManager shared] aBulletSprite:(BulletSprite *)collidee hitEnemy:self];
        //events manager will tell the sprite manager (or those involved) what to do
    }else if([collidee isKindOfClass:[MinionSprite class]]){
        //put some swarm behavior here if necessarry, possibly optimize on a recent colission
    }else {
        //default no action
    }
}

-(void) updateForSwarm:(NSMutableArray*)enemiesArray
{
    //NOTE: this is TRUE SWARM BEHAVIOR, every enemy could be checking the position of every other enemy. It's O(N^2) so this could get slow.
    //first and foremost, remove self from the running.
    [enemiesArray removeObject:self];
    //we already have our velocity set towards the character, so we shouldn't change our direction too much
    b2Vec2 initialVel = self.getPhysicsBody->GetLinearVelocity();
    b2Vec2 deltaVel = b2Vec2(0,0);
    b2Vec2 myPos = self.getPhysicsBody->GetPosition();
    for (MinionSprite* enemySprite in enemiesArray) {
        b2Vec2 enemPos = enemySprite.getPhysicsBody->GetPosition();
        if(enemPos.y < myPos.y + kMinionMIN_SWARMDIST){
        
        }else if (enemPos.y > myPos.y + kMinionMAX_SWARMDIST)
        {
        
        }
        
        if(enemPos.x < myPos.x + kMinionMIN_SWARMDIST){
            
        }else if (enemPos.x > myPos.x + kMinionMAX_SWARMDIST)
        {
            
        }
    }
    b2Vec2 finalVel = (initialVel + deltaVel);
}



@end

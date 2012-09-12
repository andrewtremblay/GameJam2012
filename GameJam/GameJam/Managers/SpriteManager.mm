//
//  SpriteManager.m
//  jamTestGo
//
//  Created by Andrew Tremblay on 9/11/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//
#import "PhysicsSprite.h"
#import "SpriteManager.h"


static SpriteManager* s_spriteManager;

@implementation SpriteManager
    @synthesize spriteTexture = _spriteTexture;
    @synthesize worldLayer = _worldLayer;

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
    CGSize s = [CCDirector sharedDirector].winSize;
    //Set up spritesheet and CCSpriteBatchNode
    // Use batch node. Faster
    CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blackTexture.png" capacity:100];
    self.spriteTexture = [parent texture];
    [self.worldLayer addChild:parent z:0 tag:kTagParentNode];

//    [self addNewSpriteAtPosition:ccp(s.width/2, s.height/2)]; //delete this, but good for debugging

}

- (CharacterSprite *)addCharacterAtPosition:(CGPoint)p
{
    CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
    CharacterSprite* cSprite = [[CharacterSprite alloc] initWithTexture:self.spriteTexture];
    [parent addChild:cSprite];
    cSprite.position = ccp(p.x,p.y);
    [cSprite updatePhysicsBoxWithPoint:p numberOfVertex:4];
    return cSprite;
}
- (BulletSprite *)makeBulletAtPosition:(CGPoint)p
{
    CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
    BulletSprite* sprite = [[BulletSprite alloc] initWithTexture:self.spriteTexture];
    [parent addChild:sprite];
    sprite.position = ccp(p.x,p.y);
    
    [sprite updatePhysicsBoxWithPoint:p];
    return sprite;
}

- (PowerUpSprite *)makePowerUpAtPosition:(CGPoint)p
{
    CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
    PowerUpSprite* sprite = [[PowerUpSprite alloc] initWithTexture:self.spriteTexture];
    [parent addChild:sprite];
    sprite.position = ccp(p.x,p.y);
    
    [sprite updatePhysicsBoxWithPoint:p];
    return sprite;
}

- (MinionSprite *)addMinionAtPosition:(CGPoint)p
{
    CCNode *parent = [self.worldLayer getChildByTag:kTagParentNode];
    MinionSprite* sprite = [[MinionSprite alloc] initWithTexture:self.spriteTexture];
    [parent addChild:sprite];
    sprite.position = ccp(p.x,p.y);
    
    [sprite updatePhysicsBoxWithPoint:p numberOfVertex:3];
    return sprite;
}


-(void) createDynamicPoly {
    
}

-(void) addNewSpriteAtPosition:(CGPoint)p
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
	body->CreateFixture(&fixtureDef);
	
	[sprite setPhysicsBody:body];
    
}

@end

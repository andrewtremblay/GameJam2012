//
//  GameLayer+inits.m
//  GameJam
//
//  Created by Andrew Tremblay on 9/12/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "GameLayer+inits.h"
#import "PhysicsSprite.h"
#import "SpriteManager.h"
#import "ControlManager.h"
#import "EventsManager.h"

@implementation GameLayer (inits)
-(void) initPhysics
{
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);// -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
    [self initGroundBody];
    
}

-(void) initPlayer
{
    //init char sprite and attach it to it's keepers
    CGSize s = [CCDirector sharedDirector].winSize;
    CharacterSprite *charSprite = [[SpriteManager shared] makeCharacterAtPosition:ccp(s.width/2, s.height/2)];
    [[ControlManager shared] setCharSprite:charSprite];        
}

-(void) initGroundBody
{
    CGSize s = [[CCDirector sharedDirector] winSize];
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	b2Fixture* bottom = groundBody->CreateFixture(&groundBox,0);
    b2Filter fB = bottom->GetFilterData();
    fB.categoryBits = kBackgroundCategoryBit;
    bottom->SetFilterData(fB);
    //    [[bottom filter] setCategoryBits:kBackgroundCategoryBit];
    
    // top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	b2Fixture* top = groundBody->CreateFixture(&groundBox,0);
    b2Filter fT = top->GetFilterData();
    fT.categoryBits = kBackgroundCategoryBit;
    top->SetFilterData(fT);
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	b2Fixture* left = groundBody->CreateFixture(&groundBox,0);
    b2Filter fL = left->GetFilterData();
    fL.categoryBits = kBackgroundCategoryBit;
    left->SetFilterData(fL);
    
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	b2Fixture* right = groundBody->CreateFixture(&groundBox,0);
    b2Filter fR = right->GetFilterData();
    fR.categoryBits = kBackgroundCategoryBit;
    right->SetFilterData(fR);
}



@end

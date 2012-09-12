//
//  GameLayer.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "SpriteManager.h"
#import "ControlManager.h"



#pragma mark - HelloWorldLayer

@interface GameLayer()
-(void) initPhysics;
-(void) initGroundBody;
-(void) initPlayer;
@end

@implementation GameLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		// init physics
		[self initPhysics];
		
		// create reset button
        [[SpriteManager shared] setWorldLayer:self]; 
        
        [self initPlayer];
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

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
    CGSize s = [CCDirector sharedDirector].winSize;
    [[SpriteManager shared] addNewSpriteAtPosition:ccp( s.width - s.width/3,  s.height - s.height/3)];
    
    CharacterSprite *charSprite = [[SpriteManager shared] addCharacterAtPosition:ccp(s.width/2, s.height/2)];
    [[ControlManager shared] setCharSprite:charSprite];        
}


-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
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
	groundBody->CreateFixture(&groundBox,0);
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

//Getters
-(b2World*)getWorld
{
    return world;
}


//control callbacks (easier for ControlManager)
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ControlManager shared] touchesBegan:touches withEvent:event];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ControlManager shared] touchesMoved:touches withEvent:event];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ControlManager shared] touchesEnded:touches withEvent:event];
//debug, keep for now
	//Add a new body/atlas sprite at the touched location
//	for( UITouch *touch in touches ) {
//		CGPoint location = [touch locationInView: [touch view]];
//		
//		location = [[CCDirector sharedDirector] convertToGL: location];
//		
//		[[SpriteManager shared] addNewSpriteAtPosition: location];
//	}
}



@end

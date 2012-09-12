//
//  GameLayer.m
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "GameLayer.h"
#import "GameLayer+inits.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "SpriteManager.h"
#import "ControlManager.h"
#import "EventsManager.h"



#pragma mark - HelloWorldLayer

@interface GameLayer()
-(void)initSmorgasboard;//debug, doesn't belong with the rest of the inits  

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
        //pass the important stuff to the singletons
        //we need the world layer to make sprites good
        [[SpriteManager shared] setWorldLayer:self]; 
        
        b2ContactListener *collisions = [[EventsManager shared] makeSpriteListener]; //reference also stored in singleton
        world->SetContactListener(collisions);
        
        [self initPlayer];
        [self initSmorgasboard];

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
    
    //update charsprite position(move/abstract this somewhere else, probably)
    CharacterSprite *cS = [[ControlManager shared] charSprite];
    [[EventsManager shared] aCharacterSprite:cS movedToPoint:cS.positionPixels];
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



//DEBUG STUFF
-(void)initSmorgasboard
{
    CGSize s = [CCDirector sharedDirector].winSize;
    [[SpriteManager shared] makePowerUpAtPosition:ccp( s.width - s.width/3,  s.height - s.height/3)];
    
    [[SpriteManager shared] makeMinionAtPosition:ccp( s.width - 45,  s.height/3)];
    [[SpriteManager shared] makeMinionAtPosition:ccp( s.width - 45,  s.height/3 + 45)];
    [[SpriteManager shared] makeMinionAtPosition:ccp( s.width - 45,  s.height/3 + 90)];
    [[SpriteManager shared] makeMinionAtPosition:ccp( s.width - 45,  s.height/3 + 135)];
    ;
    
    
    [[SpriteManager shared] makeBulletAtPosition:ccp( s.width - s.width/3,  s.height/3)];
}




@end

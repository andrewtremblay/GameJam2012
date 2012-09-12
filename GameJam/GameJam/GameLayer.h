//
//  GameLayer.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//
#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


enum {
	kTagParentNode = 1,
};



@interface GameLayer : CCLayer
{
	b2World* world;// strong ref
	GLESDebugDraw *m_debugDraw;// strong ref
}

// returns a CCScene that contains the GameLayer as the only child
+(CCScene *) scene;

#pragma mark Getters
-(b2World*)getWorld;


@end

//
//  PhysicsSprite.mm
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "PhysicsSprite.h"
#import <GLKit/GLKit.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
// Needed PTM_RATIO
#import "GameLayer.h"

#pragma mark - PhysicsSprite
@implementation PhysicsSprite
-(b2Body *) getPhysicsBody
{
	return body_;
}

-(void) setPhysicsBody:(b2Body *)body
{
	body_ = body;
}

// this method will only get called if the sprite is batched.
// return YES if the physics values (angles, position ) changed
// If you return NO, then nodeToParentTransform won't be called.
-(BOOL) dirty
{
	return YES;
}

// returns the transform matrix according the Chipmunk Body values
-(CGAffineTransform) nodeToParentTransform
{	
	b2Vec2 pos  = body_->GetPosition();
	
	float x = pos.x * PTM_RATIO;
	float y = pos.y * PTM_RATIO;
	
	if ( ignoreAnchorPointForPosition_ ) {
		x += anchorPointInPoints_.x;
		y += anchorPointInPoints_.y;
	}
	
	// Make matrix
	float radians = body_->GetAngle();
	float c = cosf(radians);
	float s = sinf(radians);
	
	if( ! CGPointEqualToPoint(anchorPointInPoints_, CGPointZero) ){
		x += c*-anchorPointInPoints_.x + -s*-anchorPointInPoints_.y;
		y += s*-anchorPointInPoints_.x + c*-anchorPointInPoints_.y;
	}
	
	// Rot, Translate Matrix
	transform_ = CGAffineTransformMake( c,  s,
									   -s,	c,
									   x,	y );	
	
	return transform_;
}


-(void) dealloc
{
	// 
	[super dealloc];
}

- (void)draw {
    glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
    CGSize s = CGSizeMake(150, 200);
    CGPoint vertices[8]={
        ccp(50,50),ccp(s.width,0),
        ccp(s.width,s.height),ccp(0,s.height),
    };
    ccFillPoly(vertices, 8, YES);

}

void ccFillPoly( CGPoint *poli, int points, BOOL closePolygon )
{
    // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
    // Needed states: GL_VERTEX_ARRAY,
    // Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(2, GL_FLOAT, 0, poli);
    if( closePolygon )
        //	 glDrawArrays(GL_LINE_LOOP, 0, points);
        glDrawArrays(GL_TRIANGLE_FAN, 0, points);
    else
        glDrawArrays(GL_LINE_STRIP, 0, points);
    
    // restore default state
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
}

@end

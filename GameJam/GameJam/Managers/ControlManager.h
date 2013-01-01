//
//  ControlManager.h
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import <Foundation/Foundation.h>
#import "CharacterSprite.h"

enum {
    kPointMove,
    kTiltMove,
    kSwipeMove
};// controlMoveSetting;

enum {
    kPointShoot,
    kTiltShoot    
};// controlShootSetting;

@interface ControlManager : NSObject
+(ControlManager*)shared; //singleton

//device check variables
-(bool)isIphone;
-(bool)isIpad;
-(bool)isIpadRetina;
-(bool)isIpadMini;

//the character
@property (nonatomic, strong) CharacterSprite* charSprite;

//control settings
@property (nonatomic, assign) int moveSetting; //controlMoveSetting
@property (nonatomic, assign) int shootSetting; //controlShootSetting

//control agnostic behavior
-(void)moveCharToPoint:(CGPoint)p;
-(void)lookAtPoint:(CGPoint)p;
-(void)shootAtPoint:(CGPoint)p;

//p is already relative to the ship
-(void)moveInDirection:(CGPoint)p;
-(void)lookInDirection:(CGPoint)p;
-(void)shootInDirection:(CGPoint)p;


-(void)setCharVelocityRelativeToPress:(CGPoint)pointOfPress;


//interaction handlers
- (void)pressFoundAtPoint:(CGPoint)p;
- (void)swipeFoundInDirection:(CGPoint)p; //TODO, VECTOR PROBABLY



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

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
    kTiltMove    
};// controlMoveSetting;

enum {
    kPointShoot,
    kTiltShoot    
};// controlShootSetting;

@interface ControlManager : NSObject
+(ControlManager*)shared; //singleton



//the character
@property (nonatomic, strong) CharacterSprite* charSprite;

//control settings
@property (nonatomic, assign) int moveSetting; //controlMoveSetting
@property (nonatomic, assign) int shootSetting; //controlShootSetting

//control agnostic behavior
-(void)moveCharToPoint:(CGPoint)p;
-(void)shootAtPoint:(CGPoint)p;

-(void)moveInDirection:(CGPoint)p;//TODO, VECTOR PROBABLY
-(void)shootInDirection:(CGPoint)p;//TODO, VECTOR PROBABLY


-(void)setCharVelocityRelativeToPress:(CGPoint)pointOfPress;


//interaction handlers
- (void)pressFoundAtPoint:(CGPoint)p;
- (void)swipeFoundInDirection:(CGPoint)p; //TODO, VECTOR PROBABLY



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

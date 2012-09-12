//
//  ControlManager.mm
//  GameJam
//
//  Created by Alex Rouse on 9/11/12.
//
//

#import "ControlManager.h"

#define kCharSpeedActionTag 0
#define kCharMaxSpeed 5.0f

@interface ControlManager ()
    @property (nonatomic, assign) CGPoint startPoint;
    @property (nonatomic, assign) CGPoint endPoint;
@end

static ControlManager* s_controlManager;
@implementation ControlManager
@synthesize charSprite = _charSprite;
@synthesize moveSetting = _moveSetting; //controlMoveSetting
@synthesize shootSetting = _shootSetting; //controlShootSetting


@synthesize startPoint = _startPoint;
@synthesize endPoint = _endPoint;


+(ControlManager*)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_controlManager = [[ControlManager alloc] init];
    });
    
    return s_controlManager;
}


//control agnostic behavior

-(void)moveCharToPoint:(CGPoint)p
{
    CGPoint adjustedPoint = p;// [[CCDirector sharedDirector] convertToGL:p];
    self.charSprite.getPhysicsBody->SetTransform(b2Vec2(adjustedPoint.x/PTM_RATIO, adjustedPoint.y/PTM_RATIO),
                                                 self.charSprite.getPhysicsBody->GetAngle() );
//    [self.charSprite setPosition:p];
}

-(void)shootAtPoint:(CGPoint)p
{

}

-(void)moveInDirection:(CGPoint)p
{

}

-(void)shootInDirection:(CGPoint)p
{
    
    
    
}


//UITouch *touch = [touches anyObject];
//CGPoint point = [touch locationInView: [touch view]];
//point = [[CCDirector sharedDirector] convertToGL: point];
//
///* Reposition the grabbed fruit */
//grabbedFruit.body->SetTransform(b2Vec2(point.x/PTM_RATIO, point.y/
//                                       PTM_RATIO), grabbedFruit.body->GetAngle());
//
//b2Vec2 moveDistance = b2Vec2( (point.x/PTM_RATIO - grabbedFruit.
//                               sprite.position.x/PTM_RATIO), (point.y/PTM_RATIO - grabbedFruit.
//                                                              sprite.position.y/PTM_RATIO) );
//lastFruitVelocity = b2Vec2(moveDistance.x*20, moveDistance.y*20);



-(void)setCharVelocity:(CGPoint)p
{
    
    [self.charSprite stopActionByTag:kCharSpeedActionTag]; //interrupt the action
    
    float vx = p.x;
    float vy = p.y;
    CCSpeed *action;
    
    b2Body *b = self.charSprite.getPhysicsBody;
    // set ball velocity by the incoming point
    b->SetLinearVelocity(b2Vec2(vx,vy));//+b->GetLinearVelocity());
    float vel;
    vel = b->GetLinearVelocity().Normalize();
    
////    CCAction *move 
////    action = [CCMoveBy actionWithDuration:1.f position:ccp(10,0)];
////    action =[CCSpeed actionWithAction:move rate:0.5f];
//
//    
//    [action setTag:kCharSpeedActionTag];
//    [action setSpeed:vel];
//        [self.charSprite runAction:action]; //action will run next timestep
}

-(void)setCharDirection:(CGPoint)p //CGPointZero will try to use velocity of char for direction
{
    if(CGPointEqualToPoint(p, CGPointZero)){
        // rotation by velocity, (should be immediate)
        b2Vec2 vec = self.charSprite.getPhysicsBody->GetLinearVelocity();
        [self.charSprite setRotation:(-1*CC_RADIANS_TO_DEGREES(ccpToAngle(CGPointMake(vec.x, vec.y))))];
    }else {
        // rotation by point, (should be immediate)
        [self.charSprite setRotation:(-1*CC_RADIANS_TO_DEGREES(ccpToAngle(p)))];
    }
}

//interaction handlers


//tilt handling


//touch/swipe handling
- (void)pressFoundAtPoint:(CGPoint)p
{
    CGPoint vel = CGPointZero;
    
    [self moveCharToPoint:p];
//    float grabbedDistance = distanceBetweenPoints(point,ccp(grabbedFruit.body->GetPosition().x*PTM_RATIO, grabbedFruit.body->GetPosition().y*PTM_RATIO));
//    for(int i=0; i < GetPosition().x*PTM_RATIO, fruit.body->GetPosition().y*PTM_RATIO),point);
//    if(thisDistance < grabbedDistance){
//        grabbedFruit = fruit;
//        grabbedDistance = thisDistance;
//    }
//    CGPoint charPos  = [self.charSprite convertToWorldSpace: self.charSprite.position];
//    b2Body *b = self.charSprite.getPhysicsBody;
//    b2Vec2 bodyPos = b->GetPosition();
//    charPos = CGPointMake(bodyPos.x, bodyPos.y);
////    if(charPos.x < p.x){
////        vel.x = kCharMaxSpeed;
//////        vel.x = (charPos.x - p.x);
////    }else{
////        vel.x = -kCharMaxSpeed;
//////        vel.x = (p.x - charPos.x);
////    }
//    
//    if(charPos.y > p.y){
//        vel.y = kCharMaxSpeed;
////        vel.y = (charPos.y - p.y);
//    }else {
//        vel.y = -kCharMaxSpeed;
////        vel.y = (p.y - charPos.y);
//    }
//    vel.x = clampf(vel.x, -kCharMaxSpeed, kCharMaxSpeed);
//    vel.y = clampf(vel.y, -kCharMaxSpeed, kCharMaxSpeed);
    
//    [self setCharVelocity:vel];
//    [self setCharDirection:CGPointZero]; 

}

- (void)swipeFoundInDirection:(CGPoint)p
{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _startPoint = location;
        _endPoint = location;
    }
    
    [self pressFoundAtPoint:_startPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }

    if (ccpLengthSQ(ccpSub(_startPoint, _endPoint)) > 25)
    {        
        [self pressFoundAtPoint:_endPoint];

        //have a minimum/maximum drag distance, for performance
        _startPoint = _endPoint;
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }

//    [self pressFoundAtPoint:_endPoint];

}


@end

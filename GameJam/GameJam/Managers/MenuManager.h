//
//  MenuManager.h
//  GameJam
//
//  Created by AndrewTremblay on 1/1/13.
//
//

#import "GameLayer.h"

#define MENU_BAR_HEIGHT 55

@interface MenuManager: NSObject
    +(MenuManager*)shared;
    -(void)makeMenuInGameLayer:(GameLayer*)gameLayer;
    -(void)doNothing;
    -(void)onClick:(id)whatevs;
@end
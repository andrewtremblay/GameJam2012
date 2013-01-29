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
    @property (nonatomic, assign) CCMenu *gameMenu;

    @property (nonatomic, assign) CCMenu *gameOverMenu;



    -(void)makeMenuInGameLayer:(GameLayer*)gameLayer;

    -(void)showGameOverMenu;
    -(void)hideGameOverMenu;

    -(void)showInGameMenu;
    -(void)hideInGameMenu;

    -(void)doNothing;
@end
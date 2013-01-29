//
//  MenuManager.mm
//  GameJam
//
//  Created by AndrewTremblay on 1/1/13.
//
// Controls all menu layout and behavior,
//  both opening menu and during gameplay (HUD)


#import "MenuManager.h"
#import "EventsManager.h"



static MenuManager* s_menuManager;

@implementation MenuManager
    +(MenuManager*)shared {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_menuManager = [[MenuManager alloc] init];
        });
        return s_menuManager;
    }
@synthesize gameMenu = _gameMenu;
@synthesize gameOverMenu = _gameOverMenu;


-(void)makeMenuInGameLayer:(GameLayer*)gameLayer
{
    //menu items shouldn't be affected by gravity, so we shouldn't make them b2Bodys
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCSprite *menuBg = [CCSprite spriteWithFile:@"whiteTexture.png"
                rect:CGRectMake(
                    s.width/2,      MENU_BAR_HEIGHT,
                    s.width,        MENU_BAR_HEIGHT)];
    menuBg.position = CGPointMake(s.width/2,
                                  s.height - menuBg.contentSize.height/2);
    //In-Game Menu Nodes
    CCMenuItem *pauseButton = [CCMenuItemImage itemWithNormalImage:@"gear.png" selectedImage:@"gear.png" target:self selector:@selector(gearPressed)];
    CCMenuItem *deadButton = [CCMenuItemImage itemWithNormalImage:@"skull.png" selectedImage:@"skull.png" target:self selector:@selector(skullPressed)];
    _gameMenu = [CCMenu menuWithItems:pauseButton, deadButton, nil];
    _gameMenu.position = menuBg.position;
    [_gameMenu alignItemsHorizontallyWithPadding:5];

    //Game Over Menu
    
    [gameLayer addChild:menuBg z:100];
    [gameLayer addChild:_gameMenu z:101];
}


-(void)showGameOverMenu
{
    _gameMenu.opacity = 1.0;
}
-(void)hideGameOverMenu
{
    _gameMenu.opacity = 0.5;
}

-(void)showInGameMenu
{
    
}
-(void)hideInGameMenu
{
    
}




-(void)gearPressed
{
    NSLog(@"gearPressed");
    if([[EventsManager shared] mainGameState] == gamePauseMenu)
    {
        [[EventsManager shared] GAME_RESUME];
    }
    if([[EventsManager shared] mainGameState] == gameRunning)
    {
        [[EventsManager shared] GAME_PAUSE];
    }
}

-(void)skullPressed
{
    NSLog(@"skullPressed");
    [[EventsManager shared] GAME_OVER];
}



-(void)doNothing
{
    NSLog(@"doNothing");
}






@end
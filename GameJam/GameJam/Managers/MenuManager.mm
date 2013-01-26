//
//  MenuManager.mm
//  GameJam
//
//  Created by AndrewTremblay on 1/1/13.
//
// Controls all menu layout and behavior,
//  both opening menu and during gameplay (HUD)


#import "MenuManager.h"



static MenuManager* s_menuManager;

@implementation MenuManager
    +(MenuManager*)shared {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_menuManager = [[MenuManager alloc] init];
        });
        return s_menuManager;
    }


-(void)makeMenuInGameLayer:(GameLayer*)gameLayer
{
    //menu items shouldn't be affected by gravity, so we shouldn't make them b2Bodys
    CGSize s = [[CCDirector sharedDirector] winSize];
    CCSprite *menuBg = [CCSprite spriteWithFile:@"whiteTexture.png" rect:CGRectMake( s.width/2,      MENU_BAR_HEIGHT,
                    s.width,        MENU_BAR_HEIGHT)];
    menuBg.position = CGPointMake(s.width/2,
                                  s.height - menuBg.contentSize.height/2);
    [gameLayer addChild:menuBg z:100];
}


-(void)doNothing
{

}


-(void)onClick:(id)whatevs
{

}




@end
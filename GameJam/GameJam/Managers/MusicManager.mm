//
//  MusicManager.mm
//  GameJam
//
//  Created by AndrewTremblay on 5/21/13.
//
//

#include "MusicManager.h"

static MusicManager* s_menuManager;

@implementation MusicManager
    +(MusicManager*)shared {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_menuManager = [[MusicManager alloc] init];
        });
        return s_menuManager;
    }

@end
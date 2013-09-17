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

            s_menuManager.mainSynth = WickedSynth::WickedSynth();
        });
        return s_menuManager;
    }

    -(void)playNoise
    {

    }

@end
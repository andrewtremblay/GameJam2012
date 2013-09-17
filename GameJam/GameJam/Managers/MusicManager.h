//
//  MusicManager.h
//  GameJam
//
//  Created by AndrewTremblay on 5/21/13.
//
//

#include "Tonic.h"

@interface MusicManager: NSObject
    +(MusicManager*)shared;

    -(void)playNoise;

    @property WickedSynth::WickedSynth *mainSynth;

@end


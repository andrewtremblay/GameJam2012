//
//  Constants.h
//  GameJam
//
//  Created by Andrew Tremblay on 9/11/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#ifndef GameJam_Constants_h
#define GameJam_Constants_h
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32


//Collision flags for collision filtering
#define kMainCharCategoryBit   0x0001
#define kBulletCategoryBit     0x0002
#define kEnemyCategoryBit      0x0004
#define kPowerupCategoryBit    0x0008
#define kBackgroundCategoryBit 0x0016
//MAYBE outer background collision bit for recycling bullets/etc

//the collision filters. edit these to determine how sprites react to different types
#define kMainCharCollideMask kPowerupCategoryBit | kEnemyCategoryBit | kBackgroundCategoryBit
#define kBulletCollideMask   kEnemyCategoryBit
#define kEnemyCollideMask    kMainCharCategoryBit | kBulletCategoryBit
#define kPowerupCollideMask  kMainCharCategoryBit


#endif

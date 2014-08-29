//
//  AppDelegate.h
//  TTT
//
//  Created by VA Gautham  on 8/27/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GameType_SinglePlayer     = 0,
    GameType_MultiPlayer      = 1,
    GameType_Unknown,
} GameType;

typedef enum {
    Slot_Empty = -1,
    Slot_O = 0,
    Slot_X = 1
} Slot;

typedef enum {
    Player_1_Turn = 0,
    Player_2_Turn,
} PlayerTurn;

typedef enum {
    HardMode_Off = 0,
    HardMode_On,
} HardMode;

#define BOARD_0x0   @"0x0"
#define BOARD_0x1   @"0x1"
#define BOARD_0x2   @"0x2"

#define BOARD_1x0   @"1x0"
#define BOARD_1x1   @"1x1"
#define BOARD_1x2   @"1x2"

#define BOARD_2x0   @"2x0"
#define BOARD_2x1   @"2x1"
#define BOARD_2x2   @"2x2"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) GameType mGameType;
@property (nonatomic) HardMode mHardMode;
@end

//
//  GameBoardViewController.h
//  TTT
//
//  Created by VA Gautham  on 8/28/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GameBoardViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIView *gameBoardView;
    
    IBOutlet UIImageView *img_Player;
    IBOutlet UILabel *lbl_Player;
    IBOutlet UIImageView *img_Peg;

    IBOutlet UIImageView *img_Slot0x0;
    IBOutlet UIImageView *img_Slot0x1;
    IBOutlet UIImageView *img_Slot0x2;

    IBOutlet UIImageView *img_Slot1x0;
    IBOutlet UIImageView *img_Slot1x1;
    IBOutlet UIImageView *img_Slot1x2;

    IBOutlet UIImageView *img_Slot2x0;
    IBOutlet UIImageView *img_Slot2x1;
    IBOutlet UIImageView *img_Slot2x2;

    NSMutableDictionary *gameBoardStatus;
    PlayerTurn playerTurn;
   
    NSMutableArray *imageArray;
    NSMutableArray *boardArray;

    UIAlertView *gameResultAlert;
    
    IBOutlet UILabel *lbl_Player1;
    IBOutlet UILabel *lbl_Player2;
    IBOutlet UILabel *lbl_score;
    IBOutlet UILabel *lbl_Totalmatches;
    
    NSUInteger totalMatches;
    NSUInteger Player1Wins;
    NSUInteger Player2Wins;
}

@property(nonatomic) UIView *gameBoardView;

@property(nonatomic) UIImageView *img_Player;
@property(nonatomic) UILabel *lbl_Player;
@property(nonatomic) UIImageView *img_Peg;

@property(nonatomic) UIImageView *img_Slot0x0;
@property(nonatomic) UIImageView *img_Slot0x1;
@property(nonatomic) UIImageView *img_Slot0x2;

@property(nonatomic) UIImageView *img_Slot1x0;
@property(nonatomic) UIImageView *img_Slot1x1;
@property(nonatomic) UIImageView *img_Slot1x2;

@property(nonatomic) UIImageView *img_Slot2x0;
@property(nonatomic) UIImageView *img_Slot2x1;
@property(nonatomic) UIImageView *img_Slot2x2;

@property(nonatomic) NSMutableDictionary *gameBoardStatus;
@property(nonatomic) PlayerTurn playerTurn;

@property(nonatomic) NSMutableArray *imageArray;
@property(nonatomic) NSMutableArray *boardArray;

@property(nonatomic) UILabel *lbl_Player1;
@property(nonatomic) UILabel *lbl_Player2;
@property(nonatomic) UILabel *lbl_score;
@property(nonatomic) UILabel *lbl_Totalmatches;

@property(nonatomic) NSUInteger totalMatches;
@property(nonatomic) NSUInteger Player1Wins;
@property(nonatomic) NSUInteger Player2Wins;

-(void)resetGameBoard;

-(IBAction)onReset:(id)sender;
-(IBAction)onQuit:(id)sender;

@end

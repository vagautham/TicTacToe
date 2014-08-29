//
//  PlayerOptionViewController.h
//  TTT
//
//  Created by VA Gautham  on 8/27/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerOptionViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *img_Player1;
    IBOutlet UIImageView *img_Player2;
    
    IBOutlet UITextField *txt_Player1;
    IBOutlet UITextField *txt_Player2;
    
    IBOutlet UILabel *lbl_Player1;
    IBOutlet UILabel *lbl_Player2;
    
    IBOutlet UILabel *lbl_HardMode;
    IBOutlet UISwitch *switch_HardMode;
    
    IBOutlet UILabel *lbl_GameMode;

}

@property UIImageView *img_Player1;
@property UIImageView *img_Player2;

@property UITextField *txt_Player1;
@property UITextField *txt_Player2;

@property UILabel *lbl_Player1;
@property UILabel *lbl_Player2;

@property UILabel *lbl_HardMode;
@property UISwitch *switch_HardMode;

@property UILabel *lbl_GameMode;

-(IBAction)onStartGame:(id)sender;
-(IBAction)onBack:(id)sender;
-(IBAction)onHardMode:(id)sender;

@end

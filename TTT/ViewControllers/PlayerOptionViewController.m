//
//  PlayerOptionViewController.m
//  TTT
//
//  Created by VA Gautham  on 8/27/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "PlayerOptionViewController.h"
#import "AppDelegate.h"
#import "GameBoardViewController.h"

@interface PlayerOptionViewController ()

@property AppDelegate *appDelegateInstance;

@end

@implementation PlayerOptionViewController
@synthesize img_Player1, img_Player2;
@synthesize txt_Player1, txt_Player2;
@synthesize lbl_Player1, lbl_Player2;
@synthesize lbl_HardMode, switch_HardMode;
@synthesize lbl_GameMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegateInstance = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    txt_Player1.delegate = self;
    txt_Player2.delegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_Plain-568h.png"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Player1Name = [userDefaults valueForKey:@"Player1Name"];
    UIImage *Player1Image = [userDefaults valueForKey:@"Player1Image"];
    
    [txt_Player1 setText:Player1Name];
    if (Player1Image)
        [img_Player1 setImage:Player1Image];
    
    if (_appDelegateInstance.mGameType == GameType_SinglePlayer)
    {
        [img_Player2 setImage:[UIImage imageNamed:@"AI.png"]];
        [img_Player2 setUserInteractionEnabled:FALSE];
        [img_Player2 setAlpha:0.5];
        
        [txt_Player2 setText:@"Artificial Intelligence"];
        [txt_Player2 setUserInteractionEnabled:FALSE];
        [txt_Player2 setAlpha:0.5];
        
        [switch_HardMode setHidden:FALSE];
        [lbl_HardMode setHidden:FALSE];
        [lbl_GameMode setText:@"Single Player"];
    }
    else if (_appDelegateInstance.mGameType == GameType_MultiPlayer)
    {
        [img_Player2 setImage:[UIImage imageNamed:@"placeholder"]];
        [img_Player2 setUserInteractionEnabled:TRUE];
        [img_Player2 setAlpha:1.0];
        
        NSString *Player2Name = [userDefaults valueForKey:@"Player2Name"];
        UIImage *Player2Image = [userDefaults valueForKey:@"Player2Image"];
        
        [txt_Player2 setText:Player2Name];
        if (Player2Image)
            [img_Player2 setImage:Player2Image];
        
        [txt_Player2 setUserInteractionEnabled:TRUE];
        [txt_Player2 setAlpha:1.0];
        _appDelegateInstance.mHardMode = HardMode_Off;
        
        [switch_HardMode setHidden:TRUE];
        [lbl_HardMode setHidden:TRUE];
        [lbl_GameMode setText:@"Multi Player"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return TRUE;
}

-(IBAction)onStartGame:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    GameBoardViewController *mGameBoardViewController = [storyboard instantiateViewControllerWithIdentifier:@"GameBoardViewController"];
    [self.navigationController pushViewController:mGameBoardViewController animated:FALSE];
}

-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:FALSE];
}

-(IBAction)onHardMode:(id)sender
{
    if (_appDelegateInstance.mHardMode == HardMode_Off)
        _appDelegateInstance.mHardMode = HardMode_On;
    else
        _appDelegateInstance.mHardMode = HardMode_Off;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (textField == txt_Player1)
        [userDefaults setValue:textField.text forKey:@"Player1Name"];
    else if (textField == txt_Player2)
        [userDefaults setValue:textField.text forKey:@"Player2Name"];
    
    [userDefaults synchronize];
    
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (textField == txt_Player1)
        [userDefaults setValue:textField.text forKey:@"Player1Name"];
    else if (textField == txt_Player2)
        [userDefaults setValue:textField.text forKey:@"Player2Name"];
    
    [userDefaults synchronize];
    
    return TRUE;
}

@end

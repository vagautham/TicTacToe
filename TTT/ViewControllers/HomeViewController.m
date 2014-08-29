//
//  HomeViewController.m
//  TTT
//
//  Created by VA Gautham  on 8/27/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import "HomeViewController.h"
#import "PlayerOptionViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@property AppDelegate *appDelegateInstance;

@end

@implementation HomeViewController
@synthesize homeLogoImage;

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_Plain-568h.png"]]];
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

-(IBAction)onSinglePlayer:(id)sender
{
    _appDelegateInstance.mGameType = GameType_SinglePlayer;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PlayerOptionViewController *mPlayerOptionViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerOptionViewController"];
    [self.navigationController pushViewController:mPlayerOptionViewController animated:FALSE];
}

-(IBAction)onMultiPlayer:(id)sender
{
    _appDelegateInstance.mGameType = GameType_MultiPlayer;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PlayerOptionViewController *mPlayerOptionViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlayerOptionViewController"];
    [self.navigationController pushViewController:mPlayerOptionViewController animated:FALSE];
}

@end

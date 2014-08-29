//
//  HomeViewController.h
//  TTT
//
//  Created by VA Gautham  on 8/27/14.
//  Copyright (c) 2014 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    IBOutlet UIImageView *homeLogoImage;
}

@property (nonatomic) UIImageView *homeLogoImage;

-(IBAction)onSinglePlayer:(id)sender;
-(IBAction)onMultiPlayer:(id)sender;

@end

//
//  ForgetPassViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsManager.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface ForgetPassViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBotmMargin;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
-(IBAction)backButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *vcTitle;
@property (nonatomic) BOOL isPwdExpired;

@end

//
//  OTPViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTPViewController : UIViewController
@property (strong, nonatomic) NSDictionary *userDict;
@property (strong, nonatomic) NSString *mobile;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (assign, nonatomic)BOOL fromLogin;
@property (assign, nonatomic)BOOL fromForgetPass;

@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIButton *backbtn;
@property (weak, nonatomic) IBOutlet UIButton *resendOTPBtn;
- (IBAction)resendOTPButtonTapped:(id)sender;

@end

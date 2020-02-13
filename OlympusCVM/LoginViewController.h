//
//  LoginViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 20/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"



@protocol LoginViewControllerDelegate;


@interface LoginViewController : UIViewController

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)forgetPasswordButtonTapped:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)registerButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@end

@protocol LoginViewControllerDelegate <NSObject>
@optional
-(void)loginViewDissmissed;
-(void)dismissViewWithSuccessfulLogin;

@end

//
//  SignUpViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 20/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignUpViewControllerDelegate;

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) id<SignUpViewControllerDelegate> delegate;
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end


@protocol SignUpViewControllerDelegate <NSObject>
@optional
-(void)registerUserSucessFully;

@end

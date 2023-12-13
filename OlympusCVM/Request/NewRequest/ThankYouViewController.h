//
//  ThankYouViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ThankYouViewControllerDelegate;

@interface ThankYouViewController : UIViewController
@property (strong, nonatomic) id <ThankYouViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UILabel *requestNumLbl;
@property (weak, nonatomic) IBOutlet UITextView *msgLbl;
@property (weak, nonatomic) IBOutlet UIButton *backToHomeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (IBAction)backToHomeButtonTapped:(id)sender;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *remarkTitle;

@property (strong, nonatomic) NSDictionary *requestInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleMsgHgt;
@property (weak, nonatomic) IBOutlet UILabel *thankULbl;

@end


@protocol ThankYouViewControllerDelegate <NSObject>
@optional
-(void)thankYouMsgDidDismissed;
@end

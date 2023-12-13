//
//  RegistrationFinalViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RegistrationFinalVCDelegate;
@interface RegistrationFinalViewController : UIViewController
@property (strong, nonatomic) id <RegistrationFinalVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;
- (IBAction)startButtonTapped:(id)sender;
@property(strong, nonatomic) NSString *msg;
@property(strong, nonatomic) NSString *btnMsg;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *msgView;



@end


@protocol RegistrationFinalVCDelegate <NSObject>
@optional
-(void)startApplication;
@end

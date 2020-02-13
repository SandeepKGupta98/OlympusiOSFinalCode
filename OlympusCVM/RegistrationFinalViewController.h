//
//  RegistrationFinalViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationFinalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLbl;
- (IBAction)startButtonTapped:(id)sender;
@property(strong, nonatomic) NSString *msg;
@property(strong, nonatomic) NSString *btnMsg;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *msgView;



@end

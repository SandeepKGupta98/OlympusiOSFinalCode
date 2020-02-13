//
//  ConfirmPwdViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsManager.h"

@interface ConfirmPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBotmMargin;
@property (strong, nonatomic) NSString *mobile;

@end

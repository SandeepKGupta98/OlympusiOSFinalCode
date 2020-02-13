//
//  PrivacyPolicyViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 17/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "MFSideMenu.h"

@interface PrivacyPolicyViewController : UIViewController
- (IBAction)menuButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

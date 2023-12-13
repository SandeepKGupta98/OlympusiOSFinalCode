//
//  InboxDetailViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 20/12/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
-(IBAction)backBtnTapped:(id)sender;
@property (strong, nonatomic)NSString *mailId;
@property (assign, nonatomic)NSInteger inboxCount;

@end

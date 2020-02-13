//
//  AccountSummaryViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSummaryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableDictionary *userDict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;






- (IBAction)gotoBackPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disHgt;
@property (weak, nonatomic) IBOutlet UIView *logoutView;
@property (assign, nonatomic)BOOL showBackBtn;
//@property (assign, nonatomic)BOOL showNextOption;
@property (weak, nonatomic) IBOutlet UIView *backBtnView;
- (IBAction)logoutButtonTapped:(id)sender;
@property (strong, nonatomic)NSString *userType;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *backBtnImg;




@end

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *hosNamBg;
@property (weak, nonatomic) IBOutlet UILabel *hosName;
@property (weak, nonatomic) IBOutlet UILabel *depName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *depMargin;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHgt;

@end

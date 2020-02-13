//
//  StatusViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EmployeeCellDelegate;
@interface StatusViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)gotoBackPage:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *statusTableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@property (strong, nonatomic)NSString *type;
@property (strong, nonatomic)NSString *reqId;
@property (assign, nonatomic)BOOL fromNotification;
@property (strong, nonatomic)NSDictionary *requestInfo;
@property(nonatomic, assign)BOOL showEngineerInfo;

@property (weak, nonatomic) IBOutlet UIButton *rateus;
@property (weak, nonatomic) IBOutlet UIView *footerView;
-(IBAction)rateUsButtonTapped:(id)sender;

@end

@interface EmployeeCell:UITableViewCell
@property (strong, nonatomic) id<EmployeeCellDelegate> delegate;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *empImg;
@property (weak, nonatomic) IBOutlet UILabel *empName;
@property (weak, nonatomic) IBOutlet UILabel *empNum;
@property (weak, nonatomic) IBOutlet UILabel *empEmail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *empViewHgt;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;

-(IBAction)phoneNumberTapped:(id)sender;
-(IBAction)emailTapped:(id)sender;

@end

@protocol EmployeeCellDelegate <NSObject>
@optional
-(void)emailTappedWithCell:(EmployeeCell *)cell index:(NSInteger)index;
-(void)phoneNumberTappedWithCell:(EmployeeCell *)cell index:(NSInteger)index;
@end

@interface RequestEscalationCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@end


@interface RequestCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reqNum;
@property (weak, nonatomic) IBOutlet UILabel *reqType;
@property (weak, nonatomic) IBOutlet UILabel *reqNature;
@property (weak, nonatomic) IBOutlet UILabel *hosName;
@property (weak, nonatomic) IBOutlet UILabel *depName;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHgt;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;



@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@interface TimelineCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *detailBgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@end


@interface StatusFeedbackCell:UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHgt;
@property (weak, nonatomic) IBOutlet UILabel *ratingLbl;
@property (weak, nonatomic) IBOutlet UIImageView *responseSpeedStar;
@property (weak, nonatomic) IBOutlet UIImageView *qualityStar;
@property (weak, nonatomic) IBOutlet UIImageView *appExpStar;
@property (weak, nonatomic) IBOutlet UIImageView *performanceStar;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;



@property (weak, nonatomic) IBOutlet UIView *bgView;
@end


@interface ProductInfoCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UILabel *pName;
@property (weak, nonatomic) IBOutlet UILabel *pSrNum;
@property (weak, nonatomic) IBOutlet UILabel *pDesc;

@end

@interface ReportCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *pdfBgView;
@end

//
//  HistoryViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 24/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (assign, nonatomic) BOOL showSingleSeg;


@property (weak, nonatomic) IBOutlet UIView *backBtnView;
@property (strong, nonatomic)NSString *type;

- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentCntrl;
- (IBAction)segmentControlValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *onGoingLbl;
@property (weak, nonatomic) IBOutlet UIView *onGoingLblView;


@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end


@protocol HistoryCellDelegate;
@interface HistoryCell : UITableViewCell
@property (strong, nonatomic) id <HistoryCellDelegate> delegate;
@property (assign, nonatomic) NSUInteger index;

@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)statusBtnTapped:(id)sender;
- (IBAction)statusBtnTouchDown:(id)sender;
- (IBAction)detailsBtnTapped:(id)sender;
- (IBAction)detailBtnTouchDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *requestNo;

@property (weak, nonatomic) IBOutlet UILabel *requestStatus;
@property (weak, nonatomic) IBOutlet UILabel *receivedOn;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet UILabel *statusTitle;
@property (weak, nonatomic) IBOutlet UILabel *reqTypeTitle;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *escalationWdth;


@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;

@end

@protocol HistoryCellDelegate<NSObject>
@optional
-(void)escalationButtonTappedWithCell:(HistoryCell *)cell andIndex:(NSInteger) index;
-(void)detailButtonTappedWithCell:(HistoryCell *)cell andIndex:(NSInteger) index;
@end



@protocol ClosedReqCellDelegate;
@interface ClosedReqCell : UITableViewCell
@property (strong, nonatomic) id <ClosedReqCellDelegate> delegate;
@property (assign, nonatomic) NSUInteger index;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *requestNo;


@property (weak, nonatomic) IBOutlet UILabel *receivedOn;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UILabel *reqTypeTitle;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitle;
- (IBAction)detailButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *escalationBtnWidth;

- (IBAction)escalationButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;

@end

@protocol ClosedReqCellDelegate<NSObject>
@optional
-(void)escalationButtonTapped:(ClosedReqCell *)cell andIndex:(NSInteger) index;
-(void)detailButtonTapped:(ClosedReqCell *)cell andIndex:(NSInteger) index;
@end




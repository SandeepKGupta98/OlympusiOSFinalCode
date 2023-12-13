//
//  FeedbackViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 04/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FeedbackCellDelegate;
@protocol FeedbackRemarkCellDelegate;
@protocol FeedbackViewControllerDelegate;
@interface FeedbackViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id<FeedbackViewControllerDelegate>delegate;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *requestId;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSString *requestSubType;
@property (strong, nonatomic) NSString *requestRemark;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomMargin;
- (IBAction)crossButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@property (weak, nonatomic) IBOutlet UIButton *ratusBtn;
-(IBAction)submitButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *feedbackLbl;
@property (weak, nonatomic) IBOutlet UIImageView *feedbackImg;



@end
@protocol FeedbackViewControllerDelegate<NSObject>
-(void)dismissFeedbackViewController;
@end

@interface FeedbackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) id<FeedbackCellDelegate>delegate;
@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *forthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
-(void)setFeedbackValue:(int )rating;

- (IBAction)firstStarTapped:(id)sender;
- (IBAction)secondStarTapped:(id)sender;
- (IBAction)thirdStarTapped:(id)sender;
- (IBAction)forthStarTapped:(id)sender;
- (IBAction)fifthStarTapped:(id)sender;

@end
@protocol FeedbackCellDelegate<NSObject>

- (void)firstStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index;
- (void)secondStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index;
- (void)thirdStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index;
- (void)forthStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index;
- (void)fifthStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index;
@end

@interface FeedbackRemarkCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) id<FeedbackRemarkCellDelegate>delegate;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
@protocol FeedbackRemarkCellDelegate<NSObject>

- (void)textViewString:(NSString *)textViewText;
@end

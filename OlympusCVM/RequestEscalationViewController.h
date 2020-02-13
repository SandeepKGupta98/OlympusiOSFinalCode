//
//  RequestEscalationViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 30/05/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EscalationCellDelegate;

@interface RequestEscalationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic)IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic)IBOutlet UIView *ansView;
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UIButton *doneBtn;

@property (strong, nonatomic)NSString *reqType;
@property (strong, nonatomic)NSString *reqId;

@property (weak, nonatomic) IBOutlet UIView *loaderView;

- (IBAction)hideAnsList:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;

@end


@interface EscalationCell : UITableViewCell

@property (weak, nonatomic) id<EscalationCellDelegate>delegate;
@property (assign, nonatomic) NSInteger index;

- (IBAction)buttonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ansLbl;

@property (weak, nonatomic) IBOutlet UIImageView *checkboxImg;

@end

@protocol EscalationCellDelegate<NSObject>
-(void)buttonTappedWithCell:(EscalationCell *)cell anIndex:(NSInteger)index;
@end


//
//  AboutViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 03/07/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface AboutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) BOOL isIndia;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)moreInfoTapped:(id)sender;

@end

@interface MainHeadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end
@interface SubHeadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headingLbl;

@end
@interface SubHeadingCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headingLbl2;
@end

@interface DetailsHeadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end
@interface ImagesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagView;

@end
NS_ASSUME_NONNULL_END

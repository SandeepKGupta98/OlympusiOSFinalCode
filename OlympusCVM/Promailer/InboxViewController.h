//
//  InboxViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/12/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol InboxCellDelegate;

@interface InboxViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UILabel *inboxCount;
-(IBAction)menuButtonTapped:(id)sender;
@end

@interface InboxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *inboxNewImg;
-(IBAction)showDetailBtnTapped:(id)sender;
@end



@protocol InboxCellDelegate <NSObject>



@end

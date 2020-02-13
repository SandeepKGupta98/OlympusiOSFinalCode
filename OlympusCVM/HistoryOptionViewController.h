//
//  HistoryOptionViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryOptionCellDelegate;
@interface HistoryOptionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)menuButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

@end

@interface HistoryOptionCell:UITableViewCell
@property (weak, nonatomic)IBOutlet UIImageView *cateImg;
- (IBAction)optionButtonTapped:(id)sender;
- (IBAction)optionButtonTappedTouchDown:(id)sender;
- (IBAction)optionButtonDragOutside:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLblWdth;


@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id <HistoryOptionCellDelegate>delegate;

@end

@protocol HistoryOptionCellDelegate<NSObject>

-(void)categotyTappedWithCell:(HistoryOptionCell *)cell andIndex:(NSInteger) index;
@end

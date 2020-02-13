//
//  OptionsViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThankYouViewController.h"
#import "StatusViewController.h"



@protocol OptionCellDelegate;

@interface OptionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonTapped:(id)sender;
@property (strong, nonatomic)  NSString *superCate;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *loaderView;


@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end



@interface OptionCell : UITableViewCell
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id <OptionCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) NSString *category;
- (IBAction)buttonTapped:(id)sender;
- (IBAction)buttonTappedTouchDown:(id)sender;
- (IBAction)touchDragOutside:(id)sender;
- (IBAction)buttonDragExit:(id)sender;
- (IBAction)buttonTouchDragInside:(id)sender;


@end


@protocol OptionCellDelegate<NSObject>
@optional
-(void) buttonTappedWithOptionCell:(OptionCell *)cell andIndex:(NSInteger )index;
@end

//
//  ExistingRequestViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/03/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ExistingReqCellDelegate;

@interface ExistingRequestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)  NSString *superCate;
@property (strong, nonatomic)  NSString *subCate;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)gotoBackView:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

//existingRequestTapped
@end





@interface ExistingReqCell : UITableViewCell
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) id <ExistingReqCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) NSString *category;
- (IBAction)buttonTapped:(id)sender;
- (IBAction)buttonTappedTouchDown:(id)sender;
- (IBAction)touchDragOutside:(id)sender;
- (IBAction)buttonDragExit:(id)sender;
- (IBAction)buttonTouchDragInside:(id)sender;


@end


@protocol ExistingReqCellDelegate<NSObject>
@optional
-(void) buttonTappedWithOptionCell:(ExistingReqCell *)cell andIndex:(NSInteger )index;
@end

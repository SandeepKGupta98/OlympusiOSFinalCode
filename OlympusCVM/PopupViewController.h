//
//  PopupViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 18/06/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopupViewControllerDelegate;
@interface PopupViewController : UIViewController
typedef enum : NSUInteger {
    PopupViewTypeService,
    PopupViewTypeEnquiry,
    PopupViewTypeAcademic,
    PopupViewTypeOthers,
} PopupViewType;


@property (strong, nonatomic)id<PopupViewControllerDelegate>delegate;
@property (assign, nonatomic) PopupViewType type;
@property (weak, nonatomic)IBOutlet UIView *contentView;
@property (weak, nonatomic)IBOutlet UIImageView *iconImg;
@property (weak, nonatomic)IBOutlet UILabel *descLbl;
-(IBAction)gotoSubCategory:(id)sender;
-(IBAction)crossButtonTapped:(id)sender;
@end

@protocol PopupViewControllerDelegate <NSObject>
@optional
-(void)enterButtonTapped:(PopupViewController *)vc withType:(PopupViewType )type;
-(void)dismissPopupWithPopupController:(PopupViewController *)vc withType:(PopupViewType )type;

@end

NS_ASSUME_NONNULL_END

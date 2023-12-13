//
//  RemarksViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProdCateCellDelegate;

@interface RemarksViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (strong, nonatomic)  NSString *superCate;
@property (strong, nonatomic)  NSString *subCate;
@property (weak, nonatomic) IBOutlet UIView *prodCateView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)doneButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerBgViewBotmMargin;

@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *pickerDoneButton;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end


@interface ProdCateCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cateName;
@property (weak, nonatomic) IBOutlet UILabel *subCateName;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImg;
@property (strong, nonatomic) id<ProdCateCellDelegate> delegate;
@property (assign, nonatomic)NSInteger index;

- (IBAction)checkBoxTapped:(id)sender;

@end

@protocol ProdCateCellDelegate<NSObject>
-(void)checkboxTappedWithCell:(ProdCateCell *)cell andIndex:(NSInteger)index;

@end

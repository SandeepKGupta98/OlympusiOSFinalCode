//
//  HospitalsViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 12/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol OtherDepCellDelegate;
@protocol DepartmentCellDelegate;
@protocol HospitalsViewControllerDelegate;
@interface HospitalsViewController : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)backButtonTapped:(id)sender ;

@property (weak, nonatomic) IBOutlet UIView *pickerBgView;

- (IBAction)doneBtnTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBotmMargin;
@property (strong, nonatomic) id<HospitalsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *depBgView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomMargin;

- (IBAction)crossButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgViewHgt;
- (IBAction)msgViewOkButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgTopMargin;
@property (weak, nonatomic) IBOutlet UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) NSMutableDictionary *hosInfo;
@property (strong, nonatomic) NSNumber *hosIndex;
@property(nonatomic,assign) NSInteger hospitalIndex;

-(IBAction)footerDoneBtnTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *depDoneBtn;

@end

@protocol HospitalsViewControllerDelegate<NSObject>
-(void)dismissHospitalVCWithInfo:(NSMutableDictionary *)infoDict index:(NSInteger) hosIndex;
@end



@interface DepartmentCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *depName;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImg;
@property (strong, nonatomic) id<DepartmentCellDelegate> delegate;
@property (assign, nonatomic)NSInteger index;

- (IBAction)checkBoxTapped:(id)sender;

@end

@protocol DepartmentCellDelegate<NSObject>
-(void)checkboxTappedWithCell:(DepartmentCell *)cell andIndex:(NSInteger)index;
@end


@interface OtherDepCell: UITableViewCell<UITextFieldDelegate>
@property (strong, nonatomic) id<OtherDepCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *depTextField;


@end
@protocol OtherDepCellDelegate<NSObject>
-(void)displayMsgView:(OtherDepCell *)cell ;

@end


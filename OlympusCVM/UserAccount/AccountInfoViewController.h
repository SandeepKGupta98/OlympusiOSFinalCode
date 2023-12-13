//
//  AccountInfoViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBotmMargin;
@property (weak, nonatomic) IBOutlet UIView *pickerBgView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)hidePickerView:(id)sender;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic)NSString *vctitle;
@property (strong, nonatomic)NSString *userType;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@end

//
//  AccountInfoViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "AccountSummaryViewController.h"
#import "HospitalsViewController.h"

#import "UtilsManager.h"

#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

#define TransparentBG_Color ([UIColor colorWithWhite:0 alpha:0.5])
@interface AccountInfoViewController ()<UITextFieldDelegate, HospitalsViewControllerDelegate>{
    UITextField *title;
    UITextField *fName;
//    UITextField *mName;
    UITextField *lName;
    UITextField *mobile;
    UITextField *email;
    UITextField *cEmail;
    UITextField *pwd;
    UITextField *cPwd;

    UILabel *titleLbl;
    UILabel *fNameLbl;
//    UILabel *mNameLbl;
    UILabel *lNameLbl;
    UILabel *mobileLbl;
    UILabel *emailLbl;
    UILabel *cEmailLbl;
    UILabel *PwdLbl;
    UILabel *cPwdLbl;
    UILabel *hosTitle;
    UIButton *addHosBtn;
    UIButton *nextBtn;
    UIView *hosBgView;

    UITextField *hosName;
    UITextView *tncTextView;
    CGFloat tncTextViewHgt;
    UIButton *checkBox;
    UIImageView *checkBoxImg;
//    UITextField *depName;
//    UITextField *othrDep;
//    UITextField *address;
//    UITextField *city;
//    UITextField *state;
//    UITextField *zip;
//    UITextField *country;
//    UITextField *othrCountry;
    
    NSMutableArray *optionAry, *hospitalAry;
    NSString *option;
//    NSMutableDictionary *userInfo;
    float countryY;
    float depY;
    float cEmailY;
}

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.userInfo == nil ) {
        self.userInfo = [[NSMutableDictionary alloc] init];
    }

    countryY =0;
    depY = 0;
    optionAry = [[NSMutableArray alloc] init];
    hospitalAry = [[NSMutableArray alloc] init];
    self.doneBtn.layer.cornerRadius = 5;
    self.doneBtn.layer.borderWidth = 1;
    self.doneBtn.layer.borderColor = Yellow_Border_Color;
    self.pickerBgView.hidden = YES;
//    self.pageTitle.backgroundColor = Yellow_Color;
//    self.pageTitle.textColor = Dark_Yellow_Color;
    if (self.vctitle) {
        self.pageTitle.text = self.vctitle;//
    }
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    
    if (self.userInfo.allKeys.count>0) {
        [self createScrollViewSubView];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.userInfo.allKeys.count>0) {
        
    }else{
        NSArray *subViews = self.scrollView.subviews;
        for (int i=0; i<subViews.count; i++) {
            [[subViews objectAtIndex:i] removeFromSuperview];
        }
        [self createScrollViewSubView];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark-  UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == title || textField == hosName) {
        [optionAry removeAllObjects];
        if (textField == title) {
            option=TITLE_KEY;
            [optionAry addObject:@"Dr."];
            [optionAry addObject:@"Mr."];
            [optionAry addObject:@"Ms."];
        }else if (textField == hosName) {
            
            if (hospitalAry.count>=5) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"You can not add more than five hospitals. Please edit existing hospitals." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return NO;
            }
            
            if (title.text.length>0) {
                [self.userInfo setObject:title.text forKey:TITLE_KEY];
            }
            if (fName.text.length>0) {
                [self.userInfo setObject:fName.text forKey:FNAME_KEY];
            }
//            if (mName.text.length>0) {
//                [self.userInfo setObject:mName.text forKey:MNAME_KEY];
//            }
            if (lName.text.length>0) {
                [self.userInfo setObject:lName.text forKey:LNAME_KEY];
            }
            
            
            if (mobile.text.length>4) {
                if ([[UtilsManager sharedObject] isValidPhone:mobile.text]) {
                    [self.userInfo setObject:mobile.text forKey:MOBILE_KEY];
                }
            }
            
            if (email.text.length>0) {
                if ([[UtilsManager sharedObject] isValidEmail:email.text]) {
                    if ([email.text isEqualToString:cEmail.text]) {
                        [self.userInfo setObject:email.text forKey:EMAIL_KEY];
                    }
                }
            }
            if (pwd.text.length>0) {
                if ([pwd.text isEqualToString:cPwd.text]) {
                    [self.userInfo setObject:pwd.text forKey:PWD_KEY];
                }
            }

            
            
            
            [self hideKeyboard];
            UIStoryboard *mainStoryboard;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            }else{
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            }
            HospitalsViewController *hospitalsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"hospitalsVC"];
            hospitalsVC.delegate = self;
            hospitalsVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:hospitalsVC animated:NO completion:nil];
            return NO;
        }
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:0 animated:YES];

        [self hideKeyboard];
        self.pickerBgView.hidden = NO;
        return NO;
    }else{
        self.pickerBgView.hidden = YES;
        return YES;
    }
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == cPwd) {
        [self hideKeyboard];
        [self nextButtonTpped];
    }
    return YES;
}

#pragma mark-  Keyboard Method
-(void)hideKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.

    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
            self.scrollBotmMargin.constant = keyboardSize.height-50;
        } else {
            self.scrollBotmMargin.constant = keyboardSize.height;
        }

//        self.scrollBotmMargin.constant = keyboardSize.height;//-50;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.scrollBotmMargin.constant = 0;
    }];
}


#pragma mark-  Other Methods
-(void)createScrollViewSubView{
    
    float y = 20;
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    titleLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = @"Title";
    titleLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:titleLbl];
    y=y+20;

    title = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    title.attributedPlaceholder = [self getMutableStringWithString:@"Title" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    title.font = TextField_Font;
    title.delegate = self;
    title.backgroundColor = TransparentBG_Color;//[UIImage imageNamed:@"unselected_no_border.png"];
    title.contentMode = UIViewContentModeScaleAspectFill;
    title.textColor = [UIColor whiteColor];
    title.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    title.leftViewMode = UITextFieldViewModeAlways;
    title.layer.borderColor = Yellow_Border_Color;
    title.layer.borderWidth = 1;
    title.layer.cornerRadius = 7;
    [title setClipsToBounds:YES];
    
    [self.scrollView addSubview:title];
    y=y+55;

    
    fNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    fNameLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    fNameLbl.textAlignment = NSTextAlignmentLeft;
    fNameLbl.text = @"First Name";
    fNameLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:fNameLbl];
    y=y+20;

    fName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    fName.attributedPlaceholder = [self getMutableStringWithString:@"First Name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    fName.font = TextField_Font;
    fName.delegate = self;
    fName.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
    fName.contentMode = UIViewContentModeScaleAspectFill;
    fName.textColor = [UIColor whiteColor];
    fName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    fName.leftViewMode = UITextFieldViewModeAlways;
    fName.leftViewMode = UITextFieldViewModeAlways;
    fName.layer.borderColor = Yellow_Border_Color;
    fName.layer.borderWidth = 1;
    fName.layer.cornerRadius = 7;
    [fName setClipsToBounds:YES];
    [self.scrollView addSubview:fName];
    y=y+55;

    
//    mNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
//    mNameLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
//    mNameLbl.textAlignment = NSTextAlignmentLeft;
//    mNameLbl.text = @"Middle Name";
//    mNameLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.scrollView addSubview:mNameLbl];
//    y=y+20;
//
//    mName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
////    mName.attributedPlaceholder = [self getMutableStringWithString:@"Middle Name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//    mName.font = TextField_Font;
//    mName.delegate = self;
//    mName.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
//    mName.contentMode = UIViewContentModeScaleAspectFill;
//    mName.textColor = [UIColor whiteColor];
//    mName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
//    mName.leftViewMode = UITextFieldViewModeAlways;
//    mName.layer.borderColor = Yellow_Border_Color;
//    mName.layer.borderWidth = 1;
//    mName.layer.cornerRadius = 7;
//    [mName setClipsToBounds:YES];
//    [self.scrollView addSubview:mName];
//    y=y+55;

    lNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    lNameLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    lNameLbl.textAlignment = NSTextAlignmentLeft;
    lNameLbl.text = @"Last Name";
    lNameLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:lNameLbl];
    y=y+20;

    lName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    lName.attributedPlaceholder = [self getMutableStringWithString:@"Last Name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    lName.font = TextField_Font;
    lName.delegate = self;
    lName.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
    lName.contentMode = UIViewContentModeScaleAspectFill;
    lName.textColor = [UIColor whiteColor];
    lName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    lName.leftViewMode = UITextFieldViewModeAlways;
    lName.layer.borderColor = Yellow_Border_Color;
    lName.layer.borderWidth = 1;
    lName.layer.cornerRadius = 7;
    [lName setClipsToBounds:YES];
    [self.scrollView addSubview:lName];
    y=y+55;



    mobileLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    mobileLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    mobileLbl.textAlignment = NSTextAlignmentLeft;
    mobileLbl.text = @"Mobile Number";
    mobileLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:mobileLbl];
    y=y+20;
    
    mobile = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    mobile.attributedPlaceholder = [self getMutableStringWithString:@"Mobile Number" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    
    UILabel *mobileLeftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    mobileLeftlbl.textAlignment = NSTextAlignmentCenter;
    mobileLeftlbl.font = TextField_Font;
    mobileLeftlbl.text = @"+91";
    mobileLeftlbl.textColor = [UIColor whiteColor];
    mobile.leftView = mobileLeftlbl;
    mobile.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    mobile.font = TextField_Font;
    mobile.text = @"";
    mobile.delegate = self;
    mobile.keyboardType = UIKeyboardTypePhonePad;
    mobile.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
    mobile.contentMode = UIViewContentModeScaleAspectFill;
    mobile.textColor = [UIColor whiteColor];
//    mobile.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
//    mobile.leftViewMode = UITextFieldViewModeAlways;
    mobile.layer.borderColor = Yellow_Border_Color;
    mobile.layer.borderWidth = 1;
    mobile.layer.cornerRadius = 7;
    [mobile setClipsToBounds:YES];
    [self.scrollView addSubview:mobile];
    y=y+55;


    emailLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    emailLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    emailLbl.textAlignment = NSTextAlignmentLeft;
    emailLbl.text = @"Email ID";
    emailLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:emailLbl];
    y=y+20;

    email = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    email.attributedPlaceholder = [self getMutableStringWithString:EMAIL_KEY font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    email.font = TextField_Font;
    email.delegate = self;
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
    email.contentMode = UIViewContentModeScaleAspectFill;
    email.textColor = [UIColor whiteColor];
    email.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    email.leftViewMode = UITextFieldViewModeAlways;
    email.layer.borderColor = Yellow_Border_Color;
    email.layer.borderWidth = 1;
    email.layer.cornerRadius = 7;
    [email setClipsToBounds:YES];
    [self.scrollView addSubview:email];
    y=y+55;


    cEmailLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    cEmailLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    cEmailLbl.textAlignment = NSTextAlignmentLeft;
    cEmailLbl.text = @"Confirm Email ID";
    cEmailLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:cEmailLbl];
    y=y+20;

    cEmail = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//    cEmail.attributedPlaceholder = [self getMutableStringWithString:@"Confirm Email" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    cEmail.font = TextField_Font;
    cEmail.delegate = self;
    cEmail.keyboardType = UIKeyboardTypeEmailAddress;
    cEmail.returnKeyType = UIReturnKeyNext;
    cEmail.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
    cEmail.contentMode = UIViewContentModeScaleAspectFill;
    cEmail.textColor = [UIColor whiteColor];
    cEmail.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    cEmail.leftViewMode = UITextFieldViewModeAlways;
    cEmail.layer.borderColor = Yellow_Border_Color;
    cEmail.layer.borderWidth = 1;
    cEmail.layer.cornerRadius = 7;
    [cEmail setClipsToBounds:YES];
    [self.scrollView addSubview:cEmail];
    y=y+55;
    
    
    
    
    NSLog(@"self.userType:%@",self.userType);
    if ([self.userType isEqualToString:@"new"]) {
        PwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
        PwdLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        PwdLbl.textAlignment = NSTextAlignmentLeft;
        PwdLbl.text = @"Password";
        PwdLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:PwdLbl];
        y=y+20;
        
        pwd = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
        //    pwd.attributedPlaceholder = [self getMutableStringWithString:@"Confirm Email" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        pwd.font = TextField_Font;
        pwd.delegate = self;
        pwd.secureTextEntry = YES;
        pwd.keyboardType = UIKeyboardTypeEmailAddress;
        pwd.returnKeyType = UIReturnKeyNext;
        pwd.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
        pwd.contentMode = UIViewContentModeScaleAspectFill;
        pwd.textColor = [UIColor whiteColor];
        pwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        pwd.leftViewMode = UITextFieldViewModeAlways;
        pwd.layer.borderColor = Yellow_Border_Color;
        pwd.layer.borderWidth = 1;
        pwd.layer.cornerRadius = 7;
        [pwd setClipsToBounds:YES];
        [self.scrollView addSubview:pwd];
        y=y+55;
        
        
        
        cPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
        cPwdLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        cPwdLbl.textAlignment = NSTextAlignmentLeft;
        cPwdLbl.text = @"Confirm Password";
        cPwdLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:cPwdLbl];
        y=y+20;
        
        cPwd = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
        //    pwd.attributedPlaceholder = [self getMutableStringWithString:@"Confirm Email" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        cPwd.font = TextField_Font;
        cPwd.delegate = self;
        cPwd.secureTextEntry = YES;
        cPwd.keyboardType = UIKeyboardTypeEmailAddress;
        cPwd.returnKeyType = UIReturnKeyNext;
        cPwd.backgroundColor = TransparentBG_Color;// = [UIImage imageNamed:@"unselected_no_border.png"];
        cPwd.contentMode = UIViewContentModeScaleAspectFill;
        cPwd.textColor = [UIColor whiteColor];
        cPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        cPwd.leftViewMode = UITextFieldViewModeAlways;
        cPwd.layer.borderColor = Yellow_Border_Color;
        cPwd.layer.borderWidth = 1;
        cPwd.layer.cornerRadius = 7;
        [cPwd setClipsToBounds:YES];
        [self.scrollView addSubview:cPwd];
        y=y+55;
    }
    
    
    cEmailY = y;


    
    
    addHosBtn = [[UIButton alloc] initWithFrame:CGRectMake(65, y, screen_wdth-105, 40)];
    addHosBtn.hidden = YES;
    addHosBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addHosBtn.titleLabel.numberOfLines = 0;
    NSMutableAttributedString *addHosBtnStr = [[UtilsManager sharedObject] getMutableStringWithString:@"If you want to add more hospitals please click here." font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [addHosBtnStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 40)];
    [addHosBtnStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:22/255.0 green:123/255.0 blue:251/255.0 alpha:1.0] range:NSMakeRange(41, 10)];

    [addHosBtn setAttributedTitle:addHosBtnStr forState:UIControlStateNormal];
    [addHosBtn addTarget:self action:@selector(addMoreHosBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addHosBtn];

//    tncTextViewHgt = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-105]+20;
//    tncTextView.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
//    tncTextView.textAlignment = NSTextAlignmentLeft;
//    tncTextView.backgroundColor = [UIColor clearColor];
//    tncTextView.editable = NO;
//    tncTextView.scrollEnabled = NO;
//    tncTextView.selectable = YES;
//    tncTextView.attributedText = str;

    
    
    
    
    hosTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    hosTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    hosTitle.textAlignment = NSTextAlignmentLeft;
    hosTitle.text = @"Hospital";//@"Hospital Name"
    hosTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:hosTitle];
    y=y+20;

    
    
    
    
    
    hosName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    hosName.attributedPlaceholder = [self getMutableStringWithString:@"+ Add Hospitals" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    hosName.font = TextField_Font;
    hosName.delegate = self;
    hosName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hosName.contentMode = UIViewContentModeScaleAspectFill;
    hosName.textColor = [UIColor whiteColor];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_wdth-80, 40)];
    leftView.clipsToBounds = YES;
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *plusIcon = [[UIImageView alloc] initWithFrame:CGRectMake((screen_wdth-80)/2-60, 10, 20, 20)];
    plusIcon.image = [UIImage imageNamed:@"rounded-add-button.png"];
    plusIcon.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:plusIcon];
    UILabel *hosLbl = [[UILabel alloc] initWithFrame:CGRectMake((screen_wdth-80)/2-30, 5, 80, 30)];
    hosLbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"Add Hospital" font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [leftView addSubview:hosLbl];
    UIButton *hosBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screen_wdth-80, 40)];
    [hosBtn addTarget:self action:@selector(addHospitalTapped) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:hosBtn];
    hosName.leftView = leftView;
    hosName.leftViewMode = UITextFieldViewModeAlways;
    hosName.layer.borderColor = Yellow_Border_Color;
    hosName.layer.borderWidth = 1;
    hosName.layer.cornerRadius = 7;
    [hosName setClipsToBounds:YES];
    [self.scrollView addSubview:hosName];
    y=y+65;

    
    

    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        tncTextView = [[UITextView alloc] initWithFrame:CGRectMake(65, y, screen_wdth-105, 40)];
        NSMutableAttributedString * str = [[UtilsManager sharedObject] getMutableStringWithString:@"I agree to the terms and conditions governing the use of the app." font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//        [[NSMutableAttributedString alloc] initWithString:@"I agree to the terms and conditions governing the use of the app."];
        [str addAttribute: NSLinkAttributeName value: [NSString stringWithFormat:@"%@/termsandconditions.pdf",base_url] range: NSMakeRange(15, 20)];
//        [str addAttribute:NSFontAttributeName value:TextField_Font range:NSMakeRange(0, str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 14)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(15, 20)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(35, 29)];
        tncTextViewHgt = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-105]+20;
        tncTextView.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        tncTextView.textAlignment = NSTextAlignmentLeft;
        tncTextView.backgroundColor = [UIColor clearColor];
        tncTextView.editable = NO;
        tncTextView.scrollEnabled = NO;
        tncTextView.selectable = YES;
        tncTextView.attributedText = str;
        [self.scrollView addSubview:tncTextView];
        
        tncTextView.frame = CGRectMake(65, y, screen_wdth-105, tncTextViewHgt);
        checkBox = [[UIButton alloc] initWithFrame:CGRectMake(40, y, 25, 25)];
        checkBox.center = CGPointMake(50, tncTextView.center.y);
        [checkBox addTarget:self action:@selector(tncCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:checkBox];
        
        checkBoxImg = [[UIImageView alloc] initWithFrame:CGRectMake(checkBox.frame.origin.x+5, checkBox.frame.origin.y+5, 15, 15)];
        checkBoxImg.contentMode = UIViewContentModeScaleAspectFit;
        checkBoxImg.image = [UIImage imageNamed:@"uncheckbox.png"];
        [self.scrollView addSubview:checkBoxImg];
        y=y+tncTextViewHgt+20;
        
    }
    
    
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    [nextBtn setAttributedTitle:[self getMutableStringWithString:@"NEXT" font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 7;
    nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [nextBtn addTarget:self action:@selector(nextButtonTpped) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = Yellow_Color;//[UIColor whiteColor]
    [self.scrollView addSubview:nextBtn];
    y=y+65;

    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
//    [self createRestView];
    if (self.userInfo.allKeys.count>0) {
        hospitalAry = [NSMutableArray arrayWithArray:[self.userInfo valueForKey:HOSARY_KEY]];
        [self setUserDataInField];
    }else{
        
    }
}

-(void)addMoreHosBtnTapped:(UIButton *)btn{
    NSLog(@"addMoreHosBtnTapped");
    [self addHospitalTapped];
}

-(void)addHospitalTapped{
    
    if (hospitalAry.count>=5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"You can not add more than five hospitals. Please edit existing hospitals." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (title.text.length>0) {
        [self.userInfo setObject:title.text forKey:TITLE_KEY];
    }
    if (fName.text.length>0) {
        [self.userInfo setObject:fName.text forKey:FNAME_KEY];
    }
    if (lName.text.length>0) {
        [self.userInfo setObject:lName.text forKey:LNAME_KEY];
    }
    if (mobile.text.length>4) {
        if ([[UtilsManager sharedObject] isValidPhone:mobile.text]) {
            [self.userInfo setObject:mobile.text forKey:MOBILE_KEY];
        }
    }
    
    if (email.text.length>0) {
        if ([[UtilsManager sharedObject] isValidEmail:email.text]) {
            if ([email.text isEqualToString:cEmail.text]) {
                [self.userInfo setObject:email.text forKey:EMAIL_KEY];
            }
        }
    }
    if (pwd.text.length>0) {
        if ([pwd.text isEqualToString:cPwd.text]) {
            [self.userInfo setObject:pwd.text forKey:PWD_KEY];
        }
    }
    
    
    
    
    [self hideKeyboard];
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    HospitalsViewController *hospitalsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"hospitalsVC"];
    hospitalsVC.delegate = self;
    hospitalsVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:hospitalsVC animated:NO completion:nil];
}

-(void)tncCheckBoxTapped:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    
    if (btn.isSelected) {
        checkBoxImg.image = [UIImage imageNamed:@"checkbox.png"];
    }else{
        checkBoxImg.image = [UIImage imageNamed:@"uncheckbox.png"];
    }
    
}
-(void)dismissHospitalVCWithInfo:(NSMutableDictionary *)infoDict{
    if (infoDict.allKeys.count>0) {
        NSLog(@"Hopital Details: %@",infoDict);
        
        if ([infoDict valueForKey:@"id"]) {
            for (int i=0; i<hospitalAry.count; i++) {
                if ([[hospitalAry objectAtIndex:i] valueForKey:@"id"] == [infoDict valueForKey:@"id"]) {
                    [hospitalAry replaceObjectAtIndex:i withObject:infoDict];
                    NSLog(@"INDEX: %@",[hospitalAry objectAtIndex:i]);
                    break;
                }
            }
            
        }else{
            [hospitalAry addObject:infoDict];
        }
    }
    [self createRestView];
}

-(void)createRestView{
    float y = 0;
    float hosBgViewHgt = 0;
    [hosBgView removeFromSuperview];
    hosBgView = [[UIView alloc] initWithFrame:CGRectMake(40, cEmailY, screen_wdth-80, 100*hospitalAry.count)];
    hosBgView.clipsToBounds = YES;
//        hosBgView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:hosBgView];
    
    if (hospitalAry.count>0) {
        UILabel *tle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 15)];
        tle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        tle.textAlignment = NSTextAlignmentLeft;
        tle.text = @"Hospital Information";// [NSString stringWithFormat:@"Hospital %d",i+1];
        tle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [hosBgView addSubview:tle];
        y=y+20;
    }

    for (int i = 0; i<hospitalAry.count; i++) {
        NSDictionary *hosDict = [hospitalAry objectAtIndex:i];
        
        

        
        UIView *hosDetailsImg = [[UIView alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 80)];
        hosDetailsImg.clipsToBounds = YES;
        hosDetailsImg.backgroundColor = TransparentBG_Color;
        hosDetailsImg.layer.borderColor = Yellow_Border_Color;
        hosDetailsImg.layer.borderWidth = 1;
        hosDetailsImg.layer.cornerRadius = 7;
        [hosBgView addSubview:hosDetailsImg];
        
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_wdth-115, y, 35, 35)];
        editBtn.tag = 6666666+i;
//        editBtn.layer.borderWidth = 1;
//        editBtn.layer.borderColor = Yellow_Border_Color;
        [editBtn addTarget:self action:@selector(editHospitalBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setImage:[UIImage imageNamed:@"edit_new.png"] forState:UIControlStateNormal];
        [hosBgView addSubview:editBtn];
        hosBgView.clipsToBounds = YES;

        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_wdth-115, y+34, 35, 35)];
//        deleteBtn.layer.borderWidth = 1;
        deleteBtn.tag = 1111111+i;
        [deleteBtn addTarget:self action:@selector(deleteHospitalBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [hosBgView addSubview:deleteBtn];

        //*************************************************************************************************************************

        CGFloat yy = 5;
        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, 130, 20)];
        nameTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"NAME:" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [hosDetailsImg addSubview:nameTitle];
        yy = yy + 20;

        UILabel *nameValue = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, screen_wdth-150, 20)];
        nameValue.numberOfLines = 0;
        NSMutableAttributedString *nameStr = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[hosDict valueForKey:HOSNAME_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        
        CGFloat nameHgt = [[UtilsManager sharedObject] heightOfAttributesString:nameStr withWidth:screen_wdth-150];
        nameValue.attributedText = nameStr;
        nameValue.frame = CGRectMake(10, yy, screen_wdth-150, nameHgt);
        [hosDetailsImg addSubview:nameValue];

        yy = yy + nameHgt +10;

        
        UILabel *depTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, 130, 20)];
//        depTitle.backgroundColor = [UIColor cyanColor];
        depTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT:" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [hosDetailsImg addSubview:depTitle];
        yy = yy + 20;
        
        UILabel *depValue = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, screen_wdth-150, 20)];
        depValue.numberOfLines = 0;
//        depValue.backgroundColor = [UIColor greenColor]; //
        NSString *depName = [hosDict valueForKey:DEPNAME_KEY];
        if (depName == nil) {
            depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[hosDict valueForKey:@"deptAry"]];
        }

        if (depName != nil) {
            NSString *departments = [depName stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSMutableAttributedString *depStr = [[UtilsManager sharedObject] getMutableStringWithString:departments  font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            CGFloat depHgt = [[UtilsManager sharedObject] heightOfAttributesString:depStr withWidth:screen_wdth-150];
            depValue.attributedText = depStr;
            depValue.frame = CGRectMake(10, yy, screen_wdth-150, depHgt);
            yy = yy + depHgt +10;
        }else{
            yy = yy + 20;
        }
        [hosDetailsImg addSubview:depValue];
//        NSLog(@"depStr: %@ ------  depHgt: %f",depStr.string,depHgt);



        UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, 130, 20)];
//        addressTitle.backgroundColor = [UIColor cyanColor];
        addressTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"ADDRESS:" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [hosDetailsImg addSubview:addressTitle];
        yy = yy + 20;
        
        UILabel *addressValue = [[UILabel alloc] initWithFrame:CGRectMake(10, yy, screen_wdth-150, 20)];
        addressValue.numberOfLines = 0;
//        addressValue.backgroundColor = [UIColor greenColor]; //
        
        NSString *address = [[NSString stringWithFormat:@"%@, %@, %@, %@, %@",[hosDict valueForKey:ADDRESS_KEY],[hosDict valueForKey:CITY_KEY],[hosDict valueForKey:STATE_KEY],[hosDict valueForKey:ZIP_KEY],[hosDict valueForKey:COUNTRY_KEY]] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableAttributedString *addressStr = [[UtilsManager sharedObject] getMutableStringWithString:address  font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        CGFloat addressHgt = [[UtilsManager sharedObject] heightOfAttributesString:addressStr withWidth:screen_wdth-150];
        addressValue.attributedText = addressStr;
        addressValue.frame = CGRectMake(10, yy, screen_wdth-150, addressHgt);
        [hosDetailsImg addSubview:addressValue];
        NSLog(@"depStr: %@ ------  depHgt: %f",addressStr.string,addressHgt);
        
        yy = yy + addressHgt +10;
        
        hosDetailsImg.frame = CGRectMake(0, y, screen_wdth-80, yy);
        
        y=y+yy;

        //****************************************************Uncomment below code****************************************************************
//#warning Uncomment below code
        
//        UILabel *hosDetails = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-140, 80)];
//        hosDetails.numberOfLines = 0;
//        NSAttributedString *attributedText = [self getAttributedHopitalText:hosDict];
//        float hgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:screen_wdth-140]+10;
//        hosDetails.attributedText = attributedText;
//        hosDetails.contentMode = UIViewContentModeScaleAspectFill;
//        hosDetails.layer.cornerRadius = 0;
//        [hosDetails setClipsToBounds:YES];
//        [hosBgView addSubview:hosDetails];
//
//        hosDetails.frame = CGRectMake(10, y, screen_wdth-140, hgt);
//        hosDetailsImg.frame = CGRectMake(0, y, screen_wdth-80, hgt);
        
        
//        UIButton *hosDetailsBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, hgt)];
//        [hosDetailsBtn addTarget:self action:@selector(hospitalTapped:) forControlEvents:UIControlEventTouchUpInside];
//        hosDetailsBtn.tag = 989929+i;
//        [hosBgView addSubview:hosDetailsBtn];
        
//        y=y+hgt;
        //*************************************************************************************************************************

        
        
        
        
        
        
        
        
        hosBgViewHgt =  y;
        

//        NSLog(@"hosBgViewHgt: %f",hosBgViewHgt);
        y=y+15;
    }
    
    hosBgView.frame = CGRectMake(40, cEmailY, screen_wdth-80, hosBgViewHgt);

    y = cEmailY + y;//115*hospitalAry.count;
    

    
    if (hospitalAry.count>=1) {
        addHosBtn.frame = CGRectMake(40, y, screen_wdth-80, 40);
        y=y+50;
        addHosBtn.hidden = NO;
        hosTitle.hidden = YES;
        hosName.hidden = YES;
    }else{
        hosTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
        y=y+20;
        hosName.frame = CGRectMake(40, y, screen_wdth-80, 40);
        y=y+65;
        addHosBtn.hidden = YES;
        hosTitle.hidden = NO;
        hosName.hidden = NO;
    }

    
    
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        tncTextView.frame = CGRectMake(65, y, screen_wdth-105, tncTextViewHgt);
        checkBox.center = CGPointMake(50, tncTextView.center.y);
        checkBoxImg.frame = CGRectMake(checkBox.frame.origin.x+5, checkBox.frame.origin.y+5, 15, 15);
        y=y+tncTextViewHgt+20;
    }

    nextBtn.frame = CGRectMake(40, y, screen_wdth-80, 40);
    y=y+65;
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}

-(void)deleteHospitalBtnTapped:(UIButton *)btn{
    NSInteger index = btn.tag-1111111;
    NSDictionary *hosInfo = [hospitalAry objectAtIndex:index];
    NSLog(@"Hospital Info: %@",hosInfo);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [hospitalAry removeObject:hosInfo];
        [self createRestView];
    }];
    [alert addAction:yes];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)editHospitalBtnTapped:(UIButton *)btn{
    NSInteger index = btn.tag-6666666;
    NSDictionary *hosInfo = [hospitalAry objectAtIndex:index];
    NSLog(@"Hospital Info: %@",hosInfo);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to edit?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        HospitalsViewController *hospitalsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"hospitalsVC"];
        hospitalsVC.delegate = self;
        hospitalsVC.hosInfo = [NSMutableDictionary dictionaryWithDictionary:hosInfo];
        hospitalsVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:hospitalsVC animated:NO completion:nil];

    }];
    [alert addAction:yes];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)hospitalTapped:(UIButton *)btn{
    long index  =  btn.tag - 989929;
    NSLog(@"hospitalAry: %@",[hospitalAry objectAtIndex:index]);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Hospital deletion feature is under process." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
-(NSMutableAttributedString *)getAttributedHopitalText:(NSDictionary *)dict{
    
    
    
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] init];
    
    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Name:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@\n",[dict valueForKey:HOSNAME_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Department:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    NSString *depName = [dict valueForKey:DEPNAME_KEY];
    if (depName == nil) {
        depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[dict valueForKey:@"deptAry"]];
    }

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@\n",depName] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Address:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@\n",[dict valueForKey:ADDRESS_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"City:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@\n",[dict valueForKey:CITY_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"State:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@\n",[dict valueForKey:STATE_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Country:" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [atrStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" %@",[dict valueForKey:COUNTRY_KEY]] font:TextField_Font spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    return atrStr;
    
    
}


-(void)setUserDataInField{
    title.text = [self.userInfo valueForKey:TITLE_KEY];
    fName.text = [self.userInfo valueForKey:FNAME_KEY];
//    NSString *mame = [self.userInfo valueForKey:MNAME_KEY];
//    if (![mame isKindOfClass:[NSNull class]] ) {
//        mName.text = mame;
//    }
    lName.text = [self.userInfo valueForKey:LNAME_KEY];
    
    if ([self.userInfo valueForKey:MOBILE_KEY]) {
        NSString *subStr =  [[self.userInfo valueForKey:MOBILE_KEY] substringToIndex:3];
        NSString *subStrFrom =  [[self.userInfo valueForKey:MOBILE_KEY] substringFromIndex:3];

        if ([subStr isEqualToString:@"+91"]) {
            mobile.text = subStrFrom;
        }else{
            mobile.text = [self.userInfo valueForKey:MOBILE_KEY];
        }
    }
    email.text = [[self.userInfo valueForKey:EMAIL_KEY] lowercaseString];
    cEmail.text = [[self.userInfo valueForKey:EMAIL_KEY] lowercaseString];
//    pwd.text = [self.userInfo valueForKey:PWD_KEY];
//    cPwd.text = [self.userInfo valueForKey:PWD_KEY];
    [self createRestView];

//    dismissHospitalVCWithInfo:(NSMutableDictionary *)infoDict{
}
-(void)nextButtonTpped{
    
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        if (!checkBox.isSelected) {
            [self showAlertWithMsg:@"Please select terms and conditions before proceed."]; return;
        }
    }
    if (title.text.length>0) {
        [self.userInfo setObject:title.text forKey:TITLE_KEY];
    }else{
        [self showAlertWithMsg:@"Please select title."]; return;
    }
    if (fName.text.length>0) {
        [self.userInfo setObject:fName.text forKey:FNAME_KEY];
    }else{
        [self showAlertWithMsg:@"First name cannot be blank."];   return;
    }
//    if (mName.text.length>0) {
//        [self.userInfo setObject:mName.text forKey:MNAME_KEY];
//    }else{
//        [self.userInfo setObject:@"" forKey:MNAME_KEY];
//    }
    if (lName.text.length>0) {
        [self.userInfo setObject:lName.text forKey:LNAME_KEY];
    }else{
        [self showAlertWithMsg:@"Last name cannot be blank."];   return;
    }
    if (hospitalAry.count>0) {
        [self.userInfo setObject:hospitalAry forKey:HOSARY_KEY];
    }else{
        [self showAlertWithMsg:@"Please add atleast one hospital."];   return;
    }

    if (mobile.text.length>6) {
//        NSString *subStr =  [mobile.text substringToIndex:3];
//        NSString *subStrFrom =  [mobile.text substringFromIndex:3];
        NSString *mobNum = [NSString stringWithFormat:@"+91%@",mobile.text];
        if ([[UtilsManager sharedObject] isValidPhone:mobNum]) {
            [self.userInfo setObject:mobNum forKey:MOBILE_KEY];
        }else{
            [self showAlertWithMsg:@"Invalid mobile number."];   return;
        }
    }else{
        [self showAlertWithMsg:@"Mobile cannot be blank."];   return;
    }
    if (email.text.length>0) {
        if ([[UtilsManager sharedObject] isValidEmail:email.text]) {
            if ([email.text isEqualToString:cEmail.text]) {
                [self.userInfo setObject:email.text forKey:EMAIL_KEY];
            }else{
                [self showAlertWithMsg:@"Email and confirm email should be same."];   return;
            }
        }else{
            [self showAlertWithMsg:@"Invalid email."];   return;
        }

    }else{
        [self showAlertWithMsg:@"Email cannot be blank."];   return;
    }

    if ([self.userType isEqualToString:@"new"]) {
        if (pwd.text.length>0) {
            if ([pwd.text isEqualToString:cPwd.text]) {
                [self.userInfo setObject:pwd.text forKey:PWD_KEY];
            }else{
                [self showAlertWithMsg:@"Password and confirm password should be same."];   return;
            }
            
        }else{
            [self showAlertWithMsg:@"Pawword cannot be blank."];   return;
        }
    }

    
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    AccountSummaryViewController *accountSummaryVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"accountSummaryVC"];
    accountSummaryVC.userDict = self.userInfo;
    accountSummaryVC.showBackBtn = YES;
    accountSummaryVC.userType  = self.userType;

    [self.navigationController pushViewController:accountSummaryVC animated:NO];
    NSLog(@"userInfo : %@",self.userInfo);
}
-(void)showAlertWithMsg:(NSString *)msg{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Olympus" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark-  UIPickerView Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return optionAry.count;
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED{
    return [self getMutableStringWithString:[optionAry objectAtIndex:row] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
}
- (IBAction)doneButtonTapped:(id)sender {
    self.pickerBgView.hidden = !self.pickerBgView.hidden;
    NSInteger index = [_pickerView selectedRowInComponent:0];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if ([option isEqualToString:TITLE_KEY]) {
        title.text=[optionAry objectAtIndex:index];
    }
}


//-(void )createRestViewWithOtherDepartment{
//    float y = depY;
//    [othrDep removeFromSuperview];
//    if ([depName.text isEqualToString:@"Others"]) {
//        othrDep = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//        othrDep.attributedPlaceholder = [self getMutableStringWithString:@"Other department name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//        othrDep.font = TextField_Font;
//        othrDep.delegate = self;
//        othrDep.background = [UIImage imageNamed:@"unselected_no_border.png"];
//        othrDep.contentMode = UIViewContentModeScaleAspectFill;
//        othrDep.textColor = [UIColor whiteColor];
//        othrDep.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
//        othrDep.leftViewMode = UITextFieldViewModeAlways;
//        othrDep.layer.borderColor = Yellow_Border_Color;
//        othrDep.layer.borderWidth = 1;
//        othrDep.layer.cornerRadius = 0;
//        [othrDep setClipsToBounds:YES];
//        [self.scrollView addSubview:othrDep];
//        y=y+65;
//    }
//
//    address.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//    city.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//    state.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//    zip.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//    country.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//
//    if (othrCountry != nil) {
//        othrCountry.frame = CGRectMake(40, y, screen_wdth-80, 40);
//        y=y+65;
//    }
//
//    mobile.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//
//    email.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//
//
//    cEmail.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+75;
//
//
//    nextBtn.frame = CGRectMake(90, y, screen_wdth-180, 40);
//    y=y+65;
//
//    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
//
//}
//-(void )createRestView{
//    float y = countryY;
//    if (othrDep != nil) {
//        y=y+65;
//    }
//    [othrCountry removeFromSuperview];
//    if ([country.text isEqualToString:@"Others"]) {
//        othrCountry = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
//        othrCountry.attributedPlaceholder = [self getMutableStringWithString:@"Other country name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//        othrCountry.font = TextField_Font;
//        othrCountry.delegate = self;
//        othrCountry.background = [UIImage imageNamed:@"unselected_no_border.png"];
//        othrCountry.contentMode = UIViewContentModeScaleAspectFill;
//        othrCountry.textColor = [UIColor whiteColor];
//        othrCountry.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
//        othrCountry.leftViewMode = UITextFieldViewModeAlways;
//        othrCountry.layer.borderColor = Yellow_Border_Color;
//        othrCountry.layer.borderWidth = 1;
//        othrCountry.layer.cornerRadius = 0;
//        [othrCountry setClipsToBounds:YES];
//        [self.scrollView addSubview:othrCountry];
//        y=y+65;
//    }
//
//    mobile.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//
//    email.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+65;
//
//
//    cEmail.frame = CGRectMake(40, y, screen_wdth-80, 40);
//    y=y+75;
//
//
//    nextBtn.frame = CGRectMake(90, y, screen_wdth-180, 40);
//    y=y+65;
//
//    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
//
//}











-(NSMutableAttributedString *)getMutableStringWithString:(NSString *)string font:(UIFont *)font spacing:(float )spacing textColor:(UIColor *)textColor lineSpacing:(CGFloat )lineSpacing andNSTextAlignment:(NSTextAlignment )alignment{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    if (font!=nil) {
        [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    }
    if (spacing!=0) {
        [attrStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:spacing] range:NSMakeRange(0, string.length)];
    }
    if (textColor!=nil) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, string.length)];
    }
    
    if (lineSpacing) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = lineSpacing;
        paraStyle.alignment = alignment;
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    }
    
    return attrStr;
    
}

- (IBAction)hidePickerView:(id)sender {
    self.pickerBgView.hidden = YES;
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

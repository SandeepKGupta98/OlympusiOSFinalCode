//
//  AccountSummaryViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "AccountSummaryViewController.h"
#import "UtilsManager.h"
#import "OTPViewController.h"
#import "AccountInfoViewController.h"
#import "ViewController.h"
#import "RegistrationFinalViewController.h"

#define TransparentBG_Color ([UIColor colorWithWhite:0 alpha:0.5])
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface AccountSummaryViewController ()<UITextFieldDelegate>{
    UILabel *idtitle;
    UILabel *idValue;
    UILabel *nametitle;
    UILabel *nameValue;
    UILabel *departmentValue;
    UILabel *addressValue;
    UILabel *cityValue;
    UILabel *stateValue;
    UILabel *zipValue;
    UILabel *countryValue;
    UILabel *mobileValue;
    UILabel *emailValue;
    NSArray *userHosAry;
    NSMutableArray *flagAry;
    
    // Design Change
    UITextField *title;
    UITextField *nameTextField;
    UITextField *mobileTextField;
    UITextField *emailTextField;

    UILabel *ttlLbl;
    UILabel *nameTtlLbl;
    UILabel *mobileTtlLbl;
    UILabel *emailTtlLbl;

    
    
}
@end
@implementation AccountSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.loaderView.hidden = YES;
    flagAry = [[NSMutableArray alloc] init];
    if (self.showBackBtn) {
//        self.backBtnView.hidden = NO;
        self.disclaimerLbl.hidden = NO;
        self.disHgt.constant = 45;
        self.titleLbl.text = @"CONFIRM YOUR PROFILE";
        self.titleLbl.hidden = NO;
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            
        }
        
        if ([self.userType isEqualToString:@"new"]) {
            self.disclaimerLbl.text = @"Please confirm your below mentioned details and click on Next button to proceed.";
        }else{
            self.disclaimerLbl.text = @"Please confirm your below mentioned details.";
        }
        self.backBtnImg.image = [UIImage imageNamed:@"back.png"];

    }else{
        self.backBtnImg.image = [UIImage imageNamed:@"menu_icon.png"];
//        self.backBtnView.hidden = YES;
        self.disclaimerLbl.hidden = YES;
        self.disHgt.constant = 0;
        self.titleLbl.text = @"ACCOUNT";
        self.titleLbl.hidden = NO;
    }

    self.bgImage.layer.cornerRadius = 7;
    self.bgImage.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgImage.layer.borderWidth = 1;

    
    

}
//This is your user profile. Click on next to confirm the information.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *subviews=self.scrollView.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if (!self.showBackBtn) {
        self.userDict = [NSMutableDictionary dictionaryWithDictionary:[[UtilsManager sharedObject]getUserDetailsFromDefaultUser]];
    }
    userHosAry = [NSArray arrayWithArray:[self.userDict valueForKey:HOSARY_KEY]];
    [self createScrollView];

//
//    [self createTableHeaderView];
//    [self createTableFooterView];
//    [flagAry removeAllObjects];
//
    for (int i = 0 ; i<userHosAry.count; i++) {
        [flagAry addObject:[NSNumber numberWithBool:YES]];
    }

//
//
//    [self createUserDetails];
//
//
//    [self setUserInfo];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
//
//    [self.tableView reloadData];

}

-(void)createUserDetails{
    NSLog(@"USer Info: %@",self.userDict);
    float y=0;


    if ([self.userDict valueForKey:@"customer_id"]) {
        idtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 20)];
        idtitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"ID : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview:idtitle];
        y=y+20;

        
        idValue = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 25)];
        idValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[self.userDict valueForKey:@"customer_id"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview:idValue];
        y=y+35;
    }

    
    

    
    
    nametitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 20)];
//    nametitle.backgroundColor = [UIColor cyanColor];
    nametitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"NAME : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:nametitle];
    y=y+20;

    
    nameValue = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 25)];
    nameValue.numberOfLines = 0;
    [self.scrollView addSubview:nameValue];
    if (self.userDict) {
        NSString *name;
//        NSString *mame = [self.userDict valueForKey:MNAME_KEY];
        
//        if (![mame isKindOfClass:[NSNull class]]) {
//            name = [NSString stringWithFormat:@"%@ %@ %@ %@",[self.userDict valueForKey:TITLE_KEY], [self.userDict valueForKey:FNAME_KEY],mame,[self.userDict valueForKey:LNAME_KEY]];
//        }else{
//            name = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:TITLE_KEY], [self.userDict valueForKey:FNAME_KEY],[self.userDict valueForKey:LNAME_KEY]];
//        }

        name = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:TITLE_KEY], [self.userDict valueForKey:FNAME_KEY],[self.userDict valueForKey:LNAME_KEY]];

        nameValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:name font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];

        CGFloat nameValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:nameValue.attributedText withWidth:screen_wdth-80];
        nameValue.frame = CGRectMake(0, y, screen_wdth-80, nameValueHgt);

        y=y+nameValueHgt+10;
    }else{
        y=y+35;
    }

    
    UILabel *mobileTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 20)];
    mobileTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"MOBILE : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:mobileTitle];
    y=y+20;

    mobileValue = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 25)];
    mobileValue.numberOfLines = 0;
    [self.scrollView addSubview:mobileValue];
    
    if (self.userDict) {
        mobileValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[self.userDict valueForKey:MOBILE_KEY]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        CGFloat mobileValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:mobileValue.attributedText withWidth:screen_wdth-80];
        mobileValue.frame = CGRectMake(0, y, screen_wdth-80, mobileValueHgt);

        y=y+mobileValueHgt+10;
    }else{
        y=y+35;
    }

    
    
    
    
    
    UILabel *emailTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 20)];
    emailTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"EMAIL ID : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:emailTitle];
    y=y+20;

    emailValue = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 25)];
    emailValue.numberOfLines = 0;
    [self.scrollView addSubview:emailValue];
    if (self.userDict) {
        emailValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[[self.userDict valueForKey:EMAIL_KEY]lowercaseString]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];

        CGFloat emailValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:emailValue.attributedText withWidth:screen_wdth-80];
        emailValue.frame = CGRectMake(0, y, screen_wdth-80, emailValueHgt);
        
        y=y+emailValueHgt+20;
    }else{
        y=y+45;
    }

    

    UILabel *hosInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 20)];
    hosInfoTitle.textAlignment = NSTextAlignmentLeft;
    hosInfoTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"HOSPITAL INFORMATION " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:hosInfoTitle];
    y=y+30;


    NSArray *hosAry = [self.userDict valueForKey:HOSARY_KEY];
    
    for (int i=0; i<hosAry.count; i++) {
        NSDictionary *hosInfo = [hosAry objectAtIndex:i];
        
        
        
        UILabel *hospitalTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 90, 25)];
        NSMutableAttributedString *titleAtr = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"Hospital %d:",i+1] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        hospitalTitle.attributedText = titleAtr;
        CGFloat hospitalTitleHgt = [[UtilsManager sharedObject] heightOfAttributesString:titleAtr withWidth:90];
        hospitalTitle.frame  = CGRectMake(10, y, 90, hospitalTitleHgt);
        [self.scrollView addSubview:hospitalTitle];
        y=y+25;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 70, 1)];
        line.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
        [self.scrollView addSubview:line];
        y=y+10;



        UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 20)];
        nameTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"NAME : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview:nameTitle];
        y=y+20;

        
        UILabel *nameValue = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 25)];
        nameValue.numberOfLines = 0;
        [self.scrollView addSubview:nameValue];
        if ([hosInfo valueForKey:HOSNAME_KEY]) {
            nameValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[hosInfo valueForKey:HOSNAME_KEY] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            CGFloat nameValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:nameValue.attributedText withWidth:screen_wdth-90];
            nameValue.frame = CGRectMake(10, y, screen_wdth-90, nameValueHgt);
            y=y+nameValueHgt +10;
        }else{
            y=y+35;
        }


        
        
        UILabel *depTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 20)];
        depTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview:depTitle];
        y=y+20;

        
        UILabel *depValue = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 25)];
        depValue.numberOfLines = 0;
        NSString *depName = [hosInfo valueForKey:DEPNAME_KEY];
        if (depName == nil) {
            depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[hosInfo valueForKey:@"deptAry"]];
        }
        //getDepartmentNameFromArray
        if (depName) {
            depValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:depName font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            CGFloat depValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:depValue.attributedText withWidth:screen_wdth-90];
            depValue.frame = CGRectMake(10, y, screen_wdth-90, depValueHgt);
            y=y+depValueHgt +10;
        }else{
            y=y+35;
        }
        [self.scrollView addSubview:depValue];


        
        UILabel *addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 20)];
        addressTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"ADDRESS : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [self.scrollView addSubview:addressTitle];
        y=y+20;

        
        UILabel *addressValue = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-90, 25)];
        addressValue.numberOfLines = 0;
//        addressValue.backgroundColor = [UIColor greenColor];
        NSString *addStr = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[hosInfo valueForKey:ADDRESS_KEY],[hosInfo valueForKey:CITY_KEY],[hosInfo valueForKey:STATE_KEY],[hosInfo valueForKey:ZIP_KEY],[hosInfo valueForKey:COUNTRY_KEY]];
        if (addStr) {
            addressValue.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:addStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            CGFloat addressValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:addressValue.attributedText withWidth:screen_wdth-90];
            addressValue.frame = CGRectMake(10, y, screen_wdth-90, addressValueHgt);
            y=y+addressValueHgt +10;
        }else{
            y=y+35;
        }
        [self.scrollView addSubview:addressValue];
        y=y+10;

    }
    
    
    
    y=y+10;

    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, y, screen_wdth-180, 40)];
    nextBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    
    if (self.showBackBtn) {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            // Update User
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"UPDATE" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];//SUBMIT
        }else{
            // OTP Verify for User Account
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
            }

        
        self.logoutView.hidden = YES;
    }else{
        // User Account Summary
        [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"EDIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        self.logoutView.hidden = NO;
    }
    nextBtn.layer.cornerRadius = 7;
    nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [nextBtn addTarget:self action:@selector(nextBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
    y=y+60;

    self.scrollView.contentSize = CGSizeMake(screen_wdth-160, y);
    
    
}

-(void)setUserInfo{
    
    if (self.userDict == nil) {
        return;
    }
}

- (IBAction)gotoBackPage:(id)sender{
    if (self.showBackBtn) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }
}

- (void)nextBtnTapped {
    
    
    if (self.showBackBtn) {
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        if ([self.userType isEqualToString:@"new"]) {
            [self registerUsertoServer];
//            OTPViewController *otpVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"otpVC"];
//            otpVC.userDict = self.userDict;
//            [self.navigationController pushViewController:otpVC animated:NO];
        }else{
            
            [self updateUserData];
//            [[NSUserDefaults standardUserDefaults] setObject:self.userDict forKey:@"userInfo"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            RegistrationFinalViewController *registrationFinalVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"registrationFinalVC"];
//            registrationFinalVC.msg = @"YOUR ACCOUNT INFO HAS SUCCESSFULLY UPDATED.";
//            registrationFinalVC.btnMsg = @"GO TO HOME PAGE ";
//
//            [self.navigationController pushViewController:registrationFinalVC animated:NO];
        }
        
    }else{
        
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        AccountInfoViewController *accountInfoVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"accountVC"];
        accountInfoVC.userInfo = [NSMutableDictionary dictionaryWithDictionary:self.userDict];
        accountInfoVC.vctitle = @"ACCOUNT";//@"EDIT YOUR PROFILE";
        accountInfoVC.userType = @"existing";
        [self.navigationController pushViewController:accountInfoVC animated:NO];
    }
}

- (IBAction)logoutButtonTapped:(id)sender{
    // customer_id
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}
    NSString *customer_id = [[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to logout from your My Voice Account?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:Auth_Token forKey:Auth_Token_KEY];
        [param setObject:customer_id forKey:@"customer_id"];
        NSLog(@"param: %@",param);
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
        [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.loaderView.hidden = NO;
        
        
        NSString *url;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        NSString *access_token = [userData valueForKey:@"access_token"];
        [param setObject:access_token forKey:@"token"];

        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v2/customer/logout",[userData valueForKey:@"testing_url"]];
        }else{
            url = [NSString stringWithFormat:@"%@/api/v2/customer/logout",base_url];
        }
        

        
        [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.loaderView.hidden = YES;
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readInboxIds"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkUserActivity"];

                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UINavigationController *vc = [self.tabBarController.viewControllers firstObject];
                [vc popToRootViewControllerAnimated:NO];
                self.tabBarController.selectedIndex = 0;
                UITabBarController *tabBarController = [(MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] centerViewController];
                [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
                [[UtilsManager sharedObject] sessionExpirePopup:self];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];
            }
            
            
            NSLog(@"success! with response: %@", responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.loaderView.hidden = YES;
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];


    }];
    [alert addAction:yes];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deleteBtnTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Deleting your account will delete your access and all your information on this app. This operation cannot be undone. Are you sure you want to continue?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.userDict) {
            
            NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
            NSString *access_token = [userData valueForKey:@"access_token"];

            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //        [param setObject:Auth_Token forKey:Auth_Token_KEY];
            [param setObject:[[self.userDict valueForKey:EMAIL_KEY]lowercaseString] forKey:@"email"];
            [param setObject:access_token forKey:@"token"];
            NSLog(@"param: %@",param);

            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
            [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.loaderView.hidden = NO;
            
            NSString *url;
            
            if ([[userData valueForKey:@"is_testing"] boolValue]) {
//                url = [NSString stringWithFormat:@"%@/api/v2/customer/delete_account",[userData valueForKey:@"testing_url"]];
                url = [NSString stringWithFormat:@"%@/api/v2/customer/delete_account?email=%@&token=%@",[userData valueForKey:@"testing_url"],[[self.userDict valueForKey:EMAIL_KEY]lowercaseString],access_token];}else{
//                url = [NSString stringWithFormat:@"%@/api/v2/customer/delete_account",base_url];
                url = [NSString stringWithFormat:@"%@/api/v2/customer/delete_account?email=%@&token=%@",base_url,[[self.userDict valueForKey:EMAIL_KEY]lowercaseString],access_token];
            }
            NSLog(@"NEW URL:%@", url);

            [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.loaderView.hidden = YES;
                NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
                if ([[responseDict valueForKey:@"status"] intValue] == 200) {
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
                    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readInboxIds"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkUserActivity"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Your account has been successfully." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UINavigationController *vc = [self.tabBarController.viewControllers firstObject];
                        [vc popToRootViewControllerAnimated:NO];
                        self.tabBarController.selectedIndex = 0;
                        UITabBarController *tabBarController = [(MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] centerViewController];
                        [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }else if ([[responseDict valueForKey:@"status"] intValue] == 402){
                    [[UtilsManager sharedObject] sessionExpirePopup:self];
                }else if ([[responseDict valueForKey:@"status"] intValue] == 407){
                    [[UtilsManager sharedObject] showPasswordExpirePopup:self];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.loaderView.hidden = YES;
                NSLog(@"error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
    }];
    [alert addAction:yes];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NOT NOW" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark- UIScrollView Method

-(void)createScrollView{
    
    float y = 20;
    
    UILabel *userTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 150, 25)];
    userTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    userTitle.textAlignment = NSTextAlignmentLeft;
    userTitle.text = @"User Information";
    userTitle.textColor = Yellow_Color;
    [self.scrollView addSubview:userTitle];

    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_wdth-110, y, 20, 20)];
    userImg.contentMode = UIViewContentModeScaleAspectFit;
    userImg.image = [UIImage imageNamed:@"avatar.png"];
    [self.scrollView addSubview:userImg];

    y=y+30;
    

    if ([self.userDict valueForKey:@"customer_id"]) {
        ttlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 15)];
        ttlLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        ttlLbl.textAlignment = NSTextAlignmentLeft;
        ttlLbl.text = @"ID :";
        ttlLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:ttlLbl];
        y=y+20;
        
        title = [[UITextField alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
        title.text = [[UtilsManager sharedObject] removeNullFromString:[self.userDict valueForKey:@"customer_id"]];
        title.font = TextField_Font;
        title.delegate = self;
        title.backgroundColor = TransparentBG_Color;
        title.userInteractionEnabled = NO;
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
    }

    
    
    if (self.userDict) {
        
        nameTtlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 15)];
        nameTtlLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        nameTtlLbl.textAlignment = NSTextAlignmentLeft;
        nameTtlLbl.text = @"NAME :";
        nameTtlLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:nameTtlLbl];
        y=y+20;
        
        
        NSString *name = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:TITLE_KEY], [self.userDict valueForKey:FNAME_KEY],[[UtilsManager sharedObject] removeNullFromString:[self.userDict valueForKey:LNAME_KEY]]];
        
        nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
        nameTextField.text = name;
        nameTextField.font = TextField_Font;
        nameTextField.delegate = self;
        nameTextField.backgroundColor = TransparentBG_Color;
        nameTextField.userInteractionEnabled = NO;
        nameTextField.contentMode = UIViewContentModeScaleAspectFill;
        nameTextField.textColor = [UIColor whiteColor];
        nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        nameTextField.leftViewMode = UITextFieldViewModeAlways;
        nameTextField.layer.borderColor = Yellow_Border_Color;
        nameTextField.layer.borderWidth = 1;
        nameTextField.layer.cornerRadius = 7;
        [nameTextField setClipsToBounds:YES];
        [self.scrollView addSubview:nameTextField];
        y=y+55;

        
        
        
        
        mobileTtlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 15)];
        mobileTtlLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        mobileTtlLbl.textAlignment = NSTextAlignmentLeft;
        mobileTtlLbl.text = @"MOBILE :";
        mobileTtlLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:mobileTtlLbl];
        y=y+20;

        mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
        mobileTextField.text = [[UtilsManager sharedObject] removeNullFromString:[self.userDict valueForKey:MOBILE_KEY]];
        mobileTextField.font = TextField_Font;
        mobileTextField.delegate = self;
        mobileTextField.backgroundColor = TransparentBG_Color;
        mobileTextField.userInteractionEnabled = NO;
        mobileTextField.contentMode = UIViewContentModeScaleAspectFill;
        mobileTextField.textColor = [UIColor whiteColor];
        mobileTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        mobileTextField.leftViewMode = UITextFieldViewModeAlways;
        mobileTextField.layer.borderColor = Yellow_Border_Color;
        mobileTextField.layer.borderWidth = 1;
        mobileTextField.layer.cornerRadius = 7;
        [mobileTextField setClipsToBounds:YES];
        [self.scrollView addSubview:mobileTextField];
        y=y+55;

        emailTtlLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 15)];
        emailTtlLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
        emailTtlLbl.textAlignment = NSTextAlignmentLeft;
        emailTtlLbl.text = @"EMAIL ID : ";
        emailTtlLbl.textColor = [UIColor colorWithWhite:1 alpha:0.75];
        [self.scrollView addSubview:emailTtlLbl];
        y=y+20;
        
        emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
        emailTextField.text = [[UtilsManager sharedObject] removeNullFromString:[[self.userDict valueForKey:EMAIL_KEY] lowercaseString]];
        emailTextField.font = TextField_Font;
        emailTextField.delegate = self;
        emailTextField.backgroundColor = TransparentBG_Color;
        emailTextField.userInteractionEnabled = NO;
        emailTextField.contentMode = UIViewContentModeScaleAspectFill;
        emailTextField.textColor = [UIColor whiteColor];
        emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        emailTextField.leftViewMode = UITextFieldViewModeAlways;
        emailTextField.layer.borderColor = Yellow_Border_Color;
        emailTextField.layer.borderWidth = 1;
        emailTextField.layer.cornerRadius = 7;
        [emailTextField setClipsToBounds:YES];
        [self.scrollView addSubview:emailTextField];
        y=y+65;
        
    }
    
    
    
    
    UILabel *hospitalTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 150, 25)];
    hospitalTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    hospitalTitle.textAlignment = NSTextAlignmentLeft;
    hospitalTitle.text = @"Hospitals";
    hospitalTitle.textColor = Yellow_Color;
    [self.scrollView addSubview:hospitalTitle];
    
    
    UIImageView *hosImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_wdth-110, y, 20, 20)];
    hosImg.contentMode = UIViewContentModeScaleAspectFit;
    hosImg.image = [UIImage imageNamed:@"hospital.png"];
    [self.scrollView addSubview:hosImg];

    y=y+30;

    
    for (int i=0; i<userHosAry.count; i++) {
        NSDictionary *hosInfo = [userHosAry objectAtIndex:i];
        NSString *depName = [hosInfo valueForKey:DEPNAME_KEY];
        if (depName == nil) {
            depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[hosInfo valueForKey:@"deptAry"]];
        }

        NSMutableAttributedString *hospitalInfo = [[UtilsManager sharedObject] getMutableStringWithString:@"NAME:\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        
        [hospitalInfo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[[hosInfo valueForKey:HOSNAME_KEY] capitalizedString]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        [hospitalInfo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT:\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        [hospitalInfo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[depName capitalizedString]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        [hospitalInfo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"ADDRESS:\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        [hospitalInfo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@, %@, %@",[[hosInfo valueForKey:CITY_KEY] capitalizedString],[[hosInfo valueForKey:STATE_KEY]capitalizedString],[[hosInfo valueForKey:COUNTRY_KEY] capitalizedString]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

        CGFloat hospitalInfoHgt = [[UtilsManager sharedObject] heightOfAttributesString:hospitalInfo withWidth:screen_wdth-100];

        UIView *hosBgView = [[UIView alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, hospitalInfoHgt+20)];
        hosBgView.backgroundColor = TransparentBG_Color;
        hosBgView.userInteractionEnabled = NO;
        hosBgView.layer.borderColor = Yellow_Border_Color;
        hosBgView.layer.borderWidth = 1;
        hosBgView.layer.cornerRadius = 7;
        [hosBgView setClipsToBounds:YES];
        [self.scrollView addSubview:hosBgView];
        
        UILabel *hosLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_wdth-100, hospitalInfoHgt)];
        hosLbl.textAlignment = NSTextAlignmentLeft;
        hosLbl.numberOfLines = 0 ;
        hosLbl.attributedText = hospitalInfo;
        [hosBgView addSubview:hosLbl];

        y=y+hospitalInfoHgt+35;
    }
    
    
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
    nextBtn.backgroundColor = Yellow_Color;
    
    if (self.showBackBtn) {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            // Update User
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"UPDATE" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];//SUBMIT
        }else{
            // OTP Verify for User Account
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        }
        
        
        self.logoutView.hidden = YES;
    }else{
        // User Account Summary
        [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"EDIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        self.logoutView.hidden = NO;
    }
    nextBtn.layer.cornerRadius = 7;
    nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [nextBtn addTarget:self action:@selector(nextBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];

    y=y+55;

    if (!self.showBackBtn) {
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
        [deleteBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"Delete Account" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        [deleteBtn setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
        [deleteBtn setContentVerticalAlignment: UIControlContentVerticalAlignmentCenter];
        [deleteBtn addTarget:self action:@selector(deleteBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setBackgroundColor:[UIColor clearColor]];
        [self.scrollView addSubview:deleteBtn];

        y=y+55;
    }

    
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth-80, y);
    self.tableView.hidden = YES;
}
#pragma mark- UITableView Method
-(void)createTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_wdth, 160)];

    UIView *infoBgView = [[UIView alloc] initWithFrame:CGRectMake(40, 10, screen_wdth-80, 140)];
    infoBgView.clipsToBounds = YES;
    infoBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    infoBgView.layer.cornerRadius = 7;
    infoBgView.layer.borderColor = Yellow_Border_Color;
    infoBgView.layer.borderWidth = 1;
    [headerView addSubview:infoBgView];

    
    float y=0;
    UILabel *infoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 40)];
    infoTitle.backgroundColor = Yellow_Color;
    infoTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"    User Profile" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
    [infoBgView addSubview:infoTitle];
    y = y + 40;
    
    
    if ([self.userDict valueForKey:@"customer_id"]) {
        UILabel *userId = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 40)];
        userId.numberOfLines = 0;
        userId.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *userIdStr = [[UtilsManager sharedObject] getMutableStringWithString:@"ID : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
        [userIdStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[self.userDict valueForKey:@"customer_id"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft]];
        userId.attributedText = userIdStr;
        [infoBgView addSubview:userId];
        y = y + 40;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 1)];
        line.backgroundColor = Yellow_Color;
        [infoBgView addSubview:line];
        y = y + 1;
    }
    
    if (self.userDict) {
        NSString *name;
        name = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:TITLE_KEY], [self.userDict valueForKey:FNAME_KEY],[self.userDict valueForKey:LNAME_KEY]];
        UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 40)];
        userName.numberOfLines = 0;
        userName.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *userNameStr = [[UtilsManager sharedObject] getMutableStringWithString:@"NAME : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
        [userNameStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:name font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft]];
        userName.attributedText = userNameStr;
        [infoBgView addSubview:userName];
        y = y + 40;
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 1)];
        line1.backgroundColor = Yellow_Color;
        [infoBgView addSubview:line1];
        y = y + 1;

        
        UILabel *mobileNum = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 40)];
        mobileNum.numberOfLines = 0;
        mobileNum.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *mobileNumStr = [[UtilsManager sharedObject] getMutableStringWithString:@"MOBILE : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
        [mobileNumStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[self.userDict valueForKey:MOBILE_KEY]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft]];
        mobileNum.attributedText = mobileNumStr;
        [infoBgView addSubview:mobileNum];
        y = y + 40;
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 1)];
        line2.backgroundColor = Yellow_Color;
        [infoBgView addSubview:line2];
        y = y + 1;

        UILabel *emailId = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 40)];
        emailId.numberOfLines = 0;
        emailId.lineBreakMode = kCTLineBreakByCharWrapping;
        emailId.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *emailIdStr = [[UtilsManager sharedObject] getMutableStringWithString:@"EMAIL ID : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
        [emailIdStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[[self.userDict valueForKey:EMAIL_KEY]lowercaseString]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft]];
        emailId.attributedText = emailIdStr;
        [infoBgView addSubview:emailId];
        y = y + 40;
        
    }

    
    infoBgView.frame = CGRectMake(40, 10, screen_wdth-80, y);
    
    y=y+20;
//    UILabel *hosTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 20)];
//    hosTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"Hospital Information" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentLeft];
//    [headerView addSubview:hosTitle];
//    y=y+20;

    
    headerView.frame = CGRectMake(0, 0, screen_wdth, y);
    self.tableView.tableHeaderView = headerView;

    self.scrollView.hidden = YES;
    
}
-(void)createTableFooterView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_wdth, 80)];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, screen_wdth-80, 40)];
    nextBtn.backgroundColor = Yellow_Color;

    if (self.showBackBtn) {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            // Update User
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"UPDATE" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];//SUBMIT
        }else{
            // OTP Verify for User Account
            [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        }
        
        
        self.logoutView.hidden = YES;
    }else{
        // User Account Summary
        [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"EDIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        self.logoutView.hidden = NO;
    }
    nextBtn.layer.cornerRadius = 7;
    nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [nextBtn addTarget:self action:@selector(nextBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextBtn];
    self.tableView.tableFooterView = headerView;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return userHosAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
        CGFloat hgt = 40;
        NSDictionary *hosInfo = [userHosAry objectAtIndex:indexPath.row];
        NSString *depName = [hosInfo valueForKey:DEPNAME_KEY];
        if (depName == nil) {
            depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[hosInfo valueForKey:@"deptAry"]];
        }
        
        NSMutableAttributedString *depNameStr = [[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        
        if (depName) {
            [depNameStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:depName font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        }
        
        CGFloat depValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:depNameStr withWidth:screen_wdth-100]+10;
        hgt = hgt + depValueHgt;
        
        NSString *addStr = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[hosInfo valueForKey:ADDRESS_KEY],[hosInfo valueForKey:CITY_KEY],[hosInfo valueForKey:STATE_KEY],[hosInfo valueForKey:ZIP_KEY],[hosInfo valueForKey:COUNTRY_KEY]];
        NSMutableAttributedString *addressStr = [[UtilsManager sharedObject] getMutableStringWithString:@"ADDRESS : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        if (addStr) {
            [addressStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:addStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        }
        
        CGFloat addValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:addressStr withWidth:screen_wdth-100]+10;
        hgt = hgt + addValueHgt;
        
        hgt+=10;
        return hgt;
    }else{
        return 50;
    }

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *hosInfo = [userHosAry objectAtIndex:indexPath.row];
    if ([hosInfo valueForKey:HOSNAME_KEY]) {
        cell.hosName.text = [NSString stringWithFormat:@"%@",[hosInfo valueForKey:HOSNAME_KEY]];
    }
    NSString *depName = [hosInfo valueForKey:DEPNAME_KEY];
    if (depName == nil) {
        depName = [[UtilsManager sharedObject] getDepartmentNameFromArray:[hosInfo valueForKey:@"deptAry"]];
    }

    NSMutableAttributedString *depNameStr = [[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];

    if (depName) {
        [depNameStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:depName font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    }
    cell.depName.attributedText = depNameStr;
    CGFloat depValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:depNameStr withWidth:screen_wdth-100]+10;
    cell.depMargin.constant = depValueHgt;

    NSString *addStr = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[hosInfo valueForKey:ADDRESS_KEY],[hosInfo valueForKey:CITY_KEY],[hosInfo valueForKey:STATE_KEY],[hosInfo valueForKey:ZIP_KEY],[hosInfo valueForKey:COUNTRY_KEY]];
    NSMutableAttributedString *addressStr = [[UtilsManager sharedObject] getMutableStringWithString:@"ADDRESS : " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    if (addStr) {
        [addressStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:addStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    }
    cell.address.attributedText = addressStr;

//    if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
        cell.hosNamBg.backgroundColor = Yellow_Color;
//        cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
//    }else{
//        cell.hosNamBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
//    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *indexpathAry = [[NSMutableArray alloc] init];
    [indexpathAry addObject:indexPath];
    
//    BOOL flag = ![[flagAry objectAtIndex: indexPath.row] boolValue];
//
//    for (int i=0; i<flagAry.count; i++) {
//        if ([[flagAry objectAtIndex: i] boolValue]) {
//            [indexpathAry addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
//    }
//
//    [flagAry replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:flag]];
//    [self.tableView reloadRowsAtIndexPaths:indexpathAry withRowAnimation:UITableViewRowAnimationFade];

}


#pragma mark- Send Data to Server
-(void)registerUsertoServer{
    NSLog(@"user Info: %@",self.userDict);
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.userDict];
    NSArray *hosAry = [self.userDict valueForKey:HOSARY_KEY];
    // convert your object to JSOn String
    NSError *error = nil;
    NSString *createJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:hosAry options:nil error:&error] encoding:NSUTF8StringEncoding];//NSJSONWritingPrettyPrinted
    
    [param setObject:createJSON forKey:HOSARY_KEY];
    [param setObject:Auth_Token forKey:Auth_Token_KEY];
    NSLog(@"param: %@",param);

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;

    
    NSString *url;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/api/v2/customer",[userData valueForKey:@"testing_url"]];
    }else{
        url = [NSString stringWithFormat:@"%@/api/v2/customer",base_url];
    }
    

    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;   
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            OTPViewController *otpVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"otpVC"];
            [self.userDict setObject:[responseDict valueForKey:@"id"] forKey:@"id"];
            otpVC.userDict = self.userDict;
            [self.navigationController pushViewController:otpVC animated:NO];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        
//        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//            NSLog(@"status code: %li", (long)httpResponse.statusCode);
//        }
        NSLog(@"success! with response: %@", responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        NSLog(@"error: %@", error.localizedDescription);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

-(void)updateUserData{
//    NSLog(@"user Info: %@",self.userDict);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:self.userDict];
    NSMutableArray *hosAry = [[self.userDict valueForKey:HOSARY_KEY] mutableCopy];
    for (int i=0; i<hosAry.count; i++) {
        NSMutableDictionary *hosInfo = [[hosAry objectAtIndex:i] mutableCopy];
        if ([hosInfo valueForKey:@"deptAry"]) {//deptAry
            [hosInfo removeObjectForKey:@"deptAry"];
        }
        [hosAry replaceObjectAtIndex:i withObject:hosInfo];
    }
    // convert your object to JSOn String
    NSError *error = nil;
    NSString *createJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:hosAry options:nil error:&error] encoding:NSUTF8StringEncoding];//NSJSONWritingPrettyPrinted
    
    [param setObject:createJSON forKey:HOSARY_KEY];
    [param setObject:Auth_Token forKey:Auth_Token_KEY];
    [param setObject:@"PUT" forKey:@"_method"];
    
    NSLog(@"param: %@",param);
    
    
    NSString *apiurl;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/%@",[userData valueForKey:@"testing_url"],[self.userDict valueForKey:@"id"]];
    }else{
        apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/%@",base_url,[self.userDict valueForKey:@"id"]];
    }
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }

    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *access_token = [userData valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

    self.loaderView.hidden = NO;
    
    
    [manager POST:apiurl parameters:param progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"success! with response: %@", responseObject);
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
//            OTPViewController *otpVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"otpVC"];
////            [self.userDict setObject:[responseDict valueForKey:@"customer_id"] forKey:@"customer_id"];
//            otpVC.userDict = [responseDict valueForKey:@"data"];
//            [self.navigationController pushViewController:otpVC animated:NO];
            
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
            [data setValue:access_token forKey:@"access_token"];
//            NSString *access_token = [userData valueForKey:@"access_token"];
            
            [[UtilsManager sharedObject] storeUserDatatoDefaultUser:data];
            //[responseDict valueForKey:@"data"]
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        NSLog(@"error: %@", error.localizedDescription);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}

@end

@implementation CustomCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 7;
    self.bgView.layer.borderColor = Yellow_Border_Color;
    self.bgView.layer.borderWidth = 1;
    self.arrowImg.hidden = YES;
}
@end

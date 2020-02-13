//
//  HospitalsViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 12/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "HospitalsViewController.h"
#import "UtilsManager.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface HospitalsViewController ()<DepartmentCellDelegate, OtherDepCellDelegate>{
    UITextField *hosName;
    UITextField *depName;
    UITextField *othrDep;
    UITextField *address;
    UITextField *city;
    UITextField *state;
    UITextField *zip;
    UITextField *country;
    UITextField *othrCountry;
    UIButton *addBtn;
    NSString *dept_id ;
    
    UILabel *hosTitle;
    UILabel *depTitle;
    UILabel *addressTitle;
    UILabel *cityTitle;
    UILabel *stateTitle;
    UILabel *zipTitle;
    UILabel *countryTitle;
    
    float depY;
    float countryY;
    NSMutableArray *optionAry, *hospitalsAry;
    NSMutableArray *depAry, *selectDepAry, *depFlagAry;
    NSString *option;
    
    BOOL isMsgDisplyed;
}

@end

@implementation HospitalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isMsgDisplyed = NO;
    self.loaderView.hidden = YES;
    depY = 0;
    optionAry = [[NSMutableArray alloc] init];
    hospitalsAry = [[NSMutableArray alloc] init];
    depAry = [[NSMutableArray alloc] init];
    selectDepAry = [[NSMutableArray alloc] init];
    
    self.pickerBgView.hidden = YES;
    self.depBgView.hidden = YES;
    
    if (self.hosInfo == nil) {
        self.hosInfo = [[NSMutableDictionary alloc] init];
    }
    [self fetchDepartmentsFromServer];

    [self createScrollViewSubViews];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    [self createHeaderView];
    [self createFooterView];
    
    self.msgView.layer.cornerRadius = 7;
    
    if (self.hosInfo.allKeys.count == 0) {
        _titleLbl.text = @"Add Hospital";
    }else{
        _titleLbl.text = @"Edit Hospital";
    }

    
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

-(void)setHospitalDataInField{
    
    if (self.hosInfo.allKeys.count == 0) {
        return;
    }
    
    NSArray *deptAry = [self.hosInfo valueForKey:@"deptAry"];
    for (int i=0; i<deptAry.count; i++) {
        [selectDepAry addObject:[deptAry objectAtIndex:i]];
    }
    NSString *dep;
    dept_id = nil;
    
    for (int i=0; i<selectDepAry.count; i++) {
        if (dep == nil) {
            dep = [[selectDepAry objectAtIndex: i] valueForKey:@"name"];
            dept_id = [[selectDepAry objectAtIndex: i] valueForKey:@"dept_id"];
        }else{
            dep = [NSString stringWithFormat:@"%@, %@",dep,[[selectDepAry objectAtIndex: i] valueForKey:@"name"]];
            dept_id = [NSString stringWithFormat:@"%@, %@",dept_id,[[selectDepAry objectAtIndex: i] valueForKey:@"dept_id"]];
            
        }
    }
    if (dep != nil) {
        depName.text=dep;
    }
    
    hosName.text = [self.hosInfo valueForKey:@"hospital_name"];
    address.text = [self.hosInfo valueForKey:@"address"];
    city.text = [self.hosInfo valueForKey:@"city"];
    state.text = [self.hosInfo valueForKey:@"state"];
    zip.text = [self.hosInfo valueForKey:@"zip"];
    country.text = [self.hosInfo valueForKey:@"country"];
}
#pragma mark-  Header Footer Method
-(void)fetchDepartmentsFromServer{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    self.loaderView.hidden = NO;
    
    NSString *apiurl;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        apiurl = [NSString stringWithFormat:@"%@/api/v1/departments?auth_token=%@",[userData valueForKey:@"testing_url"],Auth_Token];
    }else{
        apiurl = [NSString stringWithFormat:@"%@/api/v1/departments?auth_token=%@",base_url,Auth_Token];
    }

    [manager GET:apiurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//        NSLog(@"status code: %li", (long)httpResponse.statusCode);
        self.loaderView.hidden = YES;

        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSLog(@"status code: %li", (long)httpResponse.statusCode);
        }

        NSLog(@"success! with response: %@", responseObject);
        
        depAry = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
        
        [self setHospitalDataInField];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        NSLog(@"error: %@", error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];

}
#pragma mark-  Header Footer Method

-(void)createHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screen_wdth, 60)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0,screen_wdth-60, 60)];
    title.font = [UIFont fontWithName:@"EncodeSansNormal-ExtraBold" size:20];
    title.textColor = [UIColor whiteColor];
    title.text = @"DEPARTMENTS:";
    title.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:title];
    
    self.tableView.tableHeaderView = headerView;
}

-(void)createFooterView{
    self.depDoneBtn.layer.cornerRadius = 7;
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screen_wdth, 150)];
//    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-100)/2, 55,100, 40)];
//    done.layer.cornerRadius = 7;
//    done.titleLabel.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13];
//    [done setTitle:@"DONE" forState:UIControlStateNormal];
//    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    done.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
//    [done addTarget:self action:@selector(footerDoneBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:done];
//    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(IBAction)footerDoneBtnTapped:(id)sender{
//    NSMutableArray *selectedAry = [[NSMutableArray alloc] init];
    [self hideKeyboard];
    
    
    
    
    
    for (int i=0; i<selectDepAry.count; i++) {
        NSDictionary *selectDepInfo = [selectDepAry objectAtIndex:i];
        if ([[selectDepInfo objectForKey:@"name"] isEqualToString:@"Others"]) {
            OtherDepCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:depAry.count inSection:0 ]];
            NSLog(@"cell.depTextField.text: %@",cell.depTextField.text);
            if (cell.depTextField.text.length == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Please enter other department name." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            NSMutableDictionary *otherDict = [NSMutableDictionary dictionaryWithDictionary:selectDepInfo];
            [otherDict setObject:cell.depTextField.text forKey:@"name"];

            [selectDepAry replaceObjectAtIndex:i withObject:otherDict];
            
        }
    }
    
    NSString *dep;
    dept_id = nil;

    for (int i=0; i<selectDepAry.count; i++) {
        if (dep == nil) {
            dep = [[selectDepAry objectAtIndex: i] valueForKey:@"name"];
            dept_id = [[selectDepAry objectAtIndex: i] valueForKey:@"dept_id"];
        }else{
            dep = [NSString stringWithFormat:@"%@, %@",dep,[[selectDepAry objectAtIndex: i] valueForKey:@"name"]];
            dept_id = [NSString stringWithFormat:@"%@, %@",dept_id,[[selectDepAry objectAtIndex: i] valueForKey:@"dept_id"]];
            
        }
    }
    if (dep != nil) {
        depName.text=dep;
    }
    self.depBgView.hidden = YES;
}
- (IBAction)crossButtonTapped:(id)sender {
    self.depBgView.hidden = YES;
    [selectDepAry removeAllObjects];
}

- (IBAction)msgViewOkButtonTapped:(id)sender {
    [UIView transitionWithView:self.msgView duration:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.msgTopMargin.constant = -65;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}
#pragma mark-  Keyboard Method
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
            self.scrollBotmMargin.constant = keyboardSize.height-50;
//            self.tableViewBottomMargin.constant = keyboardSize.height-50;
        } else {
            self.scrollBotmMargin.constant = keyboardSize.height;
        }
        self.tableViewBottomMargin.constant = keyboardSize.height;

        //        self.scrollBotmMargin.constant = keyboardSize.height;//-50;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.scrollBotmMargin.constant = 0;
        self.tableViewBottomMargin.constant = 100;
    }];
}

#pragma mark-  UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ( textField == state || textField == depName || textField == country ) {
        [optionAry removeAllObjects];
        if (textField == state) {
            option=STATE_KEY;
            [optionAry addObject:@"Andaman and Nicobar Islands"];
            [optionAry addObject:@"Andhra Pradesh"];
            [optionAry addObject:@"Arunachal Pradesh"];
            [optionAry addObject:@"Assam"];
            [optionAry addObject:@"Bihar"];
            [optionAry addObject:@"Chandigarh"];
            [optionAry addObject:@"Chhattisgarh"];
            [optionAry addObject:@"Dadra and Nagar Haveli"];
            [optionAry addObject:@"Daman and Diu"];
            [optionAry addObject:@"Delhi"];
            [optionAry addObject:@"Goa"];
            [optionAry addObject:@"Gujarat"];
            [optionAry addObject:@"Haryana"];
            [optionAry addObject:@"Himachal Pradesh"];
            [optionAry addObject:@"Jammu and Kashmir"];
            [optionAry addObject:@"Jharkhand"];
            [optionAry addObject:@"Karnataka"];
            [optionAry addObject:@"Kerala"];
            [optionAry addObject:@"Lakshadweep"];
            [optionAry addObject:@"Madhya Pradesh"];
            [optionAry addObject:@"Maharashtra"];
            [optionAry addObject:@"Manipur"];
            [optionAry addObject:@"Meghalaya"];
            [optionAry addObject:@"Mizoram"];
            [optionAry addObject:@"Nagaland"];
            [optionAry addObject:@"Odisha"];
            [optionAry addObject:@"Puducherry"];
            [optionAry addObject:@"Punjab"];
            [optionAry addObject:@"Rajasthan"];
            [optionAry addObject:@"Sikkim"];
            [optionAry addObject:@"Tamil Nadu"];
            [optionAry addObject:@"Telangana"];
            [optionAry addObject:@"Tripura"];
            [optionAry addObject:@"Uttarakhand"];
            [optionAry addObject:@"Uttar Pradesh"];
            [optionAry addObject:@"West Bengal"];
            
            
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            [self hideKeyboard];
            self.pickerBgView.hidden = NO;
            return NO;
        }else if (textField == depName) {
//            option=@"depName";
//            [optionAry addObject:@"Gastroenterology"];
//            [optionAry addObject:@"Respiratory"];
//            [optionAry addObject:@"Urology"];
//            [optionAry addObject:@"Gynaecology"];
//            [optionAry addObject:@"General Surgery"];
//            [optionAry addObject:@"ENT"];
//            [optionAry addObject:@"Others"];
            
            [self hideKeyboard];
            self.depBgView.hidden = NO;
            return NO;
        }else {
            option=COUNTRY_KEY;
            [optionAry addObject:@"India"];
//            [optionAry addObject:@"Others"];
            
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            [self hideKeyboard];
            self.pickerBgView.hidden = NO;
            return NO;
        }
    }else{
        self.pickerBgView.hidden = YES;
        return YES;
    }
}

#pragma mark-  Other Method

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)hideKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}




-(void)addtButtonTpped{
//    UITextField *hosName;
//    UITextField *depName;
//    UITextField *othrDep;
//    UITextField *address;
//    UITextField *city;
//    UITextField *state;
//    UITextField *zip;
//    UITextField *country;
//    UITextField *othrCountry;

    NSMutableDictionary *hospitalDict = [[NSMutableDictionary alloc] init];
    
    if (hosName.text.length == 0) {
        [self showAlertWithMessage:@"Please enter hospital name."];
        return;
    }else{
        [hospitalDict setObject:hosName.text forKey:HOSNAME_KEY];
        [self.hosInfo setObject:hosName.text forKey:HOSNAME_KEY];

    }
    
    if (depName.text.length == 0) {
        [self showAlertWithMessage:@"Please enter departname name."];
        return;
    }else if ([depName.text isEqualToString:@"Others"]){
        if (othrDep.text.length == 0) {
            [self showAlertWithMessage:@"Please enter other department name."];
            return;
        }else{
            [hospitalDict setObject:othrDep.text forKey:DEPNAME_KEY];
            [hospitalDict setObject:dept_id forKey:DEP_ID_KEY];
            [self.hosInfo setObject:othrDep.text forKey:DEPNAME_KEY];
            [self.hosInfo setObject:dept_id forKey:DEP_ID_KEY];
        }
    }else{
        [hospitalDict setObject:depName.text forKey:DEPNAME_KEY];
        [hospitalDict setObject:dept_id forKey:DEP_ID_KEY];
        [self.hosInfo setObject:depName.text forKey:DEPNAME_KEY];
        [self.hosInfo setObject:dept_id forKey:DEP_ID_KEY];
    }
    
    
    if (address.text.length == 0) {
        [self showAlertWithMessage:@"Please enter hospital address."];
        return;
    }else{
        [hospitalDict setObject:address.text forKey:ADDRESS_KEY];
        [self.hosInfo setObject:address.text forKey:ADDRESS_KEY];
    }
    
    if (city.text.length == 0) {
        [self showAlertWithMessage:@"Please enter city."];
        return;
    }else{
        [hospitalDict setObject:city.text forKey:CITY_KEY];
        [self.hosInfo setObject:city.text forKey:CITY_KEY];
    }

    if (state.text.length == 0) {
        [self showAlertWithMessage:@"Please select state."];
        return;
    }else{
        [hospitalDict setObject:state.text forKey:STATE_KEY];
        [self.hosInfo setObject:state.text forKey:STATE_KEY];
    }
    
    if (zip.text.length == 0) {
        [self showAlertWithMessage:@"Please enter zip code."];
        return;
    }else{
        [hospitalDict setObject:zip.text forKey:ZIP_KEY];
        [self.hosInfo setObject:zip.text forKey:ZIP_KEY];
    }

    
    if (country.text.length == 0) {
        [self showAlertWithMessage:@"Please select country name."];
        return;
    }else if ([country.text isEqualToString:@"Others"]){
        if (othrCountry.text.length == 0) {
            [self showAlertWithMessage:@"Please select other country name."];
            return;
        }else{
            [hospitalDict setObject:othrCountry.text forKey:COUNTRY_KEY];
            [self.hosInfo setObject:othrCountry.text forKey:COUNTRY_KEY];
        }
    }else{
        [hospitalDict setObject:country.text forKey:COUNTRY_KEY];
        [self.hosInfo setObject:country.text forKey:COUNTRY_KEY];
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.delegate) {
            [self.delegate dismissHospitalVCWithInfo:self.hosInfo];
        }
    }];
    
//    [hospitalsAry addObject:hospitalDict];
    
//    NSLog(@"%@",hosName.text);
//    NSLog(@"%@",depName.text);
//    NSLog(@"%@",address.text);
//    NSLog(@"%@",city.text);
//    NSLog(@"%@",state.text);
//    NSLog(@"%@",zip.text);
//    NSLog(@"%@",country.text);


}
-(void)showAlertWithMessage:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark-  UIPickerView  Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return optionAry.count;
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED{
    return [[UtilsManager sharedObject] getMutableStringWithString:[optionAry objectAtIndex:row] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
}

- (IBAction)doneBtnTapped:(id)sender {
    [self hideKeyboard];
    self.pickerBgView.hidden = !self.pickerBgView.hidden;
    NSInteger index = [_pickerView selectedRowInComponent:0];
    if ([option isEqualToString:STATE_KEY]) {
        state.text=[optionAry objectAtIndex:index];
    }else if ([option isEqualToString:DEPNAME_KEY]) {
        depName.text=[optionAry objectAtIndex:index];
        [self createRestViewWithOtherDepartment];
    }else {
        country.text=[optionAry objectAtIndex:index];
        [self createRestView];
    }

}
#pragma mark-  ScrollView SubViews Method
-(void)createScrollViewSubViews{
    float y=20;
    
    hosTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    hosTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    hosTitle.textAlignment = NSTextAlignmentLeft;
    hosTitle.text = @"Hospital Name";
    hosTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:hosTitle];
    y=y+20;
    
    hosName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    hosName.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Hospital Name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    hosName.font = TextField_Font;
    hosName.delegate = self;
    hosName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    hosName.contentMode = UIViewContentModeScaleAspectFill;
    hosName.textColor = [UIColor whiteColor];
    hosName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    hosName.leftViewMode = UITextFieldViewModeAlways;
    hosName.layer.borderColor = Yellow_Border_Color;
    hosName.layer.borderWidth = 1;
    hosName.layer.cornerRadius = 7;
    [hosName setClipsToBounds:YES];
    [self.scrollView addSubview:hosName];
    y=y+55;
    
    depTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    depTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    depTitle.textAlignment = NSTextAlignmentLeft;
    depTitle.text = @"Department";
    depTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:depTitle];
    y=y+20;
    
    depName = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    depName.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Department" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    depName.font = TextField_Font;
    depName.delegate = self;
    depName.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    depName.contentMode = UIViewContentModeScaleAspectFill;
    depName.textColor = [UIColor whiteColor];
    depName.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    depName.leftViewMode = UITextFieldViewModeAlways;
    depName.layer.borderColor = Yellow_Border_Color;
    depName.layer.borderWidth = 1;
    depName.layer.cornerRadius = 7;
    [depName setClipsToBounds:YES];
    [self.scrollView addSubview:depName];
    y=y+55;
    depY = y;
    
    
    addressTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    addressTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    addressTitle.textAlignment = NSTextAlignmentLeft;
    addressTitle.text = @"Address";
    addressTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:addressTitle];
    y=y+20;
    
    address = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    address.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:ADDRESS_KEY font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    address.font = TextField_Font;
    address.delegate = self;
    address.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    address.contentMode = UIViewContentModeScaleAspectFill;
    address.textColor = [UIColor whiteColor];
    address.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    address.leftViewMode = UITextFieldViewModeAlways;
    address.layer.borderColor = Yellow_Border_Color;
    address.layer.borderWidth = 1;
    address.layer.cornerRadius = 7;
    [address setClipsToBounds:YES];
    [self.scrollView addSubview:address];
    y=y+55;
    
    
    
    cityTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    cityTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    cityTitle.textAlignment = NSTextAlignmentLeft;
    cityTitle.text = @"City";
    cityTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:cityTitle];
    y=y+20;
    
    city = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    city.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"City" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    city.font = TextField_Font;
    city.delegate = self;
    city.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    city.contentMode = UIViewContentModeScaleAspectFill;
    city.textColor = [UIColor whiteColor];
    city.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    city.leftViewMode = UITextFieldViewModeAlways;
    city.layer.borderColor = Yellow_Border_Color;
    city.layer.borderWidth = 1;
    city.layer.cornerRadius = 7;
    [city setClipsToBounds:YES];
    [self.scrollView addSubview:city];
    y=y+55;
    
    
    stateTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    stateTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    stateTitle.textAlignment = NSTextAlignmentLeft;
    stateTitle.text = @"State";
    stateTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:stateTitle];
    y=y+20;
    
    state = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    state.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Please select state" font:TextField_Font spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    state.font = TextField_Font;
    state.delegate = self;
    state.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    state.contentMode = UIViewContentModeScaleAspectFill;
    state.textColor = [UIColor whiteColor];
    state.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    state.leftViewMode = UITextFieldViewModeAlways;
    state.layer.borderColor = Yellow_Border_Color;
    state.layer.borderWidth = 1;
    state.layer.cornerRadius = 7;
    [state setClipsToBounds:YES];
    [self.scrollView addSubview:state];
    y=y+55;
    
    
    
    zipTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    zipTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    zipTitle.textAlignment = NSTextAlignmentLeft;
    zipTitle.text = @"Zip";
    zipTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:zipTitle];
    y=y+20;
    
    zip = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    zip.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Zip" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    zip.font = TextField_Font;
    zip.keyboardType = UIKeyboardTypeNumberPad;
    zip.delegate = self;
    zip.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    zip.contentMode = UIViewContentModeScaleAspectFill;
    zip.textColor = [UIColor whiteColor];
    zip.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    zip.leftViewMode = UITextFieldViewModeAlways;
    zip.layer.borderColor = Yellow_Border_Color;
    zip.layer.borderWidth = 1;
    zip.layer.cornerRadius = 7;
    [zip setClipsToBounds:YES];
    [self.scrollView addSubview:zip];
    y=y+55;
    
    
    
    countryTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 15)];
    countryTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0];
    countryTitle.textAlignment = NSTextAlignmentLeft;
    countryTitle.text = @"Country";
    countryTitle.textColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.scrollView addSubview:countryTitle];
    y=y+20;
    
    
    country = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    //    country.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Country" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    country.font = TextField_Font;
    country.delegate = self;
    country.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
    country.contentMode = UIViewContentModeScaleAspectFill;
    country.textColor = [UIColor whiteColor];
    country.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    country.leftViewMode = UITextFieldViewModeAlways;
    country.layer.borderColor = Yellow_Border_Color;
    country.layer.borderWidth = 1;
    country.layer.cornerRadius = 7;
    [country setClipsToBounds:YES];
    
    [self.scrollView addSubview:country];
    y=y+65;
    countryY = y;
    
    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
    addBtn.backgroundColor = Yellow_Color;
    [addBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:TextField_Font spacing:0.5 textColor:Dark_Yellow_Color lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 7;
    addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [addBtn addTarget:self action:@selector(addtButtonTpped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addBtn];
    y=y+55;
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}


-(void )createRestViewWithOtherDepartment{
    float y = depY;
    [othrDep removeFromSuperview];
    if ([depName.text isEqualToString:@"Others"]) {
        othrDep = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
        othrDep.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Other department name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        othrDep.font = TextField_Font;
        othrDep.delegate = self;
        othrDep.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
        othrDep.contentMode = UIViewContentModeScaleAspectFill;
        othrDep.textColor = [UIColor whiteColor];
        othrDep.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        othrDep.leftViewMode = UITextFieldViewModeAlways;
        othrDep.layer.borderColor = Yellow_Border_Color;
        othrDep.layer.borderWidth = 1;
        othrDep.layer.cornerRadius = 7;
        [othrDep setClipsToBounds:YES];
        [self.scrollView addSubview:othrDep];
        y=y+55;
    }
    
    addressTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
    y=y+20;
    address.frame = CGRectMake(40, y, screen_wdth-80, 40);
    y=y+55;
    cityTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
    y=y+20;
   city.frame = CGRectMake(40, y, screen_wdth-80, 40);
    y=y+55;
    stateTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
    y=y+20;
    state.frame = CGRectMake(40, y, screen_wdth-80, 40);
    y=y+55;
    zipTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
    y=y+20;
    zip.frame = CGRectMake(40, y, screen_wdth-80, 40);
    y=y+55;
    countryTitle.frame = CGRectMake(40, y, screen_wdth-80, 15);
    y=y+20;
    country.frame = CGRectMake(40, y, screen_wdth-80, 40);

    if (othrCountry != nil) {
        y=y+55;
        othrCountry.frame = CGRectMake(40, y, screen_wdth-80, 40);
        y=y+65;
    }else{
        y=y+65;
    }
    addBtn.frame = CGRectMake(90, y, screen_wdth-180, 40);
    y=y+55;

    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);

}
-(void )createRestView{
    float y = countryY;
    if (othrDep != nil) {
        y=y+55;
    }
    [othrCountry removeFromSuperview];
    if ([country.text isEqualToString:@"Others"]) {
        othrCountry = [[UITextField alloc] initWithFrame:CGRectMake(40, y, screen_wdth-80, 40)];
        othrCountry.attributedPlaceholder = [[UtilsManager sharedObject] getMutableStringWithString:@"Other country name" font:TextField_Font spacing:0 textColor:[UIColor lightGrayColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        othrCountry.font = TextField_Font;
        othrCountry.delegate = self;
        othrCountry.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];//.background = [UIImage imageNamed:@"unselected_no_border.png"];
        othrCountry.contentMode = UIViewContentModeScaleAspectFill;
        othrCountry.textColor = [UIColor whiteColor];
        othrCountry.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        othrCountry.leftViewMode = UITextFieldViewModeAlways;
        othrCountry.layer.borderColor = Yellow_Border_Color;
        othrCountry.layer.borderWidth = 1;
        othrCountry.layer.cornerRadius = 7;
        [othrCountry setClipsToBounds:YES];
        [self.scrollView addSubview:othrCountry];
        y=y+55;
    }
    
    
    
    addBtn.frame = CGRectMake(90, y, screen_wdth-180, 40);
    y=y+55;
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
    
}


#pragma mark-  UITableView Method


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([selectDepAry containsObject:[depAry lastObject]]) {
        return depAry.count+1;
    }else{
        return depAry.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == depAry.count) {
        OtherDepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherDepCell"];
        if (cell == nil) {
            cell = [[OtherDepCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherDepCell"];
        }
        [cell.depTextField becomeFirstResponder];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        DepartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"depCell"];
        if (cell == nil) {
            cell = [[DepartmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"depCell"];
        }
        
        if ([selectDepAry containsObject:[depAry objectAtIndex:indexPath.row]]) {
            cell.checkboxImg.image = [UIImage imageNamed:@"checkbox.png"];
        }else{
            cell.checkboxImg.image = [UIImage imageNamed:@"uncheckbox.png"];
        }
        NSDictionary *depInfo = [depAry objectAtIndex:indexPath.row];
        cell.depName.text = [depInfo objectForKey:@"name"];
        cell.delegate = self;
        cell.index= indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
-(void)checkboxTappedWithCell:(DepartmentCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    if ([selectDepAry containsObject:[depAry objectAtIndex:index]]) {
        [selectDepAry removeObject:[depAry objectAtIndex:index]];
    }else{
        [selectDepAry addObject:[depAry objectAtIndex:index]];
    }
    [self.tableView reloadData];
}

-(void)displayMsgView:(DepartmentCell *)cell {
    NSLog(@"displayMsgView");
//    [self performSelector:@selector(showHintMsg) withObject:nil afterDelay:1];

}
-(void)showHintMsg{
    if (!isMsgDisplyed) {
        isMsgDisplyed = YES;
        [UIView transitionWithView:self.msgView duration:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
            self.msgTopMargin.constant = 5;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self performSelector:@selector(msgViewOkButtonTapped:) withObject:nil afterDelay:5];
        }];
    }
}


@end


@implementation DepartmentCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)checkBoxTapped:(id)sender {
    if (self.delegate) {
        [self.delegate checkboxTappedWithCell:self andIndex:self.index];
    }
}
@end


@implementation OtherDepCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.depTextField.layer.cornerRadius = 7;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    self.depTextField.clipsToBounds = YES;
    self.depTextField.leftView = leftView;
    self.depTextField.leftViewMode = UITextFieldViewModeAlways;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    tableViewBottomMargin
    if (self.delegate) {
        [self.delegate displayMsgView:self];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}
@end




//
//  ForgetPassViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "OTPViewController.h"

@interface ForgetPassViewController (){
    UITextField *mobile;
}

@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPwdExpired == TRUE){
        self.vcTitle.text = @"RESET YOUR PASSWORD";
    }else{
        self.vcTitle.text = @"FORGOT YOUR PASSWORD?";
    }
    self.loaderView.hidden = YES;
    [self createScrollViewSubView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)createScrollViewSubView{
    float y =100;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 100)];
    lbl.numberOfLines = 0;
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:16.0];
    lbl.text = @"Please enter your registered mobile number.";
    [self.scrollView addSubview:lbl];
    y=y+100;

    mobile = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 50)];
    
    UILabel *mobileLeftlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
    mobileLeftlbl.textAlignment = NSTextAlignmentCenter;
    mobileLeftlbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    mobileLeftlbl.text = @"+91";
    mobileLeftlbl.textColor = [UIColor whiteColor];
    mobile.leftView = mobileLeftlbl;
    mobile.leftViewMode = UITextFieldViewModeAlways;

    
    mobile.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:16.0];
    mobile.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    mobile.textColor = [UIColor whiteColor];
    mobile.keyboardType = UIKeyboardTypePhonePad;
//    mobile.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
//    mobile.leftViewMode = UITextFieldViewModeAlways;
    mobile.text = @"";
    mobile.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
    mobile.layer.borderWidth = 1;
    mobile.layer.cornerRadius = 7;
    [self.scrollView addSubview:mobile];
    y=y+150;

    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, y, screen_wdth-180, 40)];
    submitBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [submitBtn setAttributedTitle:[[UtilsManager sharedObject]getMutableStringWithString:@"SUBMIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    
    submitBtn.layer.cornerRadius = 7;
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [submitBtn addTarget:self action:@selector(submitButtonTpped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];

    y=y+50;

    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}
-(void)submitButtonTpped{
    if (mobile.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Mobile cannot be blank." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (mobile.text.length == 10) {
        [self hideKeyboard];
        NSString *mobNum = [NSString stringWithFormat:@"+91%@",mobile.text];

        if ([[UtilsManager sharedObject] isValidPhone:mobNum]) {

            UIStoryboard *mainStoryboard;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            }else{
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            }
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//            [param setObject:Auth_Token forKey:Auth_Token_KEY];
            [param setObject:mobNum forKey:@"mobile_number"];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
            [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.loaderView.hidden = NO;
            
            NSString *url;
            NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
            if ([[userData valueForKey:@"is_testing"] boolValue]) {
                url = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_send_otp",[userData valueForKey:@"testing_url"]];
            }else{
                url = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_send_otp",base_url];
            }

            
            [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.loaderView.hidden = YES;
                NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
                if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                    OTPViewController *otpVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"otpVC"];
                    otpVC.mobile = mobNum;
                    otpVC.fromForgetPass = YES;
                    otpVC.fromLogin = NO;
                    [self.navigationController pushViewController:otpVC animated:NO];

                }else if ([[responseDict valueForKey:@"status_code"] intValue] == 403) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You have entered an incorrect number. Please enter your registered mobile number." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
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
            
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Invalid mobile number." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Invalid mobile number." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark-  Keyboard Method

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
            self.scrollViewBotmMargin.constant = keyboardSize.height-50;
        } else {
            self.scrollViewBotmMargin.constant = keyboardSize.height;
        }
        
        //        self.scrollBotmMargin.constant = keyboardSize.height;//-50;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.scrollViewBotmMargin.constant = 0;
    }];
}


@end

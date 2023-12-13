//
//  OTPViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "OTPViewController.h"
#import "RegistrationFinalViewController.h"
#import "UtilsManager.h"
#import "ViewController.h"
#import "ConfirmPwdViewController.h"
#import <objc/runtime.h>

@interface OTPViewController ()
- (IBAction)backButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *otpMsg;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerButtonTapped:(id)sender;

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaderView.hidden = YES;
    self.resendOTPBtn.hidden = YES;
    self.registerBtn.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:15.0];

    NSString *trimmedString=[[self.userDict valueForKey:MOBILE_KEY] substringFromIndex:MAX((int)[[self.userDict valueForKey:MOBILE_KEY] length]-3, 0)]; //in case string is less than 4 characters long.
    NSLog(@"trimmedString: %@",trimmedString);
    
    self.otpMsg.text = [NSString stringWithFormat:@"A One Time Password has been sent to your registered mobile (and email) *******%@. Please enter OTP here.",trimmedString];
    
    self.otpTextField.layer.cornerRadius = 7;
    self.otpTextField.layer.borderColor = Yellow_Border_Color;//[[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
    self.otpTextField.layer.borderWidth = 1;
    [self.otpTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.registerBtn.layer.cornerRadius = 7;
    self.registerBtn.backgroundColor = Yellow_Color;
    [self performSelector:@selector(showResendOtpBtn) withObject:nil afterDelay:120];
    if (self.fromForgetPass) {
//        [self performSelector:@selector(showResendOtpBtn) withObject:nil afterDelay:120];
         NSString *mobileStr=[_mobile substringFromIndex:MAX((int)[_mobile length]-3, 0)];
        self.otpMsg.text = [NSString stringWithFormat:@"A One Time Password has been sent to your registered mobile (and email) *******%@. Please enter OTP here.",mobileStr];
        [self.registerBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    }else if (self.fromLogin) {
//        [self performSelector:@selector(showResendOtpBtn) withObject:nil afterDelay:120];
        [self.registerBtn setTitle:@"VERIFY YOUR ACCOUNT" forState:UIControlStateNormal];
    }
    
    self.otpTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    self.otpTextField.leftViewMode = UITextFieldViewModeAlways;

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    
    Ivar ivar =  class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.otpTextField, ivar);
    placeholderLabel.textColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0];

    

}

#pragma mark-  Resend OTP Method

-(void)showResendOtpBtn{
    self.resendOTPBtn.hidden = NO;
}

- (IBAction)resendOTPButtonTapped:(id)sender {
    self.otpTextField.text = @"";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:Auth_Token forKey:Auth_Token_KEY];
    if (self.fromForgetPass == YES){
        [param setObject:_mobile forKey:@"mobile_number"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
        [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.loaderView.hidden = NO;
        
        
        NSString *apiurl;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
//        if ([[userData valueForKey:@"is_testing"] boolValue]) {
//            apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/send_otp",[userData valueForKey:@"testing_url"]];
//        }else{
//            apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/send_otp",base_url];
//        }

        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_send_otp",[userData valueForKey:@"testing_url"]];
        }else{
            apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_send_otp",base_url];
        }

        [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.loaderView.hidden = YES;
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSLog(@"success! with response: %@", responseDict);
            self.resendOTPBtn.hidden = YES;
            [self performSelector:@selector(showResendOtpBtn) withObject:nil afterDelay:120];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.loaderView.hidden = YES;
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }else{
        if ([self.userDict valueForKey:@"country_code"] == nil){
            [param setObject:@"+91" forKey:@"country_code"];
        }
        [param setObject:[self.userDict valueForKey:@"mobile_number"] forKey:@"mobile_number"];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
        [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.loaderView.hidden = NO;
        
        
        NSString *apiurl;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/temp-resend-pwd-otp",[userData valueForKey:@"testing_url"]];
        }else{
            apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/temp-resend-pwd-otp",base_url];
        }

        [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.loaderView.hidden = YES;
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSLog(@"success! with response: %@", responseDict);
            self.resendOTPBtn.hidden = YES;
            [self performSelector:@selector(showResendOtpBtn) withObject:nil afterDelay:120];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.loaderView.hidden = YES;
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
    

}
#pragma mark-  UITextField Delegate Method
-(void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"textField %@ ",textField.text);
    NSLog(@"textField COunt %ld ",textField.text.length);
    if (textField.text.length >= 6){
        NSLog(@"Hide Keyboard");
        [self hideKeyboard];
    }

}

#pragma mark-  Keyboard Method

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.fromForgetPass) {
//        _backImg.hidden = YES;
//        _backbtn.hidden = YES;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
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
    
    if (self.fromForgetPass) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
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
//        if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
//            self.bottomMargin.constant = keyboardSize.height-50;
//        } else {
//            self.bottomMargin.constant = keyboardSize.height;
//        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.bottomMargin.constant = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-  Action Method


- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)registerButtonTapped:(id)sender {
    if (self.otpTextField.text.length>0) {
        [self hideKeyboard];
        if (self.fromForgetPass) {
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:Auth_Token forKey:Auth_Token_KEY];
            [param setObject:self.otpTextField.text forKey:@"otp_code"];
            [param setObject:self.mobile forKey:@"mobile_number"];
//            [param setObject:self.countryCode forKey:@"country_code"];
            [param setObject:@"password" forKey:@"type"];

            self.loaderView.hidden = NO;
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
            [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSString *apiurl;
            NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
//            if ([[userData valueForKey:@"is_testing"] boolValue]) {
//                apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/password_opt_verify",[userData valueForKey:@"testing_url"]];
//            }else{
//                apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/password_opt_verify",base_url];
//            }
            if ([[userData valueForKey:@"is_testing"] boolValue]) {
                apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_otp_verify",[userData valueForKey:@"testing_url"]];
            }else{
                apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_otp_verify",base_url];
            }

            
            [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.loaderView.hidden = YES;
                
                NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
                if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                    
                    UIStoryboard *mainStoryboard;
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
                    }else{
                        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    }

                    ConfirmPwdViewController *confirmPwdVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"confirmPwdVC"];
                    confirmPwdVC.mobile = self.mobile;
                    confirmPwdVC.password_access_token = [responseDict valueForKey:@"password_access_token"];
                    [self.navigationController pushViewController:confirmPwdVC animated:NO];

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
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:Auth_Token forKey:Auth_Token_KEY];
            [param setObject:self.otpTextField.text forKey:@"otp_code"];
            [param setObject:[self.userDict valueForKey:@"id"] forKey:@"user_id"];
            [param setObject:[self.userDict valueForKey:@"id"] forKey:@"temp_customer_id"];
            [param setObject:@"account" forKey:@"type"];
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self.userDict valueForKey:@"hospitalAry"] options:NSJSONWritingFragmentsAllowed error:&writeError];//NSJSONWritingPrettyPrinted
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            [param setObject:jsonString forKey:@"hospitalAry"];
//            [param setObject:[self.userDict valueForKey:@"mobile_number"] forKey:@"mobile_number"];
//            [param setObject:[self.userDict valueForKey:@"country_code"] forKey:@"country_code"];

            self.loaderView.hidden = NO;
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
            [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSString *apiurl;
            NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
//            if ([[userData valueForKey:@"is_testing"] boolValue]) {
//                apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/otp_verify",[userData valueForKey:@"testing_url"]];
//            }else{
//                apiurl = [NSString stringWithFormat:@"%@/api/v1/customer/otp_verify",base_url];
//            }
            if ([[userData valueForKey:@"is_testing"] boolValue]) {
                apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_otp_verify",[userData valueForKey:@"testing_url"]];
            }else{
                apiurl = [NSString stringWithFormat:@"%@/api/v2/customer/forgetpwd_otp_verify",base_url];
            }

            [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.loaderView.hidden = YES;
                
                NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
                if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                    
                    UIStoryboard *mainStoryboard;
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
                    }else{
                        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    }
                    
                    //                [[NSUserDefaults standardUserDefaults] setObject:self.userDict forKey:@"userInfo"];
                    //                [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if (self.fromLogin) {
                        // STORE USER'S DATA
                        [[UtilsManager sharedObject]storeUserDatatoDefaultUser:self.userDict];
                        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:YES] forKey:@"isLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        //                    registrationFinalVC.msg = @"YOUR ACCOUNT HAS SUCCESSFULLY VERIFIED.";
                        //                    registrationFinalVC.btnMsg = @"GO TO HOME PAGE";
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.tabBarController.selectedIndex = 0;
                            UINavigationController *vc = [self.tabBarController.viewControllers firstObject];
                            [vc popToRootViewControllerAnimated:NO];
                            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                        }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    }else{
                        RegistrationFinalViewController *registrationFinalVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"registrationFinalVC"];
                        
                        
                        
                        
                        
                        NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
                        [[UtilsManager sharedObject]storeUserDatatoDefaultUser:userInfo];
                        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:YES] forKey:@"isLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                        
                        
                        
                        
                        
                        
                        
                        
                        
                        NSString *username = @"";
                        username = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:@"title"],[self.userDict valueForKey:@"first_name"],[self.userDict valueForKey:@"last_name"]];

                        //                        if([[self.userDict valueForKey:@"middle_name"] isKindOfClass:[NSNull class]]){
//                            username = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:@"title"],[self.userDict valueForKey:@"first_name"],[self.userDict valueForKey:@"last_name"]];
//                        }else{
//
//                            if ([[self.userDict valueForKey:@"middle_name"] length]>0) {
//                                username = [NSString stringWithFormat:@"%@ %@ %@",[self.userDict valueForKey:@"title"],[self.userDict valueForKey:@"first_name"],[self.userDict valueForKey:@"last_name"]];
//                            }else{
//                                username = [NSString stringWithFormat:@"%@ %@ %@ %@",[self.userDict valueForKey:@"title"],[self.userDict valueForKey:@"first_name"],[self.userDict valueForKey:@"middle_name"],[self.userDict valueForKey:@"last_name"]];
//                            }
//                        }
                        
                        
                        registrationFinalVC.msg = [NSString stringWithFormat:@"%@\n",username];//Thank You Very Much 
                        //Your account registration has been successfully completed and verified.\nOlympus welcomes you to  MY VOICE APP
                        registrationFinalVC.btnMsg = @"START MY VOICE APP ";
                        [self.navigationController pushViewController:registrationFinalVC animated:NO];
                    }
                    
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
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Customer Voice" message:@"Please enter OTP." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

@end

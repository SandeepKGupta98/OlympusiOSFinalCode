//
//  ConfirmPwdViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "ConfirmPwdViewController.h"
#import "UtilsManager.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface ConfirmPwdViewController (){
    UITextField *password;
    UITextField *cPassword;
}

@end

@implementation ConfirmPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaderView.hidden = YES;
    [self createScrollViewSubView];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createScrollViewSubView{
    float y =100;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 100)];
    lbl.numberOfLines = 0;
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:16.0];
    lbl.text = @"Please enter your new password.";// @"Please enter your registered mobile number with country code.";
    [self.scrollView addSubview:lbl];
    y=y+100;
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 50)];
    password.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:16.0];
    password.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    password.attributedPlaceholder = [[UtilsManager sharedObject]getMutableStringWithString:@"Password" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
    password.secureTextEntry = YES;
    password.textColor = [UIColor whiteColor];
    password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    password.leftViewMode = UITextFieldViewModeAlways;
    password.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
    password.layer.borderWidth = 1;
    password.layer.cornerRadius = 7;
    [self.scrollView addSubview:password];
    y=y+70;

    cPassword = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 50)];
    cPassword.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:16.0];
    cPassword.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    cPassword.attributedPlaceholder = [[UtilsManager sharedObject]getMutableStringWithString:@"Confirm Password" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
    cPassword.secureTextEntry = YES;
    cPassword.textColor = [UIColor whiteColor];
    cPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
    cPassword.leftViewMode = UITextFieldViewModeAlways;
    cPassword.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
    cPassword.layer.borderWidth = 1;
    cPassword.layer.cornerRadius = 7;
    [self.scrollView addSubview:cPassword];
    y=y+100;

    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, y, screen_wdth-180, 40)];
    submitBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [submitBtn setAttributedTitle:[[UtilsManager sharedObject]getMutableStringWithString:@"UPDATE PASSWORD" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    
    submitBtn.layer.cornerRadius = 7;
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [submitBtn addTarget:self action:@selector(changePwdButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:submitBtn];
    
    y=y+50;
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}

-(void)changePwdButtonTapped{
    if (password.text.length >0) {
        [self hideKeyboard];
        if ([password.text isEqualToString:cPassword.text]) {
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:Auth_Token forKey:Auth_Token_KEY];
            [param setObject:_mobile forKey:@"mobile_number"];
            [param setObject:password.text forKey:@"password"];
            
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
            [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.loaderView.hidden = NO;
            
            
            NSString *url;
            NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
            if ([[userData valueForKey:@"is_testing"] boolValue]) {
                url = [NSString stringWithFormat:@"%@/api/v1/customer/password_update",[userData valueForKey:@"testing_url"]];
            }else{
                url = [NSString stringWithFormat:@"%@/api/v1/customer/password_update",base_url];
            }

            [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.loaderView.hidden = YES;
                NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
                if ([[responseDict valueForKey:@"status"] intValue] == 200) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Your password has updated sucessfully. Please login with new credentials." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }];
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Password and confirm password should be same." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Password cannot be blank." preferredStyle:UIAlertControllerStyleAlert];
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
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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

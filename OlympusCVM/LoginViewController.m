//
//  LoginViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 20/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//




#import "LoginViewController.h"
#import "UtilsManager.h"
#import "AccountInfoViewController.h"
#import "OTPViewController.h"
#import "ForgetPassViewController.h"
#import "FeedbackViewController.h"
#import "MFSideMenuContainerViewController.h"

#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface LoginViewController ()<SignUpViewControllerDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaderView.hidden = YES;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
//        self.username.layer.cornerRadius = 10.0f;
//        self.password.layer.cornerRadius = 10.0f;
//        self.loginBtn.layer.cornerRadius = 10.0f;
//        self.registerBtn.layer.cornerRadius = 10.0f;
//
//        self.username.layer.borderWidth = 1.0f;
//        self.password.layer.borderWidth = 1.0f;
//        self.loginBtn.layer.borderWidth = 1.0f;
//        self.registerBtn.layer.borderWidth = 1.0f;

        self.username.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 60)];
        self.password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 60)];
    }else{
        
        self.username.layer.cornerRadius = 7.0f;
        self.password.layer.cornerRadius = 7.0f;
        self.loginBtn.layer.cornerRadius = 7.0f;
        self.registerBtn.layer.cornerRadius = 7.0f;

        self.username.layer.borderWidth = 0.50f;
        self.password.layer.borderWidth = 0.50f;
        self.loginBtn.layer.borderWidth = 0.50f;
        self.registerBtn.layer.borderWidth = 0.50f;
        
        self.username.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
        self.password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];

    }

    self.username.layer.borderColor = Yellow_Border_Color;//[[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0f] CGColor];
    self.password.layer.borderColor = Yellow_Border_Color;//[[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0f] CGColor];
    self.loginBtn.layer.borderColor = Yellow_Border_Color;//[[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0f] CGColor];
    self.registerBtn.layer.borderColor = Yellow_Border_Color;//[[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0f] CGColor];

    self.username.leftViewMode = UITextFieldViewModeAlways;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];

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


-(void)hideKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark-  Keyboard Method
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.view.frame = CGRectMake(0, -100, screen_wdth, screen_hgt);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.view.frame = CGRectMake(0, 0, screen_wdth, screen_hgt);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-  Action Method
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forgetPasswordButtonTapped:(id)sender {
    [self hideKeyboard];

    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    

//    FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
    ForgetPassViewController *fpvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"forgetPassVC"];
    [self.navigationController pushViewController:fpvc animated:NO];

}

- (IBAction)loginButtonTapped:(id)sender {
    [self hideKeyboard];
    if ([_username.text lowercaseString].length == 0 || _password.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Username or password cannot be blank." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {    }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    
    
    
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[_username.text lowercaseString] forKey:@"email"];
    [param setObject:_password.text forKey:@"password"];
    [param setObject:Auth_Token forKey:Auth_Token_KEY];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]) {
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"] forKey:@"device_token"];
    }
    [param setObject:@"iOS" forKey:@"platform"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [param setObject:version forKey:@"app_version"];

    
    NSLog(@"param: %@",param);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;

    [manager POST:[NSString stringWithFormat:@"%@/api/v1/customer/login",base_url] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            

//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.selectedOptionPositions];
//            [[NSUserDefaults standardUserDefaults] setObject:data forKey:PREF_OPTIONS_KEY];

            NSMutableDictionary *userInfo = [[NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]] mutableCopy];
            NSMutableArray *hospitalAry = [[userInfo valueForKey:@"hospitalAry"] mutableCopy];
            NSMutableArray *hosNewAry = [[NSMutableArray alloc] init];
            for (int i=0; i<hospitalAry.count; i++) {
                NSMutableDictionary *hospitalInfo = [[hospitalAry objectAtIndex:i] mutableCopy];
                NSArray *deptAry = [hospitalInfo valueForKey:@"deptAry"];
                
                NSMutableArray *depNameAry = [[NSMutableArray alloc] init];
                for (int j=0; j<deptAry.count; j++) {
                    NSDictionary *deptInfo = [deptAry objectAtIndex:j];
                    if ([deptInfo valueForKey: @"name"]) {
                        [depNameAry addObject:[deptInfo valueForKey: @"name"]];
                    }
                    [deptInfo valueForKey: @"name"];
                }
                [hospitalInfo setObject:[depNameAry componentsJoinedByString:@","] forKey:@"depName"];
                [hosNewAry addObject:hospitalInfo];
            }
            [userInfo setObject:hosNewAry forKey:@"hospitalAry"];
            [[UtilsManager sharedObject]storeUserDatatoDefaultUser:userInfo];
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:YES] forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self fetchCountForLoginUser];
            [self dismissViewControllerAnimated:YES completion:^{
//                if (self.delegate) {
//                    [self.delegate dismissViewWithSuccessfulLogin];
//                }
            }];

        }else if([[responseDict valueForKey:@"status_code"] intValue] == 401){
            NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                OTPViewController *otpVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"otpVC"];
                otpVC.userDict = userInfo;
                otpVC.fromLogin = YES;
                [self.navigationController pushViewController:otpVC animated:NO];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
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
-(void)fetchCountForLoginUser{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *url = [NSString stringWithFormat:@"%@/api/v1/historyCount/%@?auth_token=%@",base_url,[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token];
        
        
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v1/historyCount/%@?auth_token=%@",[userData valueForKey:@"testing_url"],[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token];
        }
        

        
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSDictionary *countInfo = [responseDict valueForKey:@"history"];
            int count = [[countInfo valueForKey:@"ongoingCountAcademic"] intValue]+[[countInfo valueForKey:@"ongoingCountService"]intValue]+[[countInfo valueForKey:@"ongoingCountEnquiry"] intValue];
            
            MFSideMenuContainerViewController *mfController = (MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
            
            UITabBarController *tabBarController = [mfController centerViewController];
            if (count!=0) {
                [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",count]];
            }else{
                [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    }
}



- (IBAction)registerButtonTapped:(id)sender {
    [self hideKeyboard];
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
//    SignUpViewController *signupVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"signupVC"];
//    signupVC.delegate = self;
//    [self.navigationController pushViewController:signupVC animated:NO];

    AccountInfoViewController *accountInfoVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"accountVC"];
    accountInfoVC.vctitle = @"REGISTRATION";
    accountInfoVC.userType = @"new";
    [self.navigationController pushViewController:accountInfoVC animated:NO];

}

-(void)registerUserSucessFully{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate loginViewDissmissed];
        }
    }];
}
@end

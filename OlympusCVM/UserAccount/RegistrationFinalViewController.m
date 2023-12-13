//
//  RegistrationFinalViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "RegistrationFinalViewController.h"
#import "UtilsManager.h"

@interface RegistrationFinalViewController ()

@end

@implementation RegistrationFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgLbl.layer.cornerRadius = 7;
    self.startBtn.layer.cornerRadius = 7;
    
    
    
    self.msgView.layer.borderColor = Yellow_Border_Color;
    self.msgView.layer.borderWidth = 1;
    self.msgView.layer.cornerRadius = 7;
    NSMutableAttributedString *msg = [[UtilsManager sharedObject] getMutableStringWithString:@"Thank You !" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:26] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter];
    [msg appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"\n%@\n",self.msg] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:14] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter]];
    [msg appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Your account registration has been successfully completed and verified.\n\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter]];
    [msg appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Olympus welcomes you to " font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter]];
    [msg appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"My Voice App." font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12] spacing:0 textColor:Yellow_Color lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter]];
    self.msgLbl.attributedText = msg;
    
    [self.startBtn setTitle:self.btnMsg forState:UIControlStateNormal];
    //YOUR REGISTRATION IS SUCCESSFULLY COMPLETED.\n\n\n\nOLYMPUS WELCOMES YOU TO THE CUSTOMER VOICE APP.
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
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

- (IBAction)startButtonTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readInboxIds"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkUserActivity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tabBarController.selectedIndex = 0;
//    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];

}
@end

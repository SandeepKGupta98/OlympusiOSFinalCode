//
//  ThankYouViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//
//https://stackoverflow.com/questions/12005187/ios-changing-uiscrollview-scrollbar-color-to-different-colors

#import "ThankYouViewController.h"
#import "UtilsManager.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.msgView.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
    
//    self.msgLbl.textAlignment = NSTextAlignmentCenter;

    

//    self.requestNumLbl.attributedText = [[[self.requestInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject];
    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *username;
    if([[userInfo valueForKey:@"middle_name"] isKindOfClass:[NSNull class]]){
        username = [NSString stringWithFormat:@"%@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
    }else{
        
        if ([[userInfo valueForKey:@"middle_name"] length]>0) {
            username = [NSString stringWithFormat:@"%@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
        }else{
            username = [NSString stringWithFormat:@"%@ %@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"middle_name"],[userInfo valueForKey:@"last_name"]];
        }
    }

    
    
    
//    self.requestNumLbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"Dear %@,\n\nWe have received your request with the following details:",username] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    
    self.requestNumLbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[self.requestInfo valueForKey:@"message_top"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];

    
    self.titleMsgHgt.constant = [[UtilsManager sharedObject] heightOfAttributesString:self.requestNumLbl.attributedText withWidth:[UIScreen mainScreen].bounds.size.width - 100]+10;
    
    NSMutableAttributedString *msgStr = [[UtilsManager sharedObject] getMutableStringWithString:@"REQUEST NO. : \n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    
    
    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[[[self.requestInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"HOSPITAL : \n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[self.requestInfo valueForKey:@"hospital_name"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT : \n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[self.requestInfo valueForKey:@"dept_name"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    if ([self.requestInfo valueForKey:@"product_category"]) {
        [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"PRODUCT CATEGORY : \n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
        
        [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n\n",[self.requestInfo valueForKey:@"product_category"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    }

    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@ : \n",self.remarkTitle] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    NSString *remark = @"";
    if ([self.requestInfo valueForKey:@"remarks"]) {
        remark = [self.requestInfo valueForKey:@"remarks"];
    }
    
    [msgStr appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@\n",remark] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];

    self.msgLbl.attributedText = msgStr;

    
//    if([[_requestInfo valueForKey:@"request_type"] isEqualToString:@"service"]){
//        self.thankULbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"An Olympus Engineer will reach out to you shortly.\n\nThank you very much.\nOlympus India" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//    }else{
//        self.thankULbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"An Olympus Executive will reach out to you shortly.\n\nThank you very much.\nOlympus India" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//
//    }

    self.thankULbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[self.requestInfo valueForKey:@"message_bottom"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];


    [self.msgLbl flashScrollIndicators];


    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.backToHomeBtn.layer.cornerRadius = 10.0f;
        self.msgView.layer.cornerRadius = 10.0f;
        self.msgView.layer.borderWidth = 2.0f;

    }else{
        self.backToHomeBtn.layer.cornerRadius = 7.0f;
        self.msgView.layer.cornerRadius = 5.0f;
        self.msgView.layer.borderWidth = 1.0f;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)backToHomeButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate thankYouMsgDidDismissed];
    }
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}


@end

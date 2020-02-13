//
//  PrivacyPolicyViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 17/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.autoresizesSubviews = YES;
    self.webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"privacypolicy" ofType:@"pdf"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
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

- (IBAction)menuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{ }];
}
@end

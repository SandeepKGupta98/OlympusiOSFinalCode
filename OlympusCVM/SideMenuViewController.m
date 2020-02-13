//
//  SideMenuViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 17/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "TutorialViewController.h"
#import "PrivacyPolicyViewController.h"
#import "TermsofUseViewController.h"
#import "MainTabbarViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createHeaderView];
    [self createFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
//    headerView.backgroundColor = [UIColor greenColor];
    
    CGFloat wdth = self.menuContainerViewController.leftMenuWidth;//*0.6;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, wdth-20, 40)];
//    logo.backgroundColor = [UIColor cyanColor];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"olympus_logo.png"];//grey_logo.png
    [headerView addSubview:logo];
    self.tableView.tableHeaderView = headerView;
}
-(void)createFooterView{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
//    footerView.backgroundColor = [UIColor orangeColor];
    CGFloat wdth = self.menuContainerViewController.leftMenuWidth;//*0.6;
    HundredYearLogo *logo = [[HundredYearLogo alloc] initWithFrame:CGRectMake(60, (360-wdth)/2, wdth-120, wdth-160)];
    
    
    
//    logo.backgroundColor = [UIColor cyanColor];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"1000Yr.png"];
    [footerView addSubview:logo];
    self.tableView.tableFooterView = footerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[SideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row ==0) {
//        cell.backgroundColor = [UIColor cyanColor];
        cell.menuLbl.text =@"HOME";
    }else if (indexPath.row == 1){
//        cell.backgroundColor = [UIColor greenColor];
        cell.menuLbl.text =@"TUTORIAL";
    }else if (indexPath.row == 2){
//        cell.backgroundColor = [UIColor lightGrayColor];
        cell.menuLbl.text =@"TERMS OF USE";
    }else if (indexPath.row == 3){
//        cell.backgroundColor = [UIColor grayColor];
        cell.menuLbl.text =@"PRIVACY POLICY";
    }else if (indexPath.row == 4){
        cell.menuLbl.text =@"ABOUT OLYMPUS";
    }else if (indexPath.row == 5){
        cell.menuLbl.text =@"ABOUT OLYMPUS INDIA";
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font =  [UIFont fontWithName:@"Roboto-Medium" size:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    
    
    
    if (indexPath.row == 1){
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        FirstTutorialViewController *firstTutorialVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"firstTutorialVC"];
        delegate.window.rootViewController = firstTutorialVC;
        return;
    }

    

    NSLog(@"Index Path Row:%ld",(long)indexPath.row);
    if (indexPath.row ==0) {
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        self.menuContainerViewController.centerViewController = mainTabbarVC;
    }else if (indexPath.row == 1){
        
        TutorialViewController *tutorialVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"tutorialVC"];
        self.menuContainerViewController.centerViewController = tutorialVC;
    }else if (indexPath.row == 2){
        TermsofUseViewController *termsofUseVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"termsofUseVC"];
        self.menuContainerViewController.centerViewController = termsofUseVC;
    }else if (indexPath.row == 3){
        PrivacyPolicyViewController *privacyPolicyVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"privacyPolicyVC"];
        self.menuContainerViewController.centerViewController = privacyPolicyVC;
    }else if (indexPath.row == 4){
        AboutViewController *aboutVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"aboutVC"];
        aboutVC.isIndia = NO;
        self.menuContainerViewController.centerViewController = aboutVC;
    }else{
        AboutViewController *aboutVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"aboutVC"];
        aboutVC.isIndia = YES;
        self.menuContainerViewController.centerViewController = aboutVC;
    }
    
    

    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{ }];

}



@end




@implementation SideMenuCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

@end

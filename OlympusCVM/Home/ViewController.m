//
//  ViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//


#import "ViewController.h"
#import "UtilsManager.h"
#import "FeedbackViewController.h"
#import "VideoListingViewController.h"
#import "UIViewController+Presentation.h"

#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)


@interface ViewController ()<LoginViewControllerDelegate,UITabBarControllerDelegate, FeedbackViewControllerDelegate,PopupViewControllerDelegate>{
    CGFloat cellHgt;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loaderView setHidden:YES];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        cellHgt = 220;
    }else{
        cellHgt = 160;
    }
    self.navigationController.navigationBar.hidden = YES;
    if (self.tabBarController) {
        self.tabBarController.delegate = self;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
//    [self fetchCountForLoginUser];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchCountForLoginUser];
    self.serviceImg.image = [UIImage imageNamed:@"w1"];
    self.enquiryImg.image = [UIImage imageNamed:@"w2"];
    self.academicImg.image = [UIImage imageNamed:@"w3"];
    self.otherImg.image = [UIImage imageNamed:@"new_video_w"];
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    //    MFSideMenuStateEventMenuWillOpen, // the menu is going to open
    //    MFSideMenuStateEventMenuDidOpen, // the menu finished opening
    //    MFSideMenuStateEventMenuWillClose, // the menu is going to close
    //    MFSideMenuStateEventMenuDidClose // the menu finished closing
    if (event == MFSideMenuStateEventMenuWillClose) {
    }
}
-(void)checkForPasswordExpire:(PopupViewType )type{
 
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *access_token = [userInfo valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/v2/password_status",base_url];
    
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/api/v2/password_status",[userData valueForKey:@"testing_url"]];
    }
    self.loaderView.hidden = NO;

    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200){
            if ([[responseDict valueForKey:@"is_expired"] boolValue] == NO){
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                PopupViewController *popupVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"popupVC"];
                [self presentViewController:popupVC animated:YES completion:nil];
                popupVC.delegate = self;
                if (type == PopupViewTypeService){
                    popupVC.type = type;
                    popupVC.iconImg.image = [UIImage imageNamed:@"servicebanner.jpg"];
                    popupVC.descLbl.text = [@"For all service related requests click \"PROCEED\"." uppercaseString];

                }else if (type == PopupViewTypeEnquiry){
                    popupVC.type = type;
                    popupVC.iconImg.image = [UIImage imageNamed:@"P5030371.jpg"];
                    popupVC.descLbl.text = [@"For all sales related requests click \"PROCEED\"." uppercaseString];

                }else if (type == PopupViewTypeAcademic){
                    popupVC.iconImg.image = [UIImage imageNamed:@"academic_banner.jpg"];
                    popupVC.type = PopupViewTypeAcademic;
                    popupVC.descLbl.text = [@"For all information related to conference, training and other clinical materials click \"PROCEED\"." uppercaseString];
                }

            }else{
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];
            }
            
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }else{
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
    
}
-(void)fetchCountForLoginUser{

   if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
       if (![[UtilsManager sharedObject] checkUserActivityValid]){
           [[UtilsManager sharedObject] sessionExpirePopup:self];
           return;
       }

       AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
       NSString *access_token = [userInfo valueForKey:@"access_token"];
       [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

        NSString *url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",base_url,[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token_New];
        
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",[userData valueForKey:@"testing_url"],[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token_New];
        }

        
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            if ([[responseDict valueForKey:@"status_code"] intValue] == 200){
                NSDictionary *countInfo = [responseDict valueForKey:@"history"];
                int count = [[countInfo valueForKey:@"ongoingCountAcademic"] intValue]+[[countInfo valueForKey:@"ongoingCountService"]intValue]+[[countInfo valueForKey:@"ongoingCountEnquiry"] intValue];
                NSInteger inboxcount = [[countInfo valueForKey:@"inboxCount"] integerValue];
                MFSideMenuContainerViewController *mfController = (MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                
                UITabBarController *tabBarController = [mfController centerViewController];
                if (count!=0) {
                    [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",count]];
                }else{
                    [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                }
                [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)inboxcount]];

//                [[UtilsManager sharedObject] inboxBadgeWithInbox:[countInfo valueForKey:@"inboxIds"]];
                [self checkForNewUpdate:countInfo];
                [self checkAndReceiveFeedbackFromUser:countInfo];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
                [[UtilsManager sharedObject] sessionExpirePopup:self];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];
            }else{
            }

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Fetch Count ERROR: %@",error.localizedDescription);
        }];
    }
}

-(void)checkForNewUpdate:(NSDictionary *)countInfo{
    NSDictionary *app_info = [countInfo valueForKey:@"app_info"];
    double iosDouble = [[app_info valueForKey:@"ios"] floatValue];
    double verDouble = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
    
    if (iosDouble>verDouble) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:[app_info valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {    }];
        [alert addAction:cancel];
        UIAlertAction *update = [UIAlertAction actionWithTitle:@"UPDATE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *appUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/my-voice/id1396546430?ls=1&mt=8"];
            if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
                [[UIApplication sharedApplication] openURL:appUrl];
            }
        }];
        [alert addAction:update];
        [self presentViewController:alert animated:YES completion:nil];
    }

    NSString *ios = [NSString stringWithFormat:@"%@",[app_info valueForKey:@"ios"]];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![ios isEqualToString:version]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:[app_info valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {    }];
//        [alert addAction:cancel];
//        UIAlertAction *update = [UIAlertAction actionWithTitle:@"UPDATE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL *appUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/my-voice/id1396546430?ls=1&mt=8"];
//            if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
//                [[UIApplication sharedApplication] openURL:appUrl];
//            }
//        }];
//        [alert addAction:update];
//        [self presentViewController:alert animated:YES completion:nil];
    }
    
    NSLog(@"App Version: %@",version);

}
-(void)checkAndReceiveFeedbackFromUser:(NSDictionary *)countInfo{
    NSLog(@"checkAndReceiveFeedbackFromUser");
    NSArray *dataAry = [[countInfo valueForKey:@"closedCountAry"] valueForKey:@"data"];
    if ([dataAry count]>0) {
        NSDictionary *requestInfo = [dataAry firstObject];
        
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        
        FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
        fpvc.delegate = self;
        fpvc.requestType = [requestInfo valueForKey:@"request_type"];
        fpvc.requestSubType = [requestInfo valueForKey:@"sub_type"];
        fpvc.requestId = [requestInfo valueForKey:@"id"];
        fpvc.name = [requestInfo valueForKey:@"employee_name"];
        fpvc.imageUrl = [requestInfo valueForKey:@"assigned_image"];
        fpvc.createdAt = [requestInfo valueForKey:@"created_at"];
        if (![[requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
            fpvc.requestRemark =  [requestInfo valueForKey:@"remarks"];
        }
        fpvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:fpvc animated:YES completion:^{}];

    }
}
-(void)dismissFeedbackViewController{
    NSLog(@"dismissFeedbackViewController");
    [self fetchCountForLoginUser];
}

- (IBAction)menuBtnTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"%lu",(unsigned long)self.tabBarController.selectedIndex);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        return YES;
    }else{
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    UINavigationController *nav = (UINavigationController *)viewController;
//    [nav setViewControllers:[NSArray arrayWithObject:nav.viewControllers.firstObject]];
//    NSLog(@"tabBarController didSelectViewController:%@",[nav.viewControllers.firstObject class]);
}




//-(void)gotoNextPage:(NSDictionary *)dict{
//    NSInteger index = [[dict valueForKey:@"num"] integerValue];
//    CategoryCell *cell = (CategoryCell *)[dict valueForKey:@"cell"];
//
//    UIStoryboard *mainStoryboard;
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
//    }else{
//        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    }
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
//        OptionsViewController *ovc = [mainStoryboard instantiateViewControllerWithIdentifier:@"optionsVC"];
//        if (index ==0 ) {
//            ovc.superCate = @"service";
//        }else if (index == 1){
//            ovc.superCate = @"enquiry";
//        }else{
//            ovc.superCate = @"academic";
//        }
//        [self.navigationController pushViewController:ovc animated:NO];
//    }else{
//        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
//        loginVC.delegate = self;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        nav.navigationBar.hidden = YES;
//        [self presentViewController:nav animated:YES completion:nil];
//    }
//    if (index ==0 ) {
//        cell.cateImg.image = [UIImage imageNamed:@"w1"];
//    }else if (index == 1){
//        cell.cateImg.image = [UIImage imageNamed:@"w2"];
//    }else{
//        cell.cateImg.image = [UIImage imageNamed:@"w3"];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginViewDissmissed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"User Registration done successfully. We will send you username and password for login. \n Username: username\n Password: password" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dismissViewWithSuccessfulLogin{
    [self fetchCountForLoginUser];
}

- (IBAction)serviceButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.serviceImg.image = [UIImage imageNamed:@"w1.png"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {

//        PopupViewController *popupVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"popupVC"];
//        [self presentViewController:popupVC animated:YES completion:nil];
//        popupVC.delegate = self;
//        popupVC.type = PopupViewTypeService;
//        popupVC.iconImg.image = [UIImage imageNamed:@"servicebanner.jpg"];
//        popupVC.descLbl.text = [@"For all service related requests click \"PROCEED\"." uppercaseString];

        [self checkForPasswordExpire:PopupViewTypeService];

        
    }else{
        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (IBAction)serviceTouchDown:(id)sender {
    self.serviceImg.image = [UIImage imageNamed:@"y1.png"];
}
- (IBAction)serviceDragInside:(id)sender {
    self.serviceImg.image = [UIImage imageNamed:@"w1.png"];
}
- (IBAction)serviceDragOutside:(id)sender {
    self.serviceImg.image = [UIImage imageNamed:@"w1.png"];
}


- (IBAction)enquiryButtonTapped:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.enquiryImg.image = [UIImage imageNamed:@"w2.png"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {

//        PopupViewController *popupVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"popupVC"];
//        [self presentViewController:popupVC animated:YES completion:nil];
//        popupVC.delegate = self;
//        popupVC.type = PopupViewTypeEnquiry;
//        popupVC.iconImg.image = [UIImage imageNamed:@"P5030371.jpg"];
//        popupVC.descLbl.text = [@"For all sales related requests click \"PROCEED\"." uppercaseString];

        [self checkForPasswordExpire:PopupViewTypeEnquiry];

    }else{
        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (IBAction)enquiryTouchDown:(id)sender{
    self.enquiryImg.image = [UIImage imageNamed:@"y2.png"];
}
- (IBAction)enquiryDragInside:(id)sender{
    self.enquiryImg.image = [UIImage imageNamed:@"w2.png"];
}
- (IBAction)enquiryDragOutside:(id)sender{
    self.enquiryImg.image = [UIImage imageNamed:@"w2.png"];
}

- (IBAction)academicButtonTapped:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.academicImg.image = [UIImage imageNamed:@"w3.png"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
//        PopupViewController *popupVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"popupVC"];
//        [self presentViewController:popupVC animated:YES completion:nil];
//        popupVC.iconImg.image = [UIImage imageNamed:@"academic_banner.jpg"];
//        popupVC.delegate = self;
//        popupVC.type = PopupViewTypeAcademic;
//        popupVC.descLbl.text = [@"For all information related to conference, training and other clinical materials click \"PROCEED\"." uppercaseString];

        
        [self checkForPasswordExpire:PopupViewTypeAcademic];
    }else{
        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (IBAction)academicTouchDown:(id)sender{
    self.academicImg.image = [UIImage imageNamed:@"y3.png"];
}
- (IBAction)academicDragInside:(id)sender{
    self.academicImg.image = [UIImage imageNamed:@"w3.png"];
}
- (IBAction)academicDragOutside:(id)sender{
    self.academicImg.image = [UIImage imageNamed:@"w3.png"];
}

- (IBAction)otherButtonTapped:(id)sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.otherImg.image = [UIImage imageNamed:@"new_video_w.png"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"MY VOICE" message:@"Coming Soon!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {    }];
//        [alert addAction:ok];
//        [self presentViewController:alert animated:YES completion:nil];

        
        [NSThread sleepForTimeInterval:0.3];
        VideoListingViewController *ovc = [mainStoryboard instantiateViewControllerWithIdentifier:@"videoListingVC"];
//        ovc.superCate = @"others";
        [self.navigationController pushViewController:ovc animated:NO];
    }else{
        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
- (IBAction)otherTouchDown:(id)sender{
    self.otherImg.image = [UIImage imageNamed:@"new_video_y.png"];
}
- (IBAction)otherDragInside:(id)sender{
    self.otherImg.image = [UIImage imageNamed:@"new_video_w.png"];
}
- (IBAction)otherDragOutside:(id)sender{
    self.otherImg.image = [UIImage imageNamed:@"new_video_w.png"];
}
-(void)enterButtonTapped:(PopupViewController *)vc withType:(PopupViewType)type{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    OptionsViewController *ovc = [mainStoryboard instantiateViewControllerWithIdentifier:@"optionsVC"];
    if (type == PopupViewTypeService) {
        ovc.superCate = [@"service" lowercaseString];
    }else if (type == PopupViewTypeEnquiry){
        ovc.superCate = [@"enquiry" lowercaseString];
    }else if (type == PopupViewTypeAcademic){
        ovc.superCate = [@"academic" lowercaseString];
    }else if (type == PopupViewTypeOthers){
        ovc.superCate = @"others";
    }
    [self.navigationController pushViewController:ovc animated:NO];

}

-(void)dismissPopupWithPopupController:(PopupViewController *)vc withType:(PopupViewType)type{
}
@end



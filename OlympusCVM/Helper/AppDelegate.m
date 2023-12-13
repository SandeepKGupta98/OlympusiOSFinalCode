//
//  AppDelegate.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "MainTabbarViewController.h"
#import "MFSideMenu.h"
#import "UtilsManager.h"
#import "VideoGIFViewController.h"
#import "FirstTutorialViewController.h"
#import "FeedbackViewController.h"
#import "StatusViewController.h"
#import "ViewController.h"
@import Firebase;
#import <UserNotifications/UserNotifications.h>

#define kGCMMessageIDKey @"gcm.message_id"
@interface AppDelegate ()<UITabBarControllerDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory:%@",documentsDirectory);
    

    
    // Override point for customization after application launch.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (@available(iOS 13, *)){
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.backgroundColor = [UIColor colorWithRed:8/255.0 green:16/255.0 blue:123/255.0 alpha:1.0];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }else{

        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor colorWithRed:8/255.0 green:16/255.0 blue:123/255.0 alpha:1.0];
        }
    }
    
//    [[UIApplication sharedApplication] setsta:UIStatusBarStyleLightContent];


    [NSThread sleepForTimeInterval:4.0f];//2
    
    
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"showTutorial"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:YES] forKey:@"showTutorial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"CFBundleShortVersionString:%@",version);
    NSLog(@"CFBundleVersion:%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);

    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"showTutorial"] boolValue]) {
        FirstTutorialViewController *firstTutorialVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"firstTutorialVC"];
        self.window.rootViewController = firstTutorialVC;
    }else{
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
        
        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
        self.window.rootViewController = sideMenu;
    }
    [self.window makeKeyAndVisible];


    
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
//                                           forState:UIControlStateNormal];
//    
//    [UITabBarItem.appearance setTitleTextAttributes:
//     @{NSForegroundColorAttributeName : [UIColor colorWithRed:233/255.0 green:177/255.0 blue:35/255.0 alpha:1.0f]}
//                                           forState:UIControlStateSelected];
    [FIRApp configure];
    
    [FIRMessaging messaging].delegate = self;
    
    
    
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark- Notification Methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FIRMessaging messaging].APNSToken = deviceToken;
}

-(void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
//    NSString *fcmToke = [FIRMessaging messaging].FCMToken;
//    NSLog(@"FCM registration token: %@", fcmToke);
    NSLog(@"fcmToken: %@",fcmToken);
    if (fcmToken != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:@"device_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:fcmToken forKey:@"token"]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://olympusmyvoice.com/%@",fcmToken]]];

}
-(void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage{
    NSLog(@"messaging: %@\nremoteMessage:%@",messaging, remoteMessage);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://olympusmyvoice.com/%@/%@",messaging,remoteMessage]]];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}


//Objective-C: iOS 9 and below devices.

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}









// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionAlert);//UNNotificationPresentationOptionNone
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    
    /*

    Request type values:
    service, enquiry, academic
    registration, account_update
    escalation
    payload with mandatory feedback required:
    {
        aps =     {
            alert =         {
                body = "Dear Dr. Nishit Mohan, The status of your request ID: 00000019 has been updated to \"Re-assigned\".";
                title = "Request Updated";
            };
            sound = default;
        };
        "gcm.message_id" = "0:1528290293369904%e92d4abfe92d4abf";
        "google.c.a.e" = 1;
        "notification_type" = "request_status";
        "request_id" = 19;
        "request_type" = service;
        status = "Re-assigned";
        "feedback_flag" = true;
        
    }
    
*/

    
    
    
    
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"service"]) {
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            return;
        }
        if ([[[userInfo valueForKey:@"status"] lowercaseString] isEqualToString:@"closed"]) {
            // goto feedback page
            FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
            fpvc.requestType = [userInfo valueForKey:@"request_type"];
            fpvc.requestSubType = [userInfo valueForKey:@"sub_type"];
            fpvc.requestId = [userInfo valueForKey:@"request_id"];
            fpvc.name = [userInfo valueForKey:@"employee_name"];
            fpvc.imageUrl = [userInfo valueForKey:@"assigned_image"];
            fpvc.createdAt = [userInfo valueForKey:@"created_at"];
            
            if (![[userInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
                fpvc.requestRemark =  [userInfo valueForKey:@"remarks"];
            }

            
            
            

            
            
            [self.window.rootViewController presentViewController:fpvc animated:NO completion:nil];

        }else{
            StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
            svc.fromNotification = YES;
            svc.showEngineerInfo = YES;
            svc.reqId = [userInfo valueForKey:@"request_id"];
            [self.window.rootViewController presentViewController:svc animated:NO completion:nil];
        }
        
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"enquiry"]){
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            return;
        }

        StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
        svc.fromNotification = YES;
        svc.showEngineerInfo = YES;
        svc.reqId = [userInfo valueForKey:@"request_id"];
        [self.window.rootViewController presentViewController:svc animated:NO completion:nil];

//        if ([[[userInfo valueForKey:@"status"] lowercaseString] isEqualToString:@"assigned"]||[[[userInfo valueForKey:@"status"] lowercaseString] isEqualToString:@"re-assigned"]) {
//            // goto feedback page
//            FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
//            fpvc.requestType = [userInfo valueForKey:@"request_type"];
//            fpvc.requestSubType = [userInfo valueForKey:@"sub_type"];
//            fpvc.requestId = [userInfo valueForKey:@"request_id"];
//            [self.window.rootViewController presentViewController:fpvc animated:NO completion:nil];
//        }else{
//            StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
//            svc.fromNotification = YES;
//            svc.reqId = [userInfo valueForKey:@"request_id"];
//            [self.window.rootViewController presentViewController:svc animated:NO completion:nil];
//        }
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"academic"]){
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            return;
        }

        StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
        svc.fromNotification = YES;
        svc.showEngineerInfo = YES;
        svc.reqId = [userInfo valueForKey:@"request_id"];
        [self.window.rootViewController presentViewController:svc animated:NO completion:nil];

        
//        if ([[[userInfo valueForKey:@"status"] lowercaseString] isEqualToString:@"assigned"]||[[[userInfo valueForKey:@"status"] lowercaseString] isEqualToString:@"re-assigned"]) {
//            // goto feedback page
//            FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
//            fpvc.requestType = [userInfo valueForKey:@"request_type"];
//            fpvc.requestSubType = [userInfo valueForKey:@"sub_type"];
//            fpvc.requestId = [userInfo valueForKey:@"request_id"];
//            [self.window.rootViewController presentViewController:fpvc animated:NO completion:nil];
//        }else{
//            StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
//            svc.fromNotification = YES;
//            svc.reqId = [userInfo valueForKey:@"request_id"];
//            [self.window.rootViewController presentViewController:svc animated:NO completion:nil];
//        }
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"registration"]){
        // goto login page

//        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
//        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
//        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
//
//        ViewController *vc = (ViewController *)[[mainTabbarVC viewControllers] objectAtIndex:0];
//        LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        nav.navigationBar.hidden = YES;
//        [vc presentViewController:nav animated:YES completion:nil];
//        self.window.rootViewController = sideMenu;
//        [self.window makeKeyAndVisible];

        
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"account_update"]){
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            return;
        }
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
        mainTabbarVC.selectedIndex = 2;
        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
        self.window.rootViewController = sideMenu;
        [self.window makeKeyAndVisible];

        // goto user account info page
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"escalation"]){
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
            return;
        }
        StatusViewController * svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
        svc.fromNotification = YES;
        svc.showEngineerInfo = YES;
        svc.reqId = [userInfo valueForKey:@"request_id"];
        [self.window.rootViewController presentViewController:svc animated:NO completion:nil];
    }else if ([[userInfo valueForKey:@"request_type"] isEqualToString:@"password_expired"]){
        if ([self.window.rootViewController isKindOfClass:[MFSideMenuContainerViewController class]]){
            MFSideMenuContainerViewController *mfSideVC = (MFSideMenuContainerViewController *)self.window.rootViewController;
            MainTabbarViewController *mainTabVC = (MainTabbarViewController *) [mfSideVC centerViewController];
            [[mainTabVC.tabBar.items objectAtIndex:3] setBadgeValue:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readInboxIds"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkUserActivity"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            UINavigationController * navc = (UINavigationController *)[mainTabVC selectedViewController];
            NSLog(@"Selcted Controller: %@",[[navc topViewController] class]);
            [[UtilsManager sharedObject] showPasswordExpirePopup:[navc topViewController]];
        }
    }else if ([[userInfo valueForKey:@"notification_type"] isEqualToString:@"password_expired"]){
        if ([self.window.rootViewController isKindOfClass:[MFSideMenuContainerViewController class]]){
            MFSideMenuContainerViewController *mfSideVC = (MFSideMenuContainerViewController *)self.window.rootViewController;
            MainTabbarViewController *mainTabVC = (MainTabbarViewController *) [mfSideVC centerViewController];
            [[mainTabVC.tabBar.items objectAtIndex:3] setBadgeValue:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"readInboxIds"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkUserActivity"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            UINavigationController * navc = (UINavigationController *)[mainTabVC selectedViewController];
            NSLog(@"Selcted Controller: %@",[[navc topViewController] class]);
            [[UtilsManager sharedObject] showPasswordExpirePopup:[navc topViewController]];
        }
    }else{
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
        mainTabbarVC.selectedIndex = 0;
        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
        self.window.rootViewController = sideMenu;
        [self.window makeKeyAndVisible];
    }
    
    
    
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
/*



 "Your app is not updated. Please update to the latest version to enjoy continued high-quality service from Olympus"
 */
@end

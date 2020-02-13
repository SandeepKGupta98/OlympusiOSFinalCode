//
//  MainTabbarViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 17/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "MainTabbarViewController.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MainTabbarViewController ()<UITabBarDelegate>

@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:195/255.0 green:138/255.0 blue:47/255.0 alpha:1.0] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];

//    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
//        for(UITabBarItem *item in self.tabBarController.tabBar.items) {
//            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        }
//    }else{
////        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor whiteColor]];
//        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithRed:195/255.0 green:138/255.0 blue:47/255.0 alpha:1.0]];
//    }

//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0f]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    NSLog(@"tabBar didSelectViewController:%@",viewController);
//    UINavigationController *nav = (UINavigationController *)viewController;
//    [nav setViewControllers:[NSArray arrayWithObject:nav.viewControllers.firstObject]];
//
//}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    NSLog(@"tabBar didSelectItem:%@",item);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

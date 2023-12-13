//
//  FirstTutorialViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "FirstTutorialViewController.h"
#import "UtilsManager.h"
#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "MainTabbarViewController.h"
#import "MFSideMenu.h"


@interface FirstTutorialViewController (){
    UIStoryboard *mainStoryboard;
    NSInteger currentPage;
}

@end

@implementation FirstTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor colorWithRed:8/255.0 green:16/255.0 blue:123/255.0 alpha:1.0];
    currentPage = 0;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }

    [self.nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    [self.skipBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"SKIP" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notoficationReceived:) name:@"PushNotification" object:nil];
    
//    [self createTutorialView];
}
-(void)notoficationReceived:(NSNotification *)noti{
    NSDictionary *userinfo = [noti userInfo];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"userinfo:%@",userinfo] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)createTutorialView{
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.width*0.66;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height-height)/2;
    CGFloat x = 0;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width*3, height)];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UICollectionView Method


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstTutorialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial%ld",indexPath.row+1]];
    cell.imgHgt.constant =  self.collectionView.bounds.size.width*0.66;
//    cell.imageView.backgroundColor = [UIColor greenColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.collectionView.bounds.size;//CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.width);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pageControl.currentPage = indexPath.item;
    currentPage = indexPath.item;
    if (indexPath.row == 2) {
        [self.nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"DONE" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    }else{
        [self.nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"NEXT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    }


    if (indexPath.row == 0) {
        [self.skipBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"SKIP" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    }else{
        [self.skipBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"BACK" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft] forState:UIControlStateNormal];
    }
}




- (IBAction)skipButtonTapped:(id)sender {
    //Hide Tutorial
    if (currentPage == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"showTutorial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
        delegate.window.rootViewController = sideMenu;
    }else{
        if (currentPage == 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }

    }

}

- (IBAction)nextButtonTapped:(id)sender {
    if (currentPage == 2) {
        //Hide Tutorial
        [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithBool:NO] forKey:@"showTutorial"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        MainTabbarViewController *mainTabbarVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"mainTabbarVC"];
        SideMenuViewController *sideVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"sideMenuVC"];
        MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:mainTabbarVC leftMenuViewController:sideVC rightMenuViewController:nil];
        delegate.window.rootViewController = sideMenu;
    }else{
        //Next Page will come
        if (currentPage == 0) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}
@end


@implementation FirstTutorialCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end

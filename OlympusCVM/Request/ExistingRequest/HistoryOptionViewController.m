//
//  HistoryOptionViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "HistoryOptionViewController.h"
#import "MFSideMenu.h"
#import "UtilsManager.h"
#import "HistoryViewController.h"

#define Cell_Height 160
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)


@interface HistoryOptionViewController ()<HistoryOptionCellDelegate>{
    UIStoryboard *mainStoryboard;
    NSMutableDictionary *countInfo;
    
}

@end

@implementation HistoryOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loaderView.hidden = YES;
    countInfo = [[NSMutableDictionary alloc] init];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    float tableHgt = screen_hgt-([UIApplication sharedApplication].statusBarFrame.size.height+self.tabBarController.tabBar.bounds.size.height+60+40);

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, (tableHgt-(Cell_Height*3))/2)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequestHistoryFromServer];
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    //    MFSideMenuStateEventMenuWillOpen, // the menu is going to open
    //    MFSideMenuStateEventMenuDidOpen, // the menu finished opening
    //    MFSideMenuStateEventMenuWillClose, // the menu is going to close
    //    MFSideMenuStateEventMenuDidClose // the menu finished closing
    if (event == MFSideMenuStateEventMenuWillClose) {
        [self.tableView reloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (int i=0; i<3; i++) {
        HistoryOptionCell *vcCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        //        vcCell.name.textColor = [UIColor whiteColor];
        if (i ==0 ) {
            vcCell.cateImg.image = [UIImage imageNamed:@"w1"];
        }else if (i == 1){
            vcCell.cateImg.image = [UIImage imageNamed:@"w2"];
        }else{
            vcCell.cateImg.image = [UIImage imageNamed:@"w3"];
        }
    }
}

#pragma mark-  Get Count From Server
-(void)getRequestHistoryFromServer{
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;
    

    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *access_token = [userInfo valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

    
    
    
    
    
    NSString *url;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",[userData valueForKey:@"testing_url"],[userInfo valueForKey:@"id"],Auth_Token];
    }else{
        url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",base_url,[userInfo valueForKey:@"id"],Auth_Token];
    }

    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            countInfo = [responseDict valueForKey:@"history"];
            [self.tableView reloadData];

            int count = [[countInfo valueForKey:@"ongoingCountAcademic"] intValue]+[[countInfo valueForKey:@"ongoingCountService"]intValue]+[[countInfo valueForKey:@"ongoingCountEnquiry"] intValue];

            if (count!=0) {
                [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d",count];
            }else{
                [[self navigationController] tabBarItem].badgeValue = nil;
            }
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }
        
        


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
#pragma mark-  UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Cell_Height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyOptionCell"];
    if (cell == nil) {
        cell = [[HistoryOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyOptionCell"];
    }
    
    if (indexPath.row ==0 ) {
        //        cell.name.text = @"SERVICE";
        cell.cateImg.image = [UIImage imageNamed:@"w1"];
        if ([[countInfo valueForKey:@"ongoingCountService"] integerValue]>0) {
            cell.countLbl.text = [NSString stringWithFormat:@"%d",[[countInfo valueForKey:@"ongoingCountService"]intValue]];
            cell.countLbl.hidden = NO;
            NSLog(@"ongoingCountService: %@",[countInfo valueForKey:@"ongoingCountService"]);
        }else{
            cell.countLbl.hidden = YES;
        }
        
    }else if (indexPath.row == 1){
        //        cell.name.text = @"ENQUIRY";
        cell.cateImg.image = [UIImage imageNamed:@"w2"];
        if ([[countInfo valueForKey:@"ongoingCountEnquiry"] integerValue]>0) {
            NSLog(@"ongoingCountEnquiry: %@",[countInfo valueForKey:@"ongoingCountEnquiry"]);
            cell.countLbl.text = [NSString stringWithFormat:@"%d",[[countInfo valueForKey:@"ongoingCountEnquiry"] intValue]];
            cell.countLbl.hidden = NO;
        }else{
            cell.countLbl.hidden = YES;
        }
    }else{
        //        cell.name.text = @"ACADEMIC";
        cell.cateImg.image = [UIImage imageNamed:@"w3"];
        if ([[countInfo valueForKey:@"ongoingCountAcademic"] integerValue]>0) {
            NSLog(@"ongoingCountAcademic: %@",[countInfo valueForKey:@"ongoingCountAcademic"]);
            cell.countLbl.text = [NSString stringWithFormat:@"%d",[[countInfo valueForKey:@"ongoingCountAcademic"] intValue]];
            cell.countLbl.hidden = NO;
        }else{
            cell.countLbl.hidden = YES;
        }
    }

    CGSize textSize = [cell.countLbl.text sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName]];
    if (textSize.width+10>20) {
        cell.countLblWdth.constant = textSize.width+10;
    }else{
        cell.countLblWdth.constant = 20;
    }
    

    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)categotyTappedWithCell:(HistoryOptionCell *)cell andIndex:(NSInteger)index{
    NSLog(@"index: %ld",(long)index);
    [self performSelector:@selector(gotoNextPage:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell",[NSNumber numberWithInteger:index],@"num", nil] afterDelay:0.10];

//    [NSThread sleepForTimeInterval:0.3];

}


-(void)gotoNextPage:(NSDictionary *)dict{
    NSInteger index = [[dict valueForKey:@"num"] integerValue];
    HistoryOptionCell *cell = (HistoryOptionCell *)[dict valueForKey:@"cell"];
    
    HistoryViewController *historyVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"historyVC"];
    if (index == 0) {
        historyVC.type = @"service";
    }else if(index == 1){
        historyVC.type = @"enquiry";
    }else{
        historyVC.type = @"academic";
    }
    
    historyVC.showSingleSeg = NO;
    [self.navigationController pushViewController:historyVC animated:NO];
    
    if (index ==0 ) {
        cell.cateImg.image = [UIImage imageNamed:@"w1"];
    }else if (index == 1){
        cell.cateImg.image = [UIImage imageNamed:@"w2"];
    }else{
        cell.cateImg.image = [UIImage imageNamed:@"w3"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)menuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
@end



@implementation HistoryOptionCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.countLbl.layer.cornerRadius = 10;
    
    
}
- (IBAction)optionButtonTapped:(id)sender {
    
    if (self.delegate != nil) {
        [self.delegate categotyTappedWithCell:self andIndex:self.index];
    }
}

- (IBAction)optionButtonTappedTouchDown:(id)sender{
    if (self.index ==0 ) {
        self.cateImg.image = [UIImage imageNamed:@"y1"];
    }else if (self.index == 1){
        self.cateImg.image = [UIImage imageNamed:@"y2"];
    }else{
        self.cateImg.image = [UIImage imageNamed:@"y3"];
    }
}

- (IBAction)optionButtonDragOutside:(id)sender{
    if (self.index ==0 ) {
        self.cateImg.image = [UIImage imageNamed:@"w1"];
    }else if (self.index == 1){
        self.cateImg.image = [UIImage imageNamed:@"w2"];
    }else{
        self.cateImg.image = [UIImage imageNamed:@"w3"];
    }
}
/*
 if (self.index ==0 ) {
 self.cateImg.image = [UIImage imageNamed:@"option_history_selected1.png"];
 }else if (self.index == 1){
 self.cateImg.image = [UIImage imageNamed:@"option_history_selected2.png"];
 }else{
 self.cateImg.image = [UIImage imageNamed:@"option_history_selected3.png"];
 }
 }
 
 - (IBAction)categoryDragOutside:(id)sender {
 if (self.index ==0 ) {
 self.cateImg.image = [UIImage imageNamed:@"option_history1.png"];
 }else if (self.index == 1){
 self.cateImg.image = [UIImage imageNamed:@"option_history2.png"];
 }else{
 self.cateImg.image = [UIImage imageNamed:@"option_history3.png"];
 }

 */
@end

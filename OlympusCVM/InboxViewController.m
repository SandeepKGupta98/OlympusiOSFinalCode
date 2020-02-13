//
//  InboxViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/12/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "InboxViewController.h"
#import "UtilsManager.h"
#import "UIImageView+WebCache.h"
#import "InboxDetailViewController.h"
#import "MFSideMenu.h"

@interface InboxViewController (){
    NSMutableArray *inboxAry;
    NSMutableArray *readInboxIds;
    
}

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    inboxAry = [[NSMutableArray alloc] init];
    self.loaderView.hidden = YES;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    readInboxIds = [[NSUserDefaults standardUserDefaults] valueForKey:@"readInboxIds"];
    if (readInboxIds == nil) {
        readInboxIds = [[NSMutableArray alloc] init];
    }
    [self getInboxFromServer];
}
-(IBAction)menuButtonTapped:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];

}


#pragma mark-  Get Inbox From Servar Method
-(void)getInboxFromServer{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;
    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:Auth_Token_New forKey:Auth_Token_KEY];
    //    [param setObject:[self.type lowercaseString] forKey:@"request_type"];
    [param setObject:[userInfo valueForKey:@"id"] forKey:@"customer_id"];
    
    
    NSString *apiurl;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        apiurl = [NSString stringWithFormat:@"%@/api/v1/promailersLatest",[userData valueForKey:@"testing_url"]];
    }else{
        apiurl = [NSString stringWithFormat:@"%@/api/v1/promailersLatest",base_url];
    }

    [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status"] intValue] == 200) {
//            historyInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
            inboxAry = [NSMutableArray arrayWithArray:[responseDict valueForKey:@"data"]];
            self.inboxCount.text = [NSString stringWithFormat:@"INBOX(%ld)",(long)self->inboxAry.count];
//            self.inboxCount.text = @"INBOX(8888888888888888)";

            [[UtilsManager sharedObject] inboxBadgeWithInbox:inboxAry];

            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
    //    NSString *url = [NSString stringWithFormat:@"%@/api/v1/service/%@?auth_token=%@",[self.type lowercaseString],Auth_Token];
    //
    //    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    //        NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //    }];
}
#pragma mark - UITableView Methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180 ;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return inboxAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[InboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *inboxDict = [inboxAry objectAtIndex:indexPath.row];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:[inboxDict valueForKey:@"created_at"]];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    
    
    cell.dateLbl.text = [dateFormatter stringFromDate:yourDate];
    cell.titleLbl.text = [inboxDict valueForKey:@"title"];
    cell.descLbl.text = [inboxDict valueForKey:@"abbreviation"];
    
    
    if ([readInboxIds containsObject:[inboxDict valueForKey:@"id"]]) {
        cell.inboxNewImg.hidden = YES;
//        cell.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }else{
        cell.inboxNewImg.hidden = NO;
//      cell.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
//        cell.bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    }   
    cell.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];


    [cell.img sd_setImageWithURL:[NSURL URLWithString:[inboxDict valueForKey:@"frontimage"]] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];

    
    
//    abbreviation = AA;
//    "created_at" = "2018-12-10 05:44:38";
//    frontimage = "%@/storage/promailers/download_1543424951_1544381078.jpeg";
//    id = 3;
//    title = Test3;
//    "updated_at" = "2018-12-10 05:44:38";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NSDictionary *inboxDict = [inboxAry objectAtIndex:indexPath.row];

    InboxDetailViewController *inboxDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"inboxDetailVC"];
    inboxDetailVC.mailId = [inboxDict valueForKey:@"id"];
    inboxDetailVC.inboxCount = inboxAry.count;
    
    
    
    
    
    NSMutableArray *readInboxIds = [[[NSUserDefaults standardUserDefaults] objectForKey:@"readInboxIds"] mutableCopy];
    if (readInboxIds == nil) {
        readInboxIds = [[NSMutableArray alloc] init];
    }
    if (![readInboxIds containsObject:[inboxDict valueForKey:@"id"] ]) {
        [readInboxIds addObject:[inboxDict valueForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:readInboxIds forKey:@"readInboxIds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[UtilsManager sharedObject] inboxBadgeWithInbox:[inboxAry copy]];

    
    
    [self.navigationController pushViewController:inboxDetailVC animated:NO];

}

@end

@implementation InboxCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 1.5;
    self.img.layer.cornerRadius = 7;
}
-(IBAction)showDetailBtnTapped:(id)sender{
    
}

@end

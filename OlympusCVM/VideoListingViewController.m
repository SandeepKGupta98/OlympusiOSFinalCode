//
//  VideoListingViewController.m
//  OlympusCVM
//
//  Created by Apple on 02/09/20.
//  Copyright © 2020 Sandeep Kr Gupta. All rights reserved.
//

#import "VideoListingViewController.h"
#import "UIImageView+WebCache.h"
#import "UtilsManager.h"
#import "YoutubePlayerViewController.h"

@interface VideoListingViewController (){
    NSMutableArray *videoAry;
}
    
@end


@implementation VideoListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    videoAry = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getInboxFromServer];
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
            videoAry = [NSMutableArray arrayWithArray:[responseDict valueForKey:@"data"]];
            [self.tableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return videoAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoListCell"];
    if (cell == nil){
        cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoListCell"];
    }
    NSDictionary *videoDict = [videoAry objectAtIndex:indexPath.row];
      NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = [dateFormatter dateFromString:[videoDict valueForKey:@"created_at"]];
        dateFormatter.dateFormat = @"dd MMM yyyy";
        
        
        cell.videoDate.text = [dateFormatter stringFromDate:yourDate];
        cell.videoName.text = [NSString stringWithFormat:@"%@ %@",[videoDict valueForKey:@"title"], [videoDict valueForKey:@"abbreviation"]];
        

        [cell.videoImg sd_setImageWithURL:[NSURL URLWithString:@"https://img.youtube.com/vi/y7Ulq5dvTpo/hqdefault.jpg"] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
//    [videoDict valueForKey:@"frontimage"]

    
////    [cell.videoImg sd_setImageWithURL:[NSURL URLWithString:@"http://i3.ytimg.com/vi/EngW7tLk6R8/maxresdefault.jpg"] placeholderImage:nil];
//    [cell.videoImg sd_setImageWithURL:[NSURL URLWithString:@"https://i.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U"] placeholderImage:nil];
//
//    cell.videoName.text = @"Sample Videos / Dummy Videos For Demo Use";
//    cell.viewCountLbl.text = @"126,334 views";
//    cell.videoDate.text = @"May 11, 2016";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryboard;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    YoutubePlayerViewController *ytPlayer=[mainStoryboard instantiateViewControllerWithIdentifier:@"youtubePlayerVC"];
    [self presentViewController:ytPlayer animated:YES completion:^{}];

}

@end

@implementation VideoListCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end


//videoListCell

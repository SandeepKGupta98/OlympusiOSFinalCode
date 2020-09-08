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
 

#pragma mark- Other Action methods

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark-  Get Inbox From Servar Method
-(void)getInboxFromServer{
    
    
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
    //    https://www.olympusmyvoice.tk/api/v1/videos?auth_token=5c2b9071-a675-49b0-8fb2-9cd894da1c87

            NSString *url = @"https://www.olympusmyvoice.tk/api/v1/videos?auth_token=5c2b9071-a675-49b0-8fb2-9cd894da1c87";
            

            self.loaderView.hidden = NO;
            [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.loaderView.hidden = YES;
                NSLog(@"success! with response: %@", responseObject);
                NSArray *data = [NSArray arrayWithArray:responseObject];
                videoAry = [NSMutableArray arrayWithArray:data];
                [self.tableView reloadData];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                self.loaderView.hidden = YES;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }];
}

-(void)setVideoWatchImpression:(NSDictionary *)videoDict{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat:@"https://www.olympusmyvoice.tk/api/v1/video/%@/%@?auth_token=5c2b9071-a675-49b0-8fb2-9cd894da1c87",[videoDict valueForKey:@"id"], [[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"]];
//    https://www.olympusmyvoice.tk/api/v1/video/2/25?auth_token=5c2b9071-a675-49b0-8fb2-9cd894da1c87
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! with response: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
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
        
        
//        cell.videoDate.text = [dateFormatter stringFromDate:yourDate];
    cell.videoDate.text = [videoDict valueForKey:@"created_at_readable"];
    cell.videoName.text = [videoDict valueForKey:@"title"];
//    [NSString stringWithFormat:@"%@ %@",[videoDict valueForKey:@"title"], [videoDict valueForKey:@"description"]];
    cell.videoDesc.text = [videoDict valueForKey:@"description"];
    cell.viewCountLbl.text = [NSString stringWithFormat:@"%@ Views",[videoDict valueForKey:@"customers_count"]];
    NSString *url = [videoDict valueForKey:@"url"];
    NSString *videoId = [[UtilsManager sharedObject] extractYoutubeIdFromLink:url];
    if (videoId != nil){
        [cell.videoImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg", videoId]] placeholderImage:nil];//y7Ulq5dvTpo
        NSLog(@"%@", [NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg", videoId]);
    }
     
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *videoDict = [videoAry objectAtIndex:indexPath.row];
    NSString *url = [videoDict valueForKey:@"url"];
    NSString *videoId = [[UtilsManager sharedObject] extractYoutubeIdFromLink:url];
    if (videoId){
        UIStoryboard *mainStoryboard;
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        YoutubePlayerViewController *ytPlayer=[mainStoryboard instantiateViewControllerWithIdentifier:@"youtubePlayerVC"];
        ytPlayer.videoId = videoId;
        [self presentViewController:ytPlayer animated:YES completion:^{}];
    }
    [self setVideoWatchImpression:videoDict];

}

@end

@implementation VideoListCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end


//videoListCell

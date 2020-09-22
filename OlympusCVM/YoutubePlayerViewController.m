//
//  YoutubePlayerViewController.m
//  OlympusCVM
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Sandeep Kr Gupta. All rights reserved.
//

#import "YoutubePlayerViewController.h"
//#define SampleVideoURL @"https://www.youtube.com/watch?v=EngW7tLk6R8"
#define SampleVideoURL @"https://www.youtube.com/watch?v=y7Ulq5dvTpo"
@interface YoutubePlayerViewController ()<YTPlayerViewDelegate>{
    UIActivityIndicatorView *activityView;
}

@end

@implementation YoutubePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerView.delegate = self;
    [self.optionView setHidden:YES];

//    NSString *videoId = [[UtilsManager sharedObject] extractYoutubeIdFromLink:SampleVideoURL];
    if (self.videoId) {
        activityView = [[UIActivityIndicatorView alloc] init];
        activityView.layer.cornerRadius = 7;
        
        activityView.center = CGPointMake(self.playerView.center.x, ([[UIScreen mainScreen] bounds].size.width)/2);
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.playerView addSubview:activityView];
        [activityView startAnimating];
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
//                                     @"rel" : @0,
//                                     @"showinfo" : @0,
//                                     @"controls" : @0,
//                                     @"modestbranding": @1,

                                     };
        

//        self.videoId = @"9lEgn8iZhsM";// Unlisted
        [self.playerView loadWithVideoId:self.videoId playerVars:playerVars];
//        self.playerView.backgroundColor = [UIColor redColor];
        
//        [self.playerView cueVideoById:self.videoId startSeconds:0 suggestedQuality:kYTPlaybackQualityAuto];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Invalid Url" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }


}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    [self.playerView playVideo];
    if (activityView != nil) {
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
    [self.optionView setHidden:NO];

    NSLog(@"%lf",_playerView.duration);
    
}


-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state{
    NSLog(@"YTPlayerState: %ld",state);

    switch (state) {
        case kYTPlayerStateUnstarted:
            NSLog(@"kYTPlayerStateUnstarted");
            break;
        case kYTPlayerStateEnded:
//            [_playerView seekToSeconds:0 allowSeekAhead:YES];
//            [_playerView pauseVideo];
            [self hideVC];
            NSLog(@"kYTPlayerStateEnded");
            break;
        case kYTPlayerStatePlaying:
            NSLog(@"kYTPlayerStatePlaying");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"kYTPlayerStatePaused");
            break;
        case kYTPlayerStateBuffering:
            NSLog(@"kYTPlayerStateBuffering");
            break;
        case kYTPlayerStateQueued:
            NSLog(@"kYTPlayerStateQueued");
            break;
        case kYTPlayerStateUnknown:
            NSLog(@"kYTPlayerStateUnknown");
            break;

        default:
            break;
    }
    
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error{
    
    NSString *errorStr = @"";
    
    if (error == kYTPlayerErrorInvalidParam) {
        errorStr = @"kYTPlayerErrorInvalidParam";
    }else if (error == kYTPlayerErrorHTML5Error){
        errorStr = @"kYTPlayerErrorHTML5Error";
    }else if (error == kYTPlayerErrorVideoNotFound){
        errorStr = @"kYTPlayerErrorVideoNotFound";
    }else if (error == kYTPlayerErrorNotEmbeddable){
        errorStr = @"kYTPlayerErrorNotEmbeddable";
        
    }else{
        //        kYTPlayerErrorUnknown
        errorStr = @"kYTPlayerErrorUnknown";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR!" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(UIColor *)playerViewPreferredWebViewBackgroundColor:(YTPlayerView *)playerView{
    return [UIColor redColor];
}
-(void)hideVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)crossButtonTapped:(id)sender{
    [self.playerView stopVideo];
    [self hideVC];
}

- (void)playerView:(nonnull YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality{
    
}

- (void)playerView:(nonnull YTPlayerView *)playerView didPlayTime:(float)playTime{
    NSLog(@"playTime: %f",playTime);
}


@end

//
//  YoutubePlayerViewController.h
//  OlympusCVM
//
//  Created by Apple on 03/09/20.
//  Copyright © 2020 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "UtilsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YoutubePlayerViewController : UIViewController
@property (weak, nonatomic)IBOutlet YTPlayerView *playerView;

@end

NS_ASSUME_NONNULL_END

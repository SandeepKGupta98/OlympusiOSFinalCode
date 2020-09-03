//
//  VideoListingViewController.h
//  OlympusCVM
//
//  Created by Apple on 02/09/20.
//  Copyright © 2020 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoListingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UIView *loaderView;

@end


@interface VideoListCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UIImageView *videoImg;
@property (weak, nonatomic)IBOutlet UILabel *videoName;
@property (weak, nonatomic)IBOutlet UILabel *videoDate;
@property (weak, nonatomic)IBOutlet UILabel *viewCountLbl;
@end

NS_ASSUME_NONNULL_END

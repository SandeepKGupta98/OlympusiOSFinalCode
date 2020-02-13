//
//  SideMenuViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 17/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UtilsManager.h"
#import "FirstTutorialViewController.h"


@interface SideMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic)IBOutlet UITableView *tableView;

@end

@interface SideMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuLbl;


@end

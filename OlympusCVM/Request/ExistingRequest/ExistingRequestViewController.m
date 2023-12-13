//
//  ExistingRequestViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 27/03/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "ExistingRequestViewController.h"
#import "UtilsManager.h"
#import "RemarksViewController.h"
#import "HistoryViewController.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface ExistingRequestViewController ()<ExistingReqCellDelegate>{
    NSArray *reqAry;
    CGFloat cellHgt;
}


@end

@implementation ExistingRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLbl.text = self.superCate;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        cellHgt = 220;
    }else{
        cellHgt = 160;
    }
    
    
    float tableHgt = screen_hgt-([UIApplication sharedApplication].statusBarFrame.size.height+self.tabBarController.tabBar.bounds.size.height+60+40);

    float hgt = (tableHgt-(cellHgt*2))/2;

    if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
        hgt = hgt-25;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, hgt)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    RemarksViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"remarksVC"];
    svc.superCate = [self.superCate uppercaseString];
    [self.navigationController pushViewController:svc animated:NO];

}

- (IBAction)gotoBackView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark- UITableView methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tblView = (UITableView *)scrollView;
    if([tblView isKindOfClass:[UITableView class]]){
        for (int i=0; i<2; i++) {
            ExistingReqCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i ==0 ) {
                cell.bgImage.image = [UIImage imageNamed: @"new_req_w.png"];
            }else{
                cell.bgImage.image = [UIImage imageNamed: @"existing_req_w.png"];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHgt;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    identifier=@"existingReqCell";
    
    ExistingReqCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ExistingReqCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.category = self.superCate;
    
    
    if (indexPath.row ==0 ) {
        cell.bgImage.image = [UIImage imageNamed: @"new_req_w.png"];
    }else{
        cell.bgImage.image = [UIImage imageNamed: @"existing_req_w.png"];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark- ExistingReqCellDelegate

-(void) buttonTappedWithOptionCell:(ExistingReqCell *)cell andIndex:(NSInteger )index{
    [self performSelector:@selector(gotoNextPage:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell",[NSNumber numberWithInteger:index],@"num", nil] afterDelay:0.10];

//    [NSThread sleepForTimeInterval:0.3];


}
-(void)gotoNextPage:(NSDictionary *)dict{
    NSInteger index = [[dict valueForKey:@"num"] integerValue];
    ExistingReqCell *cell = (ExistingReqCell *)[dict valueForKey:@"cell"];
    
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    if(index == 0){
        RemarksViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"remarksVC"];
        svc.superCate = [self.superCate uppercaseString];
        svc.subCate = self.subCate;
        [self.navigationController pushViewController:svc animated:NO];
    }else{
        HistoryViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"historyVC"];
        svc.type = self.superCate;
        svc.showSingleSeg = YES;
        [self.navigationController pushViewController:svc animated:NO];
    }
    if (index ==0 ) {
        cell.bgImage.image = [UIImage imageNamed: @"new_req_w.png"];
    }else{
        cell.bgImage.image = [UIImage imageNamed: @"existing_req_w.png"];
    }
    

}

@end

@implementation ExistingReqCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)buttonTapped:(id)sender{
    if (self.delegate) {
        [self.delegate buttonTappedWithOptionCell:self andIndex:self.index];
    }
}
- (IBAction)buttonTappedTouchDown:(id)sender{
    if (self.index ==0 ) {
        self.bgImage.image = [UIImage imageNamed: @"new_req_y.png"];
    }else{
        self.bgImage.image = [UIImage imageNamed: @"existing_req_y.png"];
    }
}
- (IBAction)touchDragOutside:(id)sender{
    if (self.index ==0 ) {
        self.bgImage.image = [UIImage imageNamed: @"new_req_w.png"];
    }else{
        self.bgImage.image = [UIImage imageNamed: @"existing_req_w.png"];
    }
}
- (IBAction)buttonDragExit:(id)sender{
    
}
- (IBAction)buttonTouchDragInside:(id)sender{
//    if (self.index ==0 ) {
//        self.bgImage.image = [UIImage imageNamed: @"new_req_w.png"];
//    }else{
//        self.bgImage.image = [UIImage imageNamed: @"existing_req_w.png"];
//    }
}


@end

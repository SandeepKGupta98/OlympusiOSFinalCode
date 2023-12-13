//
//  OptionsViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "OptionsViewController.h"
#import "RemarksViewController.h"
#import "ExistingRequestViewController.h"
#import "HistoryViewController.h"

#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface OptionsViewController ()<OptionCellDelegate>{
    CGFloat cellHgt;

}

@end

@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        cellHgt = 220;
    }else{
        cellHgt = 160;
    }
    self.loaderView.hidden = YES;

    float tableHgt = screen_hgt-([UIApplication sharedApplication].statusBarFrame.size.height+self.tabBarController.tabBar.bounds.size.height+60+40);

    
    self.titleLbl.text = [self.superCate uppercaseString];
    self.titleLbl.hidden = YES;
    float hgt = 0;
    if ([self.superCate isEqualToString:@"service"]) {
        hgt = (tableHgt-(cellHgt*2))/2;
    }else if([self.superCate isEqualToString:@"enquiry"]){
        hgt =(tableHgt-(cellHgt*3))/2;
    }else if ([self.superCate isEqualToString:@"academic"]){
        hgt =(tableHgt-(cellHgt*3))/2;
    }else{
        hgt = (tableHgt-(cellHgt))/2;
    }
    
//    if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
//        hgt = hgt-25;
//    }

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, hgt)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableView *tblView = (UITableView *)scrollView;
    if([tblView isKindOfClass:[UITableView class]]){
        int count =0;
        if ([self.superCate isEqualToString:@"service"]) {
            count =2;
        }else if([self.superCate isEqualToString:@"enquiry"]){
            count =3;
        }else if ([self.superCate isEqualToString:@"academic"]){
            count =3;
        }else{
            count =1;
        }

        for (int i=0; i<count; i++) {
            OptionCell *cell = [tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            
            if ([self.superCate isEqualToString:@"service"]) {
                if (i ==0 ) {
                    cell.bgImage.image = [UIImage imageNamed: @"bearkdown_w.png"];
                }else{
                    cell.bgImage.image = [UIImage imageNamed: @"support_w.png"];
                }
            }else if([self.superCate isEqualToString:@"enquiry"]){
                
                if (i ==0 ) {
                    cell.bgImage.image = [UIImage imageNamed: @"info_w.png"];
                }else if (i == 1){
                    cell.bgImage.image = [UIImage imageNamed: @"demonstration_w.png"];
                }else{
                    cell.bgImage.image = [UIImage imageNamed: @"quotation_w.png"];
                }
            }else if ([self.superCate isEqualToString:@"academic"]){
                if (i ==0 ) {
                    cell.bgImage.image = [UIImage imageNamed: @"conference_w.png"];
                }else if (i == 1){
                    cell.bgImage.image = [UIImage imageNamed: @"training_w.png"];
                }else{
                    cell.bgImage.image = [UIImage imageNamed: @"clinical_info_w.png"];
                }
            }else{
                // Installation Request
            }

            
            
//            vcCell.name.textColor = [UIColor whiteColor];
//            vcCell.bgImage.image = [UIImage imageNamed:@"unselected_no_border.png"];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.superCate isEqualToString:@"service"]) {
        return 2;
    }else if([self.superCate isEqualToString:@"enquiry"]){
        return 3;
    }else if ([self.superCate isEqualToString:@"academic"]){
        return 3;
    }else{
        return 1;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHgt;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    identifier=@"optionCell";

    OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.category = self.superCate;
    if ([self.superCate isEqualToString:@"service"]) {
        if (indexPath.row ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"bearkdown_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"support_w.png"];
        }
    }else if([self.superCate isEqualToString:@"enquiry"]){
        
        if (indexPath.row ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"info_w.png"];
        }else if (indexPath.row == 1){
            cell.bgImage.image = [UIImage imageNamed: @"demonstration_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"quotation_w.png"];
        }
    }else if ([self.superCate isEqualToString:@"academic"]){
        if (indexPath.row ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"conference_w.png"];
        }else if (indexPath.row == 1){
            cell.bgImage.image = [UIImage imageNamed: @"training_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"clinical_info_w.png"];
        }

    }else{
        cell.bgImage.image = [UIImage imageNamed: @"installation_req_w.png"];
    }


    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark- OptionCell Delegate methods

-(void) buttonTappedWithOptionCell:(OptionCell *)cell andIndex:(NSInteger )index{

    
    [self performSelector:@selector(gotoNextPage:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell",[NSNumber numberWithInteger:index],@"num", nil] afterDelay:0.10];

    
    
//    cell.bgImage.image = [UIImage imageNamed:@"unselected_no_border.png"];

//    id view = [cell superview];
//    while (view && [view isKindOfClass:[UITableView class]] == NO) {
//        view = [view superview];
//    }
//    UITableView *tableView = (UITableView *)view;

//    if(tableView == self.reqTableView){
//
    
//    [NSThread sleepForTimeInterval:0.3];
 
    
}

-(void)gotoNextPage:(NSDictionary *)dict{
    NSInteger index = [[dict valueForKey:@"num"] integerValue];
    OptionCell *cell = (OptionCell *)[dict valueForKey:@"cell"];

    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    
    
    RemarksViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"remarksVC"];
    svc.superCate = [self.superCate uppercaseString];
    if ([self.superCate isEqualToString:@"service"]) {
        if (index ==0 ) {
            svc.subCate = @"Breakdown Call";
        }else{
            svc.subCate = @"Service Support";
        }
    }else if([self.superCate isEqualToString:@"enquiry"]){
        
        if (index ==0 ) {
            svc.subCate = @"Product Info";
        }else if (index == 1){
            svc.subCate = @"Demonstration";
        }else{
            svc.subCate = @"Quotation";
        }
    }else if ([self.superCate isEqualToString:@"academic"]){
        if (index ==0 ) {
            svc.subCate = @"Conference";
        }else if (index == 1){
            svc.subCate = @"Training";
        }else{
            svc.subCate = @"Clinical Info";
        }

    }else{
        svc.subCate = @"Installation";
    }
    [self.navigationController pushViewController:svc animated:NO];

    
//    ExistingRequestViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"existingRequestVC"];
//    svc.superCate = [self.superCate uppercaseString];
//    if ([self.superCate isEqualToString:@"service"]) {
//        if (index ==0 ) {
//            svc.subCate = @"Breakdown Call";
//        }else{
//            svc.subCate = @"Service Support";
//        }
//    }else if([self.superCate isEqualToString:@"enquiry"]){
//
//        if (index ==0 ) {
//            svc.subCate = @"Product Info";
//        }else if (index == 1){
//            svc.subCate = @"Demonstration";
//        }else{
//            svc.subCate = @"Quotation";
//        }
//    }else{
//        if (index ==0 ) {
//            svc.subCate = @"Conference";
//        }else if (index == 1){
//            svc.subCate = @"Training";
//        }else{
//            svc.subCate = @"Clinical Info";
//        }
//    }
//
//    [self.navigationController pushViewController:svc animated:NO];
    
    if ([self.superCate isEqualToString:@"service"]) {
        if (index ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"bearkdown_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"support_w.png"];
        }
    }else if([self.superCate isEqualToString:@"enquiry"]){
        
        if (index ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"info_w.png"];
        }else if (index == 1){
            cell.bgImage.image = [UIImage imageNamed: @"demonstration_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"quotation_w.png"];
        }
    }else if ([self.superCate isEqualToString:@"academic"]){
        if (index ==0 ) {
            cell.bgImage.image = [UIImage imageNamed: @"conference_w.png"];
        }else if (index == 1){
            cell.bgImage.image = [UIImage imageNamed: @"training_w.png"];
        }else{
            cell.bgImage.image = [UIImage imageNamed: @"clinical_info_w.png"];
        }
    }else{
        cell.bgImage.image = [UIImage imageNamed: @"installation_req_w.png"];
    }
}

#pragma mark- Action button methods

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)gotoThankYouPageWithMsg:(NSString *)msg{
    self.loaderView.hidden = NO;
    [self performSelector:@selector(gotoPage:) withObject:msg afterDelay:1.0];

}

-(void)gotoPage:(NSString *)msg{
    self.loaderView.hidden = YES;
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    ThankYouViewController *tvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"thankYouVC"];
    tvc.msg = msg;
    [self.navigationController pushViewController:tvc animated:NO];
}
@end





@implementation OptionCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)buttonTapped:(id)sender {

    if (self.delegate) {
        [self.delegate buttonTappedWithOptionCell:self andIndex:self.index];
    }
    

}

- (IBAction)buttonTappedTouchDown:(id)sender {
    
    if ([self.category isEqualToString:@"service"]) {
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"bearkdown_y.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"support_y.png"];
        }
    }else if([self.category isEqualToString:@"enquiry"]){
        
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"info_y.png"];
        }else if (self.index == 1){
            self.bgImage.image = [UIImage imageNamed: @"demonstration_y.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"quotation_y.png"];
        }
    }else if ([self.category isEqualToString:@"academic"]){
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"conference_y.png"];
        }else if (self.index == 1){
            self.bgImage.image = [UIImage imageNamed: @"training_y.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"clinical_info_y.png"];
        }
        
    }else{
        self.bgImage.image = [UIImage imageNamed: @"installation_req_y.png"];

    }
}

- (IBAction)touchDragOutside:(id)sender {
    if ([self.category isEqualToString:@"service"]) {
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"bearkdown_w.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"support_w.png"];
        }
    }else if([self.category isEqualToString:@"enquiry"]){
        
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"info_w.png"];
        }else if (self.index == 1){
            self.bgImage.image = [UIImage imageNamed: @"demonstration_w.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"quotation_w.png"];
        }
    }else if ([self.category isEqualToString:@"academic"]){
        if (self.index ==0 ) {
            self.bgImage.image = [UIImage imageNamed: @"conference_w.png"];
        }else if (self.index == 1){
            self.bgImage.image = [UIImage imageNamed: @"training_w.png"];
        }else{
            self.bgImage.image = [UIImage imageNamed: @"clinical_info_w.png"];
        }
    }else{
        self.bgImage.image = [UIImage imageNamed: @"installation_req_w.png"];
    }
}

- (IBAction)buttonDragExit:(id)sender {
    NSLog(@"buttonDragExit");
}


- (IBAction)buttonTouchDragInside:(id)sender {
//    if ([self.category isEqualToString:@"service"]) {
//        if (self.index ==0 ) {
//            self.bgImage.image = [UIImage imageNamed: @"bearkdown_w.png"];
//        }else{
//            self.bgImage.image = [UIImage imageNamed: @"support_w.png"];
//        }
//    }else if([self.category isEqualToString:@"enquiry"]){
//
//        if (self.index ==0 ) {
//            self.bgImage.image = [UIImage imageNamed: @"info_w.png"];
//        }else if (self.index == 1){
//            self.bgImage.image = [UIImage imageNamed: @"demonstration_w.png"];
//        }else{
//            self.bgImage.image = [UIImage imageNamed: @"quotation_w.png"];
//        }
//    }else{
//        if (self.index ==0 ) {
//            self.bgImage.image = [UIImage imageNamed: @"conference_w.png"];
//        }else if (self.index == 1){
//            self.bgImage.image = [UIImage imageNamed: @"training_w.png"];
//        }else{
//            self.bgImage.image = [UIImage imageNamed: @"clinical_info_w.png"];
//        }
//    }
}
@end

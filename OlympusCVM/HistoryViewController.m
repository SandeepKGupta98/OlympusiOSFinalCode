//
//  HistoryViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 24/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "HistoryViewController.h"
#import "StatusViewController.h"
#import "UtilsManager.h"
#import "RequestEscalationViewController.h"
#import "MFSideMenu/MFSideMenu.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)
#define yellow_color ([UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0])
#define blue_color ([UIColor colorWithRed:87/255.0 green:125/255.0 blue:234/255.0 alpha:1.0])
#define orange_color ([UIColor colorWithRed:245/255.0 green:125/255.0 blue:60/255.0 alpha:1.0])


@interface HistoryViewController ()<HistoryCellDelegate, ClosedReqCellDelegate>{
    NSMutableArray *historyAry;
    NSMutableArray *flagAry;
    NSMutableArray *ongoingAry;
    NSMutableArray *closedAry;

    NSDictionary *historyInfo;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loaderView.hidden = YES;
    if (self.showSingleSeg == YES) {
        self.onGoingLbl.hidden  = NO;
        self.onGoingLblView.hidden  = NO;
        
    }else{
        self.onGoingLbl.hidden  = YES;
        self.onGoingLblView.hidden  = YES;
    }

    _titleLbl.text = @"HISTORY";
    [self.segmentCntrl setTitle:@"ON GOING" forSegmentAtIndex:0];
    [self.segmentCntrl setTitle:@"CLOSED" forSegmentAtIndex:1];
    
//    if ([[self.type lowercaseString] isEqualToString:@"service"]) {
//        [self.segmentCntrl setTitle:@"ON GOING" forSegmentAtIndex:0];
//        [self.segmentCntrl setTitle:@"CLOSED" forSegmentAtIndex:1];
//    }else{
//        [self.segmentCntrl setTitle:@"ON GOING" forSegmentAtIndex:0];
//        [self.segmentCntrl setTitle:@"ASSIGNED" forSegmentAtIndex:1];
//    }
    

    
    
    historyAry = [[NSMutableArray alloc] init];
    flagAry = [[NSMutableArray alloc] init];

    
    

    [self.segmentCntrl setTitleTextAttributes:@{
                                                NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0],
                                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                                } forState:UIControlStateNormal];
    [self.segmentCntrl setTitleTextAttributes:@{
                                                NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0],
                                                NSForegroundColorAttributeName:[UIColor whiteColor]
                                                } forState:UIControlStateSelected];

    
    self.segmentCntrl.layer.cornerRadius = 7.0;
    self.segmentCntrl.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.segmentCntrl.layer.borderWidth = 1.0f;
    self.segmentCntrl.layer.masksToBounds = YES;

    self.onGoingLbl.layer.cornerRadius = 7.0;
    self.onGoingLbl.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.onGoingLbl.layer.borderWidth = 1.0f;
    self.onGoingLbl.layer.masksToBounds = YES;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRequestHistoryFromServer];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//type
#pragma mark-  Header Footer Method
-(void)getRequestHistoryFromServer{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;
    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:Auth_Token_New forKey:Auth_Token_KEY];
//    [param setObject:[self.type lowercaseString] forKey:@"request_type"];
    [param setObject:[userInfo valueForKey:@"id"] forKey:@"customer_id"];//1626

    
    NSString *url;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/api/v1/getRequestsHistory",[userData valueForKey:@"testing_url"]];
    }else{
        url = [NSString stringWithFormat:@"%@/api/v1/getRequestsHistory",base_url];
    }

    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status"] intValue] == 200) {
            historyInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"history"]];
            ongoingAry = [NSMutableArray arrayWithArray:[historyInfo valueForKey:@"ongoingAry"]];
            closedAry = [NSMutableArray arrayWithArray:[historyInfo valueForKey:@"closedAry"]];
            
            [historyAry removeAllObjects];
            [flagAry removeAllObjects];

            if (_segmentCntrl.selectedSegmentIndex == 0) {
                for (int i=0; i<ongoingAry.count; i++) {
                    [historyAry addObject:[ongoingAry objectAtIndex:i]];
                    [flagAry addObject:[NSNumber numberWithBool:NO]];
                }
            }else{
                for (int i=0; i<closedAry.count; i++) {
                    [historyAry addObject:[closedAry objectAtIndex:i]];
                    [flagAry addObject:[NSNumber numberWithBool:NO]];
                }
            }

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
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            return 370;
        }else{
            return 190;
        }
    }else{
        
        if (self.segmentCntrl.selectedSegmentIndex == 0 ) {
            if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
                return 183;//200
            }else{
                return 89;//135
            }
        }else{
            if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
                return 155;//170;
            }else{
                return 89;//105;
            }
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historyAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentCntrl.selectedSegmentIndex == 0 ) {
        HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
        if (cell == nil) {
            cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
        }
        cell.delegate = self;
        cell.index = indexPath.row;
        
        NSDictionary *reqInfo = [historyAry objectAtIndex:indexPath.row];
        UIColor *type_color;
        if ([[[reqInfo valueForKey:@"request_type"]lowercaseString] isEqualToString:@"service"]) {
            type_color = yellow_color;
            cell.typeIcon.image = [UIImage imageNamed:@"service_icon"];
        }else if ([[[reqInfo valueForKey:@"request_type"]lowercaseString] isEqualToString:@"enquiry"]){
            type_color = blue_color;
            cell.typeIcon.image = [UIImage imageNamed:@"enquiry_icon"];
        }else{
            type_color = orange_color;
            cell.typeIcon.image = [UIImage imageNamed:@"academic_icon"];
        }
        
        cell.bgView.layer.borderColor = type_color.CGColor;
        cell.statusTitle.textColor = type_color;
        cell.reqTypeTitle.textColor = type_color;
        cell.remarkTitle.textColor = type_color;
        cell.line1.backgroundColor = type_color;
        cell.line2.backgroundColor = type_color;
        cell.line3.backgroundColor = type_color;
        cell.detailBtn.backgroundColor = type_color;

        if (![[reqInfo valueForKey:@"cvm_id"] isKindOfClass:[NSNull class]]) {//request_type : "service"
            NSMutableAttributedString *reqNo = [[UtilsManager sharedObject] getMutableStringWithString:[[reqInfo valueForKey:@"request_type"] capitalizedString] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:type_color lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            [reqNo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" : %@",[[[reqInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
            cell.requestNo.attributedText = reqNo;
            
            
//            cell.requestNo.text = [NSString stringWithFormat:@"%@ : Request No %@",[[reqInfo valueForKey:@"request_type"] capitalizedString],[[[reqInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]];
        }else{
            cell.requestNo.text = @"";
        }
        if (![[reqInfo valueForKey:@"status"] isKindOfClass:[NSNull class]]) {
            NSString *status = [reqInfo valueForKey:@"status"];
            status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];

            
            if ([[status lowercaseString] isEqualToString:@"received"]||[[status lowercaseString] isEqualToString:@"assigned"]||[[status lowercaseString] isEqualToString:@"re-assigned"]||[[status lowercaseString] isEqualToString:@"closed"]||[[status lowercaseString] isEqualToString:@"request closed"]) {
                cell.requestStatus.text = [NSString stringWithFormat:@"Request %@",status];
            }else{
                cell.requestStatus.text = [NSString stringWithFormat:@"%@",status];
            }

            
        }else{
            cell.requestStatus.text = @"";
        }
        if (![[reqInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
            cell.remark.text =  [reqInfo valueForKey:@"remarks"];
        }else{
            cell.remark.text = @"";
        }
        
//        cell.receivedOn.text = [reqInfo valueForKey:@"created_at"];
        
        NSString *myString = [reqInfo valueForKey:@"created_at"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = [dateFormatter dateFromString:myString];
        dateFormatter.dateFormat = @"dd MMM yyyy h:mm a";
        cell.receivedOn.text = [dateFormatter stringFromDate:yourDate];

//        NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);


        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.bgView.layer.masksToBounds = NO;
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
            cell.requestStatus.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.requestNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.remark.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.receivedOn.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            
            cell.statusTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.remarkTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.reqTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            
//            cell.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
            cell.bgView.layer.borderWidth = 1.5;
            cell.shadowView.hidden = NO;
            
            
            
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.020, 1.020);
            }completion:^(BOOL finished){
            }];
            
            
            
            CALayer *layer = [[CALayer alloc] init];
            layer.frame = cell.bgView.bounds;
            //        layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
            layer.borderColor = [[UIColor whiteColor] CGColor];
            layer.borderWidth = 1.5;
            //        layer.shadowColor=[[UIColor redColor] CGColor];
            //        layer.shadowOffset = CGSizeMake(0, 0);
            //        layer.shadowRadius = 5;
            //        layer.shadowOpacity = 1;
            layer.masksToBounds = NO;
            
            layer.shadowColor = [[UIColor greenColor] CGColor];
            layer.shadowOffset = CGSizeMake(5.0, 5.0);
            layer.shadowOpacity = 1.0;
            layer.shadowRadius = 3.0;
            
            
            
            //        [cell.bgView.layer addSublayer:layer];
            
        }else{
//            cell.bgView.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
            cell.bgView.layer.borderWidth = 1.5;
            //        cell.bgView.layer.masksToBounds = YES;
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
            
            cell.requestStatus.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.requestNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.remark.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.receivedOn.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.statusTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.remarkTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            cell.reqTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];//15
            
            
            
            cell.shadowView.hidden = YES;
            
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.bgView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished){
            }];
            
            
        }
        
//        if ([[self.type lowercaseString] isEqualToString:@"service"]) {
//            cell.escalationWdth.constant = (screen_wdth-60)/2;
//        }else{
//            cell.escalationWdth.constant = 0;
//        }
        cell.escalationWdth.constant = (screen_wdth-60)/2;

        cell.bgView.clipsToBounds = YES;
        
//
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        ClosedReqCell *cell = [tableView dequeueReusableCellWithIdentifier:@"closedCell"];
        if (cell == nil) {
            cell = [[ClosedReqCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"closedCell"];
        }
        cell.delegate = self;
        cell.index = indexPath.row;
        
        cell.escalationBtnWidth.constant = 0;
        NSDictionary *reqInfo = [historyAry objectAtIndex:indexPath.row];

        UIColor *type_color;
        if ([[[reqInfo valueForKey:@"request_type"]lowercaseString] isEqualToString:@"service"]) {
            type_color = yellow_color;
            cell.typeIcon.image = [UIImage imageNamed:@"service_icon"];
        }else if ([[[reqInfo valueForKey:@"request_type"]lowercaseString] isEqualToString:@"enquiry"]){
            type_color = blue_color;
            cell.typeIcon.image = [UIImage imageNamed:@"enquiry_icon"];
        }else{
            type_color = orange_color;
            cell.typeIcon.image = [UIImage imageNamed:@"academic_icon"];
        }
        cell.bgView.layer.borderColor = type_color.CGColor;
        cell.reqTypeTitle.textColor = type_color;
        cell.remarkTitle.textColor = type_color;
        cell.line1.backgroundColor = type_color;
        cell.line2.backgroundColor = type_color;
        cell.detailBtn.backgroundColor = type_color;

        if (![[reqInfo valueForKey:@"cvm_id"] isKindOfClass:[NSNull class]]) {
            
            NSMutableAttributedString *reqNo = [[UtilsManager sharedObject] getMutableStringWithString:[[reqInfo valueForKey:@"request_type"] capitalizedString] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:type_color lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            [reqNo appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@" : %@",[[[reqInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
            cell.requestNo.attributedText = reqNo;

            
            
//            cell.requestNo.text = [NSString stringWithFormat:@"%@ : Request No %@",[[reqInfo valueForKey:@"request_type"] capitalizedString],[[[reqInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]];

        }else{
            cell.requestNo.text = @"";
        }
        
        if (![[reqInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
            cell.remark.text =  [reqInfo valueForKey:@"remarks"];
        }else{
            cell.remark.text = @"";
        }
        NSString *myString = [reqInfo valueForKey:@"created_at"];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *yourDate = [dateFormatter dateFromString:myString];
        dateFormatter.dateFormat = @"dd MMM yyyy h:mm a";
        cell.receivedOn.text = [dateFormatter stringFromDate:yourDate];

        
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.bgView.layer.masksToBounds = NO;
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
            cell.requestNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.remark.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.receivedOn.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.remarkTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.reqTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
//            cell.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
            cell.bgView.layer.borderWidth = 1.5;
            cell.shadowView.hidden = NO;
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.bgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.020, 1.020);
            }completion:^(BOOL finished){
            }];
            
            
            
            CALayer *layer = [[CALayer alloc] init];
            layer.frame = cell.bgView.bounds;
            //        layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
            layer.borderColor = [[UIColor whiteColor] CGColor];
            layer.borderWidth = 1.5;
            //        layer.shadowColor=[[UIColor redColor] CGColor];
            //        layer.shadowOffset = CGSizeMake(0, 0);
            //        layer.shadowRadius = 5;
            //        layer.shadowOpacity = 1;
            layer.masksToBounds = NO;
            
            layer.shadowColor = [[UIColor greenColor] CGColor];
            layer.shadowOffset = CGSizeMake(5.0, 5.0);
            layer.shadowOpacity = 1.0;
            layer.shadowRadius = 3.0;
            
            
            
            //        [cell.bgView.layer addSublayer:layer];
            
        }else{
//            cell.bgView.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
            cell.bgView.layer.borderWidth = 1.5;
            //        cell.bgView.layer.masksToBounds = YES;
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
            cell.requestNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.remark.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.receivedOn.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.remarkTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.reqTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
            cell.shadowView.hidden = YES;
            [UIView animateWithDuration:0.3/2 animations:^{
                cell.bgView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished){
            }];
        }
        
        
        
        if ([[self.type lowercaseString] isEqualToString:@"service"]) {
            cell.reqTypeTitle.text = @"Closed on : ";
        }else{
            cell.reqTypeTitle.text = @"Assigned on : ";
        }

        cell.bgView.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    for (int i=0; i<20; i++) {
//        if (i == indexPath.row) {
//            BOOL flag = ![[flagAry objectAtIndex: indexPath.row] boolValue];
//            [flagAry replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:flag]];
//        }else{
//            [flagAry replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
//        }
//    }
//    [_tableView reloadData];
    
    
    /*********************************************************************************************/

    
    NSMutableArray *indexpathAry = [[NSMutableArray alloc] init];
    [indexpathAry addObject:indexPath];

    BOOL flag = ![[flagAry objectAtIndex: indexPath.row] boolValue];

    for (int i=0; i<historyAry.count; i++) {
        if ([[flagAry objectAtIndex: i] boolValue]) {
            [indexpathAry addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [flagAry replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }

    [flagAry replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:flag]];
//    [_tableView reloadData];
    [_tableView reloadRowsAtIndexPaths:indexpathAry withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - HistoryCellDelegate Methods

-(void)escalationButtonTappedWithCell:(HistoryCell *)cell andIndex:(NSInteger)index{
    
    if ([[[historyAry objectAtIndex:index] valueForKey:@"is_escalated"] intValue] == 1) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Escalation" message:@"Your request has already been escalated. Please allow us some time to resolve the issue before your escalate again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Escalation" message:@"Are you sure you want to escalate request?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *mainStoryboard;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            }else{
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            }
            RequestEscalationViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"requestEscalationVC"];
            svc.reqType = self.type;
            
            svc.reqId = [[historyAry objectAtIndex:index] valueForKey:@"id"];
            [self.navigationController pushViewController:svc animated:NO];
            
        }];
        [alert addAction:yes];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:no];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

    // Show Popup With Full Description...
//    self.popupView.hidden = NO;
}
-(void)detailButtonTappedWithCell:(HistoryCell *)cell andIndex:(NSInteger)index{
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    StatusViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
    svc.type = self.type;
    svc.fromNotification = NO;
    svc.requestInfo = [NSDictionary dictionaryWithDictionary:[historyAry objectAtIndex:index]];

    if (self.segmentCntrl.selectedSegmentIndex == 0) {
        svc.showEngineerInfo = YES;
    }else{
        svc.showEngineerInfo = NO;
    }
    
    [self.navigationController pushViewController:svc animated:NO];
}


#pragma mark - ClosedReqCellDelegate Methods
-(void)escalationButtonTapped:(ClosedReqCell *)cell andIndex:(NSInteger) index{
    
    
    if ([[[historyAry objectAtIndex:index] valueForKey:@"is_escalated"] intValue] == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Escalation" message:@"Your request has already been escalated. Please allow us some time to resolve the issue before your escalate again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Escalation" message:@"Are you sure you want to escalate request?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *mainStoryboard;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            }else{
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            }
            RequestEscalationViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"requestEscalationVC"];
            svc.reqId = [[historyAry objectAtIndex:index] valueForKey:@"id"];
            svc.reqType = self.type;
            [self.navigationController pushViewController:svc animated:NO];
            
        }];
        [alert addAction:yes];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:no];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

-(void)detailButtonTapped:(ClosedReqCell *)cell andIndex:(NSInteger) index{
    UIStoryboard *mainStoryboard;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    StatusViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"statusVC"];
    svc.type = self.type;
    svc.requestInfo = [NSDictionary dictionaryWithDictionary:[historyAry objectAtIndex:index]];
    [self.navigationController pushViewController:svc animated:NO];
}

#pragma mark - Other Methods



- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    NSLog(@"Index: %ld",sender.selectedSegmentIndex);
//    for (int i=0; i<20; i++) {
//        [flagAry replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
//    }
    [historyAry removeAllObjects];
    [flagAry removeAllObjects];

    if (sender.selectedSegmentIndex == 0) {
        for (int i=0; i<ongoingAry.count; i++) {
            [historyAry addObject:[ongoingAry objectAtIndex:i]];
            [flagAry addObject:[NSNumber numberWithBool:NO]];
        }
    }else{
        for (int i=0; i<closedAry.count; i++) {
            [historyAry addObject:[closedAry objectAtIndex:i]];
            [flagAry addObject:[NSNumber numberWithBool:NO]];
        }
    }

    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)backButtonTapped:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
}

@end



@implementation HistoryCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
//    CALayer *layer = [[CALayer alloc] init];
//    layer.frame = cell.bgView.bounds;
//    self.shadowView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];//[UIColor colorWithWhite:0 alpha:0.7]
    self.shadowView.layer.borderWidth = 1.5;
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.shadowColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
//    self.shadowView.layer.shadowColor = [[UIColor colorWithRed:8/255.0 green:16/255.0 blue:123/255.0 alpha:1.0] CGColor];
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    self.shadowView.layer.shadowOpacity = 1.0;
    self.shadowView.layer.shadowRadius = 5.0;

    
    
    
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.statusBtn.layer.cornerRadius = 10;
        self.statusBtn.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
        self.statusBtn.layer.borderWidth = 1;
        
        self.detailBtn.layer.cornerRadius = 10;
        self.detailBtn.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
        self.detailBtn.layer.borderWidth = 1;
        
        self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.cornerRadius = 10;
    }else{
//        self.statusBtn.layer.cornerRadius = 7;
//        self.statusBtn.layer.borderColor = [[UIColor colorWithRed:233/255.0 green:177/255.0 blue:35/255.0 alpha:1.0] CGColor];
//        self.statusBtn.layer.borderWidth = 1;
//
//        self.detailBtn.layer.cornerRadius = 7;
//        self.detailBtn.layer.borderColor = [[UIColor colorWithRed:233/255.0 green:177/255.0 blue:35/255.0 alpha:1.0] CGColor];
//        self.detailBtn.layer.borderWidth = 1;
        
        self.bgView.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
        self.bgView.layer.borderWidth = 0.5;
        self.shadowView.layer.cornerRadius = 7;

        self.bgView.layer.cornerRadius = 7;
    }

}
- (IBAction)statusBtnTapped:(id)sender {
    if (self.delegate) {
        [self.delegate escalationButtonTappedWithCell:self andIndex:self.index];
    }
}

- (IBAction)detailsBtnTapped:(id)sender {
    if (self.delegate) {
        [self.delegate detailButtonTappedWithCell:self andIndex:self.index];
    }
}

- (IBAction)statusBtnTouchDown:(id)sender {
}

- (IBAction)detailBtnTouchDown:(id)sender {
}
@end


@implementation ClosedReqCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 0.5;
    self.shadowView.layer.cornerRadius = 7;
    self.bgView.layer.cornerRadius = 7;

}
- (IBAction)detailButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate detailButtonTapped:self andIndex:self.index];
    }
}

- (IBAction)escalationButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate escalationButtonTapped:self andIndex:self.index];
    }
}
@end

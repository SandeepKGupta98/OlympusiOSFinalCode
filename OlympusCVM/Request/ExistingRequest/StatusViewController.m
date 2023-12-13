//
//  StatusViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 10/01/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "StatusViewController.h"
#import "UtilsManager.h"
#import <MessageUI/MessageUI.h>
#import "FeedbackViewController.h"
#import "UIImageView+WebCache.h"
#import "PDFReaderViewController.h"

#define yellow_color ([UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0])
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface StatusViewController ()<MFMailComposeViewControllerDelegate,FeedbackViewControllerDelegate,EmployeeCellDelegate>{
    NSMutableArray *timelineAry;
    NSMutableArray *fseAry;
    float excutiveY;
    
    NSMutableArray *sectionAry;
    NSMutableArray *flagAry;

}

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    excutiveY = 0;
    self.scrollView.layer.cornerRadius = 7;
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.loaderView.hidden = YES;
    flagAry = [[NSMutableArray alloc] init];
    sectionAry = [[NSMutableArray alloc] init];
    
    self.statusTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.fromNotification) {
        [self getRequestData];
    }else{
        [sectionAry addObject:@"Request Summary"];
        NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
        if (escalatedAry.count!=0) {
            [sectionAry addObject:@"Escalation"];
        }
        [sectionAry addObject:@"Employee Profile"];
        [sectionAry addObject:@"Timeline"];
        
        if ([[[self.requestInfo valueForKey:@"request_type"] lowercaseString] isEqualToString:@"service"]) {
            if ([self.requestInfo valueForKey:@"product_info"]) {
                NSArray *product_info = [self.requestInfo valueForKey:@"product_info"];
                if (product_info.count) {
                    [sectionAry addObject:@"Product Information"];
                }
            }
            if ([self.requestInfo valueForKey:@"technical_report"]) {
                NSArray *product_info = [self.requestInfo valueForKey:@"technical_report"];
                if (product_info.count) {
                    [sectionAry addObject:@"Technical Report"];
                }
            }
        }

        if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
            if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
                NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
                if (feedbackAry.count) {
                    [sectionAry addObject:@"Feedback"];
                }
            }
        }
//

        
        for (int i =0; i<sectionAry.count; i++) {
//            if(i == [sectionAry indexOfObject:@"Employee Profile"]){
//                [flagAry addObject:[NSNumber numberWithBool:YES]];
//            }else{
                [flagAry addObject:[NSNumber numberWithBool:NO]];
//            }
        }

        [self createFooterView];
//        [self createScrollViewSubView];
    }
}
-(void)getRequestData{
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *access_token = [userInfo valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

    
    
    NSString *url;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        url = [NSString stringWithFormat:@"%@/api/v2/service/%@?auth_token=%@",[userData valueForKey:@"testing_url"],self.reqId,Auth_Token];
    }else{
        url = [NSString stringWithFormat:@"%@/api/v2/service/%@?auth_token=%@",base_url,self.reqId,Auth_Token];
    }
    

    
    self.loaderView.hidden = NO;
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            self.requestInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
            [self createFooterView];
            
            
            [sectionAry addObject:@"Request Summary"];
            NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
            if (escalatedAry.count!=0) {
                [sectionAry addObject:@"Escalation"];
            }
            [sectionAry addObject:@"Employee Profile"];
            [sectionAry addObject:@"Timeline"];
            
            if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
                if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
                    NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
                    if (feedbackAry.count) {
                        [sectionAry addObject:@"Feedback"];
                    }
                }
            }
            
            
            for (int i =0; i<sectionAry.count; i++) {
                if(i == [sectionAry indexOfObject:@"Employee Profile"]){
                    [flagAry addObject:[NSNumber numberWithBool:YES]];
                }else{
                    [flagAry addObject:[NSNumber numberWithBool:NO]];
                }
            }

            
            
            
            
            
            
            [self.statusTableView reloadData];
//            [self createScrollViewSubView];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"data"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        self.loaderView.hidden = YES;

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];

    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)gotoBackPage:(id)sender {
    if (self.fromNotification) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }

}


#pragma mark- UITableView Methods

-(void)createFooterView{
    _footerView.frame = CGRectMake(0, 0, screen_wdth, 0);
    if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
        if ([[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
            _footerView.frame = CGRectMake(0, 0, screen_wdth, 80);
        }
    }

//    self.footerView.backgroundColor = [UIColor cyanColor];
    self.statusTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.statusTableView.tableFooterView = self.footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            return 370;
        }else{
            return 190;
        }
    }else{
        
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            
//            sectionAry = [[NSMutableArray alloc] initWithObjects:@"Request Summary",@"Employee Profile",@"Escalation",@"Timeline",@"Feedback", nil];

            NSString *sec = [sectionAry objectAtIndex:indexPath.row];
            
            if ([sec isEqualToString:@"Request Summary"]) {//indexPath.row == 0
                if ([[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]] || [self.requestInfo valueForKey:@"remarks"] == nil) {
                    return 248+30;
                }else{
                    NSAttributedString *str = [[UtilsManager sharedObject] getMutableStringWithString:[self.requestInfo valueForKey:@"remarks"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                    float hgt = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-145]+10;
                    if (hgt<30) {
                        return 248+30;
                    }
                    return 248+hgt;
                }
            }else if ([sec isEqualToString:@"Employee Profile"]){//indexPath.row == 1
                
                NSAttributedString *olyStr = [[UtilsManager sharedObject] getMutableStringWithString:@"Olympus Medical Systems India\nGround Floor, Tower- C, SAS Tower, The Medicity Complex Sector – 38, Gurgaon – 122001, Haryana, India\nContact : 1800 102 3654\n\n" font:[UIFont fontWithName:@"EncodeSansNormal" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];//\nSales Enquiry : endosale.omsi@olympus-ap.com\n\nService Enquiry : endoservice.omsi@olympus-ap.com\n

                olyStr = [[UtilsManager sharedObject] getMutableStringWithString:@"" font:[UIFont fontWithName:@"EncodeSansNormal" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];//\nSales Enquiry : endosale.omsi@olympus-ap.com\n\nService Enquiry : endoservice.omsi@olympus-ap.com\n
                float olyStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:olyStr withWidth:screen_wdth-76]+10;
                olyStrHgt = 130;
                if ([[self.requestInfo valueForKey:@"fseAry"] count]>0) {
                    float empHgt = 210;
                    
                    return empHgt+olyStrHgt+30;

//                    return 400+65;
                }else{
                    return olyStrHgt+41+30;// 41 title hgt
//                    return 296+65;
                    // employee bg Hgt 145
                }
            }else if ([sec isEqualToString:@"Timeline"]){//indexPath.row == 2
                float hgt = 50;
                if ([self.requestInfo valueForKey:@"timelineAry"]) {
                    hgt=hgt+42+40*[[self.requestInfo valueForKey:@"timelineAry"] count];
                }
                
                NSDictionary *request_progress = [self.requestInfo valueForKey:@"request_progress"];
                if ([[request_progress valueForKey:@"pending_statuses"] isKindOfClass:[NSArray class]]) {
                    
                    hgt = hgt+40*[[request_progress valueForKey:@"pending_statuses"] count];
                }
                return hgt;
//                else{
//                    return 50;
//                }
            }else if ([sec isEqualToString:@"Escalation"]){
                NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
                
                float hgt=10;
                int escalation_count = (int)escalatedAry.count;
                NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"escalation_level" ascending:NO];
                NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
                escalatedAry = [escalatedAry sortedArrayUsingDescriptors:sortDescriptors];
                
                if (escalatedAry.count) {
                    for (int i=0; i<escalation_count; i++) {
                        NSDictionary *escalatedInfo = [escalatedAry objectAtIndex:i];
                        hgt=hgt+25;
                        hgt=hgt+100;
                        NSString *escalatedStr = @"";
                        if ([[escalatedInfo valueForKey:@"escalation_level"] intValue] != 1) {
                            escalatedStr = [NSString stringWithFormat:@"Email id : %@\nDesignation : %@",[escalatedInfo valueForKey:@"email"],[escalatedInfo valueForKey:@"designation"]];
                        }else{
                            NSString *mobile = @"";
                            if (![[escalatedInfo valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                                mobile = [escalatedInfo valueForKey:@"mobile"];
                            }
                            escalatedStr = [NSString stringWithFormat:@"Mobile : %@\nEmail id : %@\nDesignation : %@",mobile,[escalatedInfo valueForKey:@"email"],[escalatedInfo valueForKey:@"designation"]];
                        }

                        NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalatedStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                        CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80]+10;
                        hgt=hgt+escalatedContactValueHgt;
                        hgt=hgt+10;
                    }
                    hgt=hgt+50;// for heading

                    
                    NSString *escalation_reasons_str =  [[UtilsManager sharedObject] removeNullFromString:[self.requestInfo valueForKey:@"escalation_reasons"]];
                    escalation_reasons_str =  [escalation_reasons_str stringByReplacingOccurrencesOfString:@"," withString:@"\n\n• "];
                    escalation_reasons_str = [NSString stringWithFormat:@"• %@",escalation_reasons_str];
                    if (escalation_reasons_str.length) {
                        NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalation_reasons_str font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                        CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80];
                        hgt=hgt+escalatedContactValueHgt+10;
                    }
                    
                    NSString *escalation_remarks = [[UtilsManager sharedObject] removeNullFromString:[self.requestInfo valueForKey:@"escalation_remarks"]];
                    if (escalation_remarks.length) {
                        NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalation_remarks font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                        CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80];
                        hgt=hgt+escalatedContactValueHgt+10;

                    }

                }
                return 41+hgt;

                
            }else if ([sec isEqualToString:@"Product Information"]){
                return 173;

            }else if ([sec isEqualToString:@"Technical Report"]){
                
                NSArray *techReportAry = [self.requestInfo valueForKey:@"technical_report"];
                float hgt=50;
                if (techReportAry.count) {
                    hgt = hgt+10;
                }
                for (int i=0; i<techReportAry.count; i++) {
                    hgt+=60;
                }

                return hgt;

            }else if ([sec isEqualToString:@"Feedback"]){//indexPath.row == 2
                
                float hgt = 0;
                if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
                    NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
                    if (feedbackAry.count) {
                        NSDictionary *feedbackDict = [[self.requestInfo valueForKey:@"feedback"] firstObject];
                        if (![[feedbackDict valueForKey:@"remarks"] isKindOfClass:[NSNull class]]||[feedbackDict valueForKey:@"remarks"] != nil) {
                            NSAttributedString *str = [[UtilsManager sharedObject] getMutableStringWithString:[feedbackDict valueForKey:@"remarks"] font:[UIFont fontWithName:@"EncodeSansNormal" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                            hgt = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-80];
                        }
                        
                    }
                }
                
                
                return 345+hgt;

            }
            
            //80
            return 400;//380
        }else{
            return 50;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sectionAry.count;
//    NSInteger rowCount = 3;
//    if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
//        if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
//            NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
//            if (feedbackAry.count) {
//                rowCount ++;
////                return flagAry.count;
//            }
//        }
//    }
//    NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
//    if (escalatedAry.count==0) {
//        rowCount ++;
//    }
//
//    return rowCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sec = [sectionAry objectAtIndex:indexPath.row];
    if ([sec isEqualToString:@"Request Summary"]) {
        RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell"];
        if (cell == nil) {
            cell = [[RequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestCell"];
        }
        cell.reqNum.text = @"";
        if (![[self.requestInfo valueForKey:@"cvm_id"] isKindOfClass:[NSNull class]]) {
            cell.reqNum.text = [[[self.requestInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject];
        }

        if (![[self.requestInfo valueForKey:@"request_type"] isKindOfClass:[NSNull class]]) {
            cell.reqType.text = [[self.requestInfo valueForKey:@"request_type"] capitalizedString];
        }

        if (![[self.requestInfo valueForKey:@"sub_type"] isKindOfClass:[NSNull class]]) {
            cell.reqNature.text = [[self.requestInfo valueForKey:@"sub_type"] capitalizedString];
        }
        
        if (![[self.requestInfo valueForKey:@"hospital_name"] isKindOfClass:[NSNull class]]) {
            cell.hosName.text = [[self.requestInfo valueForKey:@"hospital_name"] capitalizedString];
        }
        
        if (![[self.requestInfo valueForKey:@"dept_name"] isKindOfClass:[NSNull class]]) {
            cell.depName.text = [[self.requestInfo valueForKey:@"dept_name"] capitalizedString];
        }
        
        if (![[self.requestInfo valueForKey:@"status"] isKindOfClass:[NSNull class]]) {
            

            cell.status.text = [[self.requestInfo valueForKey:@"status"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        }
        
        if (![[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
            cell.remark.text = [self.requestInfo valueForKey:@"remarks"];
        }
        
        cell.remarkHgt.constant = 0;
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            if ([[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]] || [self.requestInfo valueForKey:@"remarks"] == nil) {
                cell.remarkHgt.constant = 0;
            }else{
                NSAttributedString *str = [[UtilsManager sharedObject] getMutableStringWithString:[self.requestInfo valueForKey:@"remarks"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                float hgt = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-145]+10;
                if (hgt<30) {
                    cell.remarkHgt.constant = 30;
                }
                cell.remarkHgt.constant = hgt;
            }
        }
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }


        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([sec isEqualToString:@"Employee Profile"]) {
        EmployeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"employeeCell"];
        if (cell == nil) {
            cell = [[EmployeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"employeeCell"];
        }
        
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            if ([[self.requestInfo valueForKey:@"fseAry"] count]>0) {
                fseAry = [NSMutableArray arrayWithArray:[self.requestInfo valueForKey:@"fseAry"]];
                [cell.empImg sd_setImageWithURL:[NSURL URLWithString:[[fseAry firstObject] valueForKey:@"employee_image"]] placeholderImage:[UIImage imageNamed:@"employee_image.jpg"]];
                if (![[[fseAry firstObject] valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
                    cell.empName.text = [[fseAry firstObject] valueForKey:@"name"];
                }
                if (![[[fseAry firstObject] valueForKey:@"email"] isKindOfClass:[NSNull class]]) {
                    cell.empEmail.text = [[fseAry firstObject] valueForKey:@"email"];
                }
                if (![[[fseAry firstObject] valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                    cell.empNum.text = [[fseAry firstObject] valueForKey:@"mobile"];
                }
                cell.empViewHgt.constant = 170+41;//145+65;
                
            }else{
                cell.empViewHgt.constant = 41;
            }
        }

        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }

//        @property (weak, nonatomic) IBOutlet NSLayoutConstraint *empViewHgt;

        cell.delegate = self;
        cell.index = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([sec isEqualToString:@"Timeline"]) {
        TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell"];
        if (cell == nil) {
            cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
        }
        
        for (UIView *view in cell.detailBgView.subviews) {
            [view removeFromSuperview];
        }
        
        
        NSDictionary *request_progress = [self.requestInfo valueForKey:@"request_progress"];
        if ([request_progress valueForKey:@"pending_statuses"]) {
            NSLog(@"Pending Statuses: %@\n",[request_progress valueForKey:@"pending_statuses"]);
        }
        
        UIFont *font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];

        if ([self.requestInfo valueForKey:@"timelineAry"]) {
            NSArray *timelineAry = [self.requestInfo valueForKey:@"timelineAry"];
//            70+70
            UILabel *status = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_wdth-220, 39)];
            status.font = font; status.text = @"Status";
            status.textAlignment = NSTextAlignmentLeft;
            status.textColor = [UIColor whiteColor];
            [cell.detailBgView addSubview:status];

            UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-210, 0, 70, 39)];
            date.font = font; date.text = @"Date";
            date.textAlignment = NSTextAlignmentCenter;
            date.textColor = [UIColor whiteColor];
            [cell.detailBgView addSubview:date];
            
            UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-140, 0, 70, 39)];
            time.font = font; time.text = @"Time";
            time.textAlignment = NSTextAlignmentRight;
            time.textColor = [UIColor whiteColor];
            [cell.detailBgView addSubview:time];

            NSInteger ind = 0;
            for (int i=0; i<timelineAry.count; i++) {
                
                NSDictionary *timelineInfo = [timelineAry objectAtIndex:i];

                NSString *myString = [timelineInfo valueForKey:@"created_at"];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *yourDate = [dateFormatter dateFromString:myString];
                dateFormatter.dateFormat = @"dd MMM yyyy";//yyyy
                
                UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, (i+1)*40, screen_wdth-60, 1)];
                lblLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
                [cell.detailBgView addSubview:lblLine];
                
                UILabel *statuslbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (i+1)*40+1, screen_wdth-220, 39)];//220
                statuslbl.font = font; statuslbl.numberOfLines = 0;
                if ([timelineInfo valueForKey:@"status"]) {
                    NSString *status = [timelineInfo valueForKey:@"status"];
                    status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                    statuslbl.text = status;
                }
                statuslbl.textAlignment = NSTextAlignmentLeft;
                statuslbl.textColor = yellow_color;
                [cell.detailBgView addSubview:statuslbl];
                
                UILabel *datelbl = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-220, (i+1)*40+1, 85, 39)];
                datelbl.font = font;
                if ([dateFormatter stringFromDate:yourDate]) {
                    datelbl.text = [dateFormatter stringFromDate:yourDate];
                }
                datelbl.textAlignment = NSTextAlignmentCenter;
                datelbl.textColor = [UIColor whiteColor];
                [cell.detailBgView addSubview:datelbl];
                
                UILabel *timelbl = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-130,  (i+1)*40+1, 65, 39)];
                timelbl.font = font;
                dateFormatter.dateFormat = @"h:mm a";
                if ([dateFormatter stringFromDate:yourDate]) {
                    timelbl.text = [dateFormatter stringFromDate:yourDate];
                }
                timelbl.textAlignment = NSTextAlignmentRight;
                timelbl.textColor = [UIColor whiteColor];
                [cell.detailBgView addSubview:timelbl];
                ind = i;
            }
            ind = ind+1;
            if ([[request_progress valueForKey:@"pending_statuses"] isKindOfClass:[NSArray class]]) {
                NSArray *pending_statuses = [request_progress valueForKey:@"pending_statuses"];
                for (int i=0; i<pending_statuses.count; i++) {
                    NSDictionary *timelineInfo = [pending_statuses objectAtIndex:i];
                    
                    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, (ind+i+1)*40, screen_wdth-60, 1)];
                    lblLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
                    [cell.detailBgView addSubview:lblLine];
                    
                    UILabel *statuslbl = [[UILabel alloc] initWithFrame:CGRectMake(10, (ind+i+1)*40+1, screen_wdth-220, 39)];//220
                    statuslbl.font = font; statuslbl.numberOfLines = 0;
                    if ([timelineInfo valueForKey:@"statusName"]) {
                        NSString *status = [timelineInfo valueForKey:@"statusName"];
                        status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                        statuslbl.text = status;
                    }
                    statuslbl.textAlignment = NSTextAlignmentLeft;
                    statuslbl.textColor = [yellow_color colorWithAlphaComponent:0.5];
                    [cell.detailBgView addSubview:statuslbl];
                    
                    UILabel *datelbl = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-220, (ind+i+1)*40+1, 85, 39)];
                    datelbl.font = font;
                    datelbl.text = @"-";
                    datelbl.textAlignment = NSTextAlignmentCenter;
                    datelbl.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
                    [cell.detailBgView addSubview:datelbl];
                    
                    UILabel *timelbl = [[UILabel alloc] initWithFrame:CGRectMake(screen_wdth-130,  (ind+i+1)*40+1, 65, 39)];
                    timelbl.font = font;
                    timelbl.text = @"-";
                    timelbl.textAlignment = NSTextAlignmentRight;
                    timelbl.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
                    [cell.detailBgView addSubview:timelbl];
                    
                }
            }
        }
        
        


        
        
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if ([sec isEqualToString:@"Technical Report"]){
        
        ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportCell"];
        if (cell == nil) {
            cell = [[ReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reportCell"];
        }
        
        for (UIView *subView in cell.pdfBgView.subviews) {
            [subView removeFromSuperview];
        }
        NSArray *techReportAry = [self.requestInfo valueForKey:@"technical_report"];
        float y=5;
        for (int i=0; i<techReportAry.count; i++) {
            NSDictionary *dict = [techReportAry objectAtIndex:i];
            
            UIImageView *pdf_icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, y+15, 30, 30)];
            pdf_icon.image = [UIImage imageNamed:@"pdf_icon.png"];
            pdf_icon.contentMode = UIViewContentModeScaleAspectFit;
            [cell.pdfBgView addSubview: pdf_icon];
            
            UILabel *pdfLabl = [[UILabel alloc] initWithFrame:CGRectMake(60, y+10, screen_wdth-140, 40)];
            pdfLabl.numberOfLines = 0;
            if ([dict valueForKey:@"trep_filename"]) {
                NSString *fileName = [dict valueForKey:@"trep_filename"];
                pdfLabl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",fileName] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            }else{
                pdfLabl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"See attachment" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            }
            
//            if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
//                cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
//            }else{
//                cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
//            }

            [cell.pdfBgView addSubview: pdfLabl];
//
//
            UIButton *pdf = [[UIButton alloc] initWithFrame:CGRectMake(10, y+5, screen_wdth-80, 50)];
            pdf.layer.cornerRadius = 7;
            pdf.layer.borderWidth = 1;
            pdf.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
            [pdf addTarget:self action:@selector(pdfLinkTapped:) forControlEvents:UIControlEventTouchUpInside];
            pdf.tag = i+92553;
            [cell.pdfBgView addSubview: pdf];

            y+=60;
        }
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if ([sec isEqualToString:@"Product Information"]){
        ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productInfoCell"];
        if (cell == nil) {
            cell = [[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productInfoCell"];
        }
        NSDictionary *productInfo;
        if ([[self.requestInfo valueForKey:@"product_info"] isKindOfClass:[NSArray class]]) {
             productInfo = [[self.requestInfo valueForKey:@"product_info"] firstObject];
        }else{
            productInfo = [self.requestInfo valueForKey:@"product_info"];
        }
        if (productInfo) {
            cell.pName.text = [NSString stringWithFormat:@"%@",[productInfo valueForKey:@"pd_name"]];
            cell.pSrNum.text = [NSString stringWithFormat:@"%@",[productInfo valueForKey:@"pd_serial"]];
            cell.pDesc.text = [NSString stringWithFormat:@"%@",[productInfo valueForKey:@"pd_description"]];
            if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
                cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
            }else{
                cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else if ([sec isEqualToString:@"Escalation"]){

        RequestEscalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"requestEscalationCell"];
        if (cell == nil) {
            cell = [[RequestEscalationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"requestEscalationCell"];
        }
        
        float y = 10;
        
        for (UIView *subView in cell.contactView.subviews) {
            [subView removeFromSuperview];
        }
        
        
        NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
        int escalation_count = (int)escalatedAry.count;
        NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"escalation_level" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        escalatedAry = [escalatedAry sortedArrayUsingDescriptors:sortDescriptors];
        
        if (escalatedAry.count) {
            for (int i=0; i<escalation_count; i++) {
                NSDictionary *escalatedInfo = [escalatedAry objectAtIndex:i];
                
                UILabel *escalatedTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
//                escalatedTitle.backgroundColor = [UIColor cyanColor];
                escalatedTitle.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Escalation %@:",[escalatedInfo valueForKey:@"escalation_level"]] attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:yellow_color, NSBackgroundColorAttributeName: [UIColor clearColor]}];
                [cell.contactView addSubview:escalatedTitle];
                y=y+25;
                
                
                
                UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 90, 90)];
                userImg.contentMode = UIViewContentModeScaleAspectFill;
                userImg.clipsToBounds = YES;
                userImg.layer.cornerRadius = 45;
                [userImg sd_setImageWithURL:[NSURL URLWithString:[escalatedInfo valueForKey:@"employee_image"]] placeholderImage:[UIImage imageNamed:@"employee_image.jpg"]];
                [cell.contactView addSubview:userImg];
                
                
                
                UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(110, y, screen_wdth-175, 90)];
                userName.numberOfLines = 0;
                userName.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[escalatedInfo valueForKey:@"name"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                [cell.contactView addSubview:userName];
                y=y+100;


                NSString *escalatedStr = @"";
                
                if ([[escalatedInfo valueForKey:@"escalation_level"] intValue] != 1) {
                    escalatedStr = [NSString stringWithFormat:@"Email id : %@\nDesignation : %@",[escalatedInfo valueForKey:@"email"],[[UtilsManager sharedObject] removeNullFromString:[escalatedInfo valueForKey:@"designation"]]];
                }else{
                    NSString *mobile = @"";
                    if (![[escalatedInfo valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                        mobile = [escalatedInfo valueForKey:@"mobile"];
                    }
                    escalatedStr = [NSString stringWithFormat:@"Mobile : %@\nEmail id : %@\nDesignation : %@",mobile,[escalatedInfo valueForKey:@"email"],[[UtilsManager sharedObject] removeNullFromString:[escalatedInfo valueForKey:@"designation"]]];
                }
                
                UITextView *escalatedContactValue = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
                NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalatedStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                
                escalatedContactValue.textContainerInset = UIEdgeInsetsZero;
                [escalatedContactValue textContainer].lineFragmentPadding = 0;
                
                CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80];
                escalatedContactValue.backgroundColor = [UIColor clearColor];
                escalatedContactValue.scrollEnabled = NO;
                escalatedContactValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
                escalatedContactValue.dataDetectorTypes = UIDataDetectorTypeAll;
                escalatedContactValue.editable = NO;
                escalatedContactValue.selectable = YES;
                escalatedContactValue.attributedText = contactValueStr;
                [cell.contactView addSubview:escalatedContactValue];
                escalatedContactValue.frame = CGRectMake(10, y, screen_wdth-80, escalatedContactValueHgt);
                y=y+escalatedContactValueHgt;
                
                y=y+5;
                UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-60, 1)];
                lblLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
                [cell.contactView addSubview:lblLine];
                y=y+5;
            }
            
            

            UILabel *escalationReason = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
            escalationReason.attributedText = [[NSAttributedString alloc] initWithString:@"Escalation Reasons: " attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:yellow_color, NSBackgroundColorAttributeName: [UIColor clearColor]}];
            [cell.contactView addSubview:escalationReason];
            y=y+25;
            
            
            
            NSString *escalation_reasons_str =  [[UtilsManager sharedObject] removeNullFromString:[self.requestInfo valueForKey:@"escalation_reasons"]];
            escalation_reasons_str =  [escalation_reasons_str stringByReplacingOccurrencesOfString:@"," withString:@"\n\n• "];
            escalation_reasons_str = [NSString stringWithFormat:@"• %@",escalation_reasons_str];

            if (escalation_reasons_str.length) {
                
                NSLog(@"escalation_reasons_str : %@",escalation_reasons_str);
                UITextView *escReasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
                NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalation_reasons_str font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                escReasonTextView.textContainerInset = UIEdgeInsetsZero;
                [escReasonTextView textContainer].lineFragmentPadding = 0;
                escReasonTextView.backgroundColor = [UIColor clearColor];
                escReasonTextView.scrollEnabled = NO;
                escReasonTextView.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
                escReasonTextView.editable = NO;
                escReasonTextView.selectable = NO;
                escReasonTextView.attributedText = contactValueStr;
                [cell.contactView addSubview:escReasonTextView];
                CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80];
                escReasonTextView.frame = CGRectMake(10, y, screen_wdth-80, escalatedContactValueHgt);
                y=y+escalatedContactValueHgt+10;
            }
            

            
            
            

            NSString *escalation_remarks = [[UtilsManager sharedObject] removeNullFromString:[self.requestInfo valueForKey:@"escalation_remarks"]];
            UILabel *escalationRemarks = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
            escalationRemarks.attributedText = [[NSAttributedString alloc] initWithString:@"Escalation Remark: " attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:yellow_color, NSBackgroundColorAttributeName: [UIColor clearColor]}];
            [cell.contactView addSubview:escalationRemarks];
            y=y+25;

            if (escalation_remarks.length) {
                UITextView *escReasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-80, 20)];
                NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalation_remarks font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                escReasonTextView.textContainerInset = UIEdgeInsetsZero;
                [escReasonTextView textContainer].lineFragmentPadding = 0;
                escReasonTextView.backgroundColor = [UIColor clearColor];
                escReasonTextView.scrollEnabled = NO;
                escReasonTextView.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
                escReasonTextView.editable = NO;
                escReasonTextView.selectable = NO;
                escReasonTextView.attributedText = contactValueStr;
                [cell.contactView addSubview:escReasonTextView];
                CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-80];
                escReasonTextView.frame = CGRectMake(10, y, screen_wdth-80, escalatedContactValueHgt);
                y=y+escalatedContactValueHgt+10;
            }
        }
        
        
        
        
        
        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
       //[sec isEqualToString:@"Feedback"]
       //[sec isEqualToString:@"Escalation"]
       
       
        StatusFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusFeedbackCell"];
        if (cell == nil) {
            cell = [[StatusFeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"statusFeedbackCell"];
        }
       cell.remarkHgt.constant = 0;
       
       
       if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
           if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
               NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
               if (feedbackAry.count) {
                   
                   NSDictionary *feedbackDict = [[self.requestInfo valueForKey:@"feedback"] firstObject];
                   NSString *myString = [feedbackDict valueForKey:@"updated_at"];
                   NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                   dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                   NSDate *yourDate = [dateFormatter dateFromString:myString];
                   dateFormatter.dateFormat = @"dd MMM yyyy";
                   if ([dateFormatter stringFromDate:yourDate]) {
                       cell.ratingLbl.text = [NSString stringWithFormat:@"RATING (%@)",[dateFormatter stringFromDate:yourDate]];
                   }else{
                       cell.ratingLbl.text = @"RATING";
                   }
                   
                   if ([[flagAry objectAtIndex:indexPath.row] boolValue]){
                       cell.responseSpeedStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"response_speed"]]];
                       cell.qualityStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"quality_of_response"]]];
                       cell.appExpStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"app_experience"]]];
                       cell.performanceStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"olympus_staff_performance"]]];
                       if (![[feedbackDict valueForKey:@"remarks"] isKindOfClass:[NSNull class]]||[feedbackDict valueForKey:@"remarks"] != nil) {

                           cell.remark.text = [feedbackDict valueForKey:@"remarks"];
                           NSAttributedString *str = [[UtilsManager sharedObject] getMutableStringWithString:[feedbackDict valueForKey:@"remarks"] font:[UIFont fontWithName:@"EncodeSansNormal" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                           cell.remarkHgt.constant = [[UtilsManager sharedObject] heightOfAttributesString:str withWidth:screen_wdth-80];
                       }
                   }

                   
                   
               }
               
           }
       }
       
       


        if ([[flagAry objectAtIndex:indexPath.row] boolValue]) {
            cell.arrowImg.image = [UIImage imageNamed:@"up_arrow_w.png"];
        }else{
            cell.arrowImg.image = [UIImage imageNamed:@"down_arrow_w.png"];
        }

       

       
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    /*
     <__NSArrayI 0x6000014de2e0>(
     {
     email = "praveen.kakarla@olympus-ap.com";
     "escalation_level" = 1;
     mobile = 9999356457;
     name = "Praveen Kumar Kakarla";
     },
     {
     email = "rajesh.gupta@olympus-ap.com";
     "escalation_level" = 2;
     mobile = 9818802542;
     name = "Rajesh Motilal Gupta";
     }
     )

     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableArray *indexpathAry = [[NSMutableArray alloc] init];
    [indexpathAry addObject:indexPath];
    
    BOOL flag = ![[flagAry objectAtIndex: indexPath.row] boolValue];
    
    for (int i=0; i<flagAry.count; i++) {
        if ([[flagAry objectAtIndex: i] boolValue]) {
            [indexpathAry addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
//        [flagAry replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    
    [flagAry replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:flag]];
    [_statusTableView reloadRowsAtIndexPaths:indexpathAry withRowAnimation:UITableViewRowAnimationFade];
}
-(void)pdfLinkTapped:(UIButton *)btn{
    NSInteger index =  btn.tag-92553;
    NSDictionary *techReport = [[self.requestInfo valueForKey:@"technical_report"] objectAtIndex:index];
    NSString *fileType = [[[techReport valueForKey:@"trep_file"] componentsSeparatedByString:@"."] lastObject];
    
    if ([[fileType lowercaseString] isEqualToString:@"pdf"]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        PDFReaderViewController *pDFReaderVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"pDFReaderVC"];
        pDFReaderVC.pdfUrl = [techReport valueForKey:@"trep_file"] ;
        [self.navigationController pushViewController:pDFReaderVC animated:NO];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[techReport valueForKey:@"trep_file"]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[techReport valueForKey:@"trep_file"]]];
        }
    }
    

    
    NSLog(@"pdfLinkTapped :%ld",index);
}

#pragma mark- EmployeeCellDelegate Methods

-(void)emailTappedWithCell:(EmployeeCell *)cell index:(NSInteger)index{
    if (fseAry && fseAry.count) {
        if (![[[fseAry firstObject] valueForKey:@"email"] isKindOfClass:[NSNull class]]) {
            NSString *recipients = [NSString stringWithFormat:@"mailto:%@",[[fseAry firstObject] valueForKey:@"email"]];
            NSString *body = @"";
            NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
            email = [email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        }

    }
    
}
-(void)phoneNumberTappedWithCell:(EmployeeCell *)cell index:(NSInteger)index{
    if (fseAry && fseAry.count) {
        if (![[[fseAry firstObject] valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",[[fseAry firstObject] valueForKey:@"mobile"]]];

            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Call facility is not available!!!"  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }
}

#pragma mark- UIScrollView Methods

-(void)createScrollViewSubView{
    float y=10;
    
    //    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, y, screen_wdth-80, 50)];
    //    title.text = @"STATUS";
    //    title.font = [UIFont fontWithName:@"Roboto-Bold" size:15.0];
    //    title.textColor = [UIColor whiteColor];
    //    title.textAlignment = NSTextAlignmentCenter;
    //    [self.scrollView addSubview:title];
    //    y = y+60; [UIFont fontWithName:@"EncodeSansNormal-Medium" size:12.0]
    
    

    
    
    
    UIImageView *assignPerImg = [[UIImageView alloc] initWithFrame:CGRectMake((screen_wdth-160), y, 70, 70)];
    assignPerImg.image = [UIImage imageNamed:@"user_placeholder.png"];
    assignPerImg.contentMode = UIViewContentModeScaleAspectFill;
    assignPerImg.clipsToBounds = YES;
    assignPerImg.layer.cornerRadius = 35;

    UILabel *assignPerName = [[UILabel alloc] initWithFrame:CGRectMake(10+(screen_wdth-100)/2, y+75, (screen_wdth-100)/2, 45)];
    assignPerName.numberOfLines = 0;
//    assignPerName.backgroundColor = [UIColor blueColor];
    assignPerName.font = [UIFont fontWithName:@"EncodeSansNormal" size:13.0];
    assignPerName.textColor = [UIColor whiteColor];
    assignPerName.textAlignment = NSTextAlignmentCenter;

    [self.scrollView addSubview:assignPerName];
    assignPerImg.center  =CGPointMake(assignPerName.center.x, assignPerImg.center.y);






    UILabel *callNo = [[UILabel alloc] initWithFrame:CGRectMake(10, y, (screen_wdth-100)/2, 20)];
    callNo.text = [@"Request No :" uppercaseString];//@"NUMBER :";//
    callNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    callNo.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    callNo.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:callNo];
    y = y+20;

    UILabel *callNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, (screen_wdth-100)/2, 25)];
    if (![[self.requestInfo valueForKey:@"cvm_id"] isKindOfClass:[NSNull class]]) {
        callNoLbl.text = [[[self.requestInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject];
    }
    callNoLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    callNoLbl.textColor = [UIColor whiteColor];
    callNoLbl.textAlignment = NSTextAlignmentLeft;
//    callNoLbl.backgroundColor = [UIColor blueColor];
    [self.scrollView addSubview:callNoLbl];
    y = y+30;
    
    
    
    UILabel *requestName = [[UILabel alloc] initWithFrame:CGRectMake(10, y, (screen_wdth-100)/2, 20)];
    requestName.text = @"STATUS :";//@"Request Name:"
    requestName.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    requestName.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    requestName.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:requestName];
    y = y+20;

    
    
    UILabel *requestNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, (screen_wdth-100)/2, 25)];
    requestNameLbl.numberOfLines = 0;
    
    if (![[self.requestInfo valueForKey:@"status"] isKindOfClass:[NSNull class]]) {
        NSString *status = [self.requestInfo valueForKey:@"status"];
        status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        if ([[status lowercaseString] isEqualToString:@"received"]||[[status lowercaseString] isEqualToString:@"assigned"]||[[status lowercaseString] isEqualToString:@"re-assigned"]||[[status lowercaseString] isEqualToString:@"closed"]||[[status lowercaseString] isEqualToString:@"request closed"]) {
            status = [NSString stringWithFormat:@"Request %@",status];
        }else{
            status = [NSString stringWithFormat:@"%@",status];
        }

        
        
        NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:status font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        requestNameLbl.attributedText = attributedText;

            float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:(screen_wdth-100)/2]+10;
        requestNameLbl.frame = CGRectMake(10, y, (screen_wdth-100)/2, lglHgt);
        y = y+lglHgt;
    }else{
        y = y+30;
    }
//    requestNameLbl.backgroundColor = [UIColor blueColor];
//    requestNameLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
//    requestNameLbl.textColor = [UIColor whiteColor];
//    requestNameLbl.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:requestNameLbl];
    
    
    
    UILabel *remarkTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, 20)];
    remarkTitleLbl.text = @"REMARKS :";
//    remarkTitleLbl.backgroundColor = [UIColor blueColor];

    remarkTitleLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    remarkTitleLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    remarkTitleLbl.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:remarkTitleLbl];
    y = y+20;

    
    
    

    
    
    NSString *remarkString = @"";//@"This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark. This is testing remark.";
    if (![[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
        remarkString =  [self.requestInfo valueForKey:@"remarks"];
    }
    if (remarkString == nil) {
        remarkString = @"";
    }
    
    NSMutableAttributedString *atrStr = [self getMutableStringWithString:remarkString font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:3 andNSTextAlignment:NSTextAlignmentLeft];
    
    UILabel *remark = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
    remark.attributedText = atrStr;
    remark.numberOfLines = 0;
    remark.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:remark];
    float hgt =[self heightOfAttributesString:atrStr withWidth:screen_wdth-100]+20;
    remark.frame = CGRectMake(10, y, screen_wdth-100, hgt);
    y = y+hgt+10;
    
    
    //************************************************* TIMELINE ***************************************************//
    float width = screen_wdth - 120;

    UILabel *timelineTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
    timelineTitle.text = @"TIMELINE :";
    timelineTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    timelineTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    timelineTitle.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:timelineTitle];
    y = y+20;

    
    
    UILabel *fTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, y, width/3, 20)];
    fTitle.text = @"STATUS";
//    fTitle.backgroundColor = [UIColor cyanColor];
    fTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    fTitle.textColor = [UIColor whiteColor];//[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    fTitle.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:fTitle];

    UILabel *sTitle = [[UILabel alloc] initWithFrame:CGRectMake(30+width/3, y, width/3, 20)];
    sTitle.text = @"DATE";
//    sTitle.backgroundColor = [UIColor yellowColor];
    sTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    sTitle.textColor = [UIColor whiteColor];//[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    sTitle.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:sTitle];

    UILabel *lTitle = [[UILabel alloc] initWithFrame:CGRectMake(30+width*2/3, y, width/3-10, 20)];
    lTitle.text = @"TIME";
//    lTitle.backgroundColor = [UIColor lightGrayColor];
    lTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    lTitle.textColor = [UIColor whiteColor];//[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    lTitle.textAlignment = NSTextAlignmentRight;
    [self.scrollView addSubview:lTitle];

    y = y + 20;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, y, screen_wdth-130, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:line];


    if ([self.requestInfo valueForKey:@"timelineAry"]) {
        timelineAry = [NSMutableArray arrayWithArray:[self.requestInfo valueForKey:@"timelineAry"]];
        float yy = y;
        yy = yy+10;
        for (int i=0; i<timelineAry.count; i++) {
            NSDictionary *timelineInfo = [timelineAry objectAtIndex:i];
            UIImageView *radio = [[UIImageView alloc] initWithFrame:CGRectMake(10, y+20,10, 10)];
            radio.contentMode = UIViewContentModeScaleAspectFit;
            radio.image = [UIImage imageNamed:@"radioBtn.png"];
            [self.scrollView addSubview:radio];
            
            UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, y,width/3, 50)];
            if ([timelineInfo valueForKey:@"status"]) {
                NSString *status = [timelineInfo valueForKey:@"status"];
                status = [status stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                leftLbl.text = status;
            }
            leftLbl.numberOfLines = 2 ;
            leftLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13];
            leftLbl.textAlignment = NSTextAlignmentLeft;
            leftLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
            [self.scrollView addSubview:leftLbl];
            
            
            
            
            
            NSString *myString = [timelineInfo valueForKey:@"created_at"];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate = [dateFormatter dateFromString:myString];
//            dateFormatter.dateFormat = @"dd MMM yyyy h:mm a";
            dateFormatter.dateFormat = @"dd MMM yy";//yyyy

            
            
            UILabel *centerLbl = [[UILabel alloc] initWithFrame:CGRectMake(30+width/3, y,width/3, 50)];
            centerLbl.text = [dateFormatter stringFromDate:yourDate];
//            centerLbl.text = @"15 Feb 2018";
            //        centerLbl.backgroundColor = [UIColor yellowColor];
            centerLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13];
            centerLbl.textAlignment = NSTextAlignmentCenter;
            centerLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
            [self.scrollView addSubview:centerLbl];
            
            UILabel *rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(30+width/3+width/3, y,width/3 -10, 50)];
            dateFormatter.dateFormat = @"h:mm a";
            rightLbl.text = [dateFormatter stringFromDate:yourDate];
            rightLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13];
            rightLbl.textAlignment = NSTextAlignmentRight;
            rightLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
            [self.scrollView addSubview:rightLbl];
            y=y+50;
        }
        if(timelineAry.count > 1){
            UILabel *radioLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, yy+15,1, (y-yy)-40)];
            radioLbl.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
            [self.scrollView addSubview:radioLbl];
            y=y+50;
        }
    }
    
    
    
    // User existing Rating
    if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
        if (![[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
            NSArray *feedbackAry = [self.requestInfo valueForKey:@"feedback"];
            if (feedbackAry.count) {
                NSDictionary *feedbackDict = [[self.requestInfo valueForKey:@"feedback"] firstObject];
                
                NSString *myString = [feedbackDict valueForKey:@"updated_at"];
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *yourDate = [dateFormatter dateFromString:myString];
                dateFormatter.dateFormat = @"dd MMM yyyy";
                
                
//                y = y+10;
                UILabel *feedbackTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
                if ([dateFormatter stringFromDate:yourDate]) {
                    feedbackTitle.text = [NSString stringWithFormat:@"RATING (%@) :",[dateFormatter stringFromDate:yourDate]];
                }else{
                    feedbackTitle.text = @"RATING :";
                }
                feedbackTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
                feedbackTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
                feedbackTitle.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:feedbackTitle];
                y = y+20;
                
                UILabel *responseSpeedLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 25)];
                responseSpeedLbl.text = @"Response Speed";
                responseSpeedLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                responseSpeedLbl.textColor = [UIColor whiteColor];
                responseSpeedLbl.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:responseSpeedLbl];
                y = y+30;
                
                UIImageView *responseSpeedImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 133, 20)];
                responseSpeedImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"response_speed"]]];
                responseSpeedImg.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:responseSpeedImg];
                y = y+30;
                
                UILabel *qualityofResponseLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 25)];
                qualityofResponseLbl.text = @"Quality Of Response";
                qualityofResponseLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                qualityofResponseLbl.textColor = [UIColor whiteColor];
                qualityofResponseLbl.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:qualityofResponseLbl];
                y = y+30;
                
                UIImageView *qualityofResponseImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 133, 20)];
                qualityofResponseImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"quality_of_response"]]];
                qualityofResponseImg.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:qualityofResponseImg];
                y = y+30;
                
                
                UILabel *appExperienceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 25)];
                appExperienceLbl.text = @"App Experience";
                appExperienceLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                appExperienceLbl.textColor = [UIColor whiteColor];
                appExperienceLbl.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:appExperienceLbl];
                y = y+30;
                UIImageView *app_experienceImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 133, 20)];
                app_experienceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"app_experience"]]];
                app_experienceImg.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:app_experienceImg];
                y = y+30;
                
                
                UILabel *empPerformanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 25)];
                empPerformanceLbl.text = @"Performance of Olympus Employee";
                empPerformanceLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                empPerformanceLbl.textColor = [UIColor whiteColor];
                empPerformanceLbl.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:empPerformanceLbl];
                y = y+30;
                UIImageView *empPerformanceImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, 133, 20)];
                empPerformanceImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@star.png",[feedbackDict valueForKey:@"olympus_staff_performance"]]];
                empPerformanceImg.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:empPerformanceImg];
                y = y+30;
                
                
                UILabel *remarksLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 25)];
                remarksLbl.text = @"Feedback Remarks";
                remarksLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                remarksLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
                remarksLbl.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:remarksLbl];
                y = y+30;

//                [feedbackDict valueForKey:@"remarks"]
                
                
                
                NSString *feedbackremarkString = @"";//@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
                if (![[feedbackDict valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
                    feedbackremarkString =  [feedbackDict valueForKey:@"remarks"];
                }
                if (feedbackremarkString == nil) {
                    feedbackremarkString = @"";
                }
                
                NSMutableAttributedString *remarksAtrStr = [self getMutableStringWithString:feedbackremarkString font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:14.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:3 andNSTextAlignment:NSTextAlignmentLeft];
                
                UILabel *feedbackremarks = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
                feedbackremarks.attributedText = remarksAtrStr;
                feedbackremarks.numberOfLines = 0;
                feedbackremarks.textAlignment = NSTextAlignmentLeft;
                [self.scrollView addSubview:feedbackremarks];
                float feedbackremarksHgt =[self heightOfAttributesString:remarksAtrStr withWidth:screen_wdth-100]+20;
                feedbackremarks.frame = CGRectMake(10, y, screen_wdth-100, feedbackremarksHgt);
                y = y+feedbackremarksHgt+10;

            }

        }
    }
    
    
    
    if ([[self.requestInfo valueForKey:@"status"] isEqualToString:@"Closed"]) {
        // Show only for service type
        
        if ([[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
            UIButton *feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-230)/2, y, 150, 40)];
            feedbackBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
            [feedbackBtn setAttributedTitle:[self getMutableStringWithString:@"RATE US" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
            feedbackBtn.layer.cornerRadius = 7;
            feedbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [feedbackBtn addTarget:self action:@selector(feedbackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:feedbackBtn];
            y=y+65;
        } else {

//            [feedbackBtn setAttributedTitle:[self getMutableStringWithString:@"UPDATE RATING" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
        }
        
        
    }
    
    
    
    UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
    contactTitle.text = @"CONTACT :";
    contactTitle.textAlignment = NSTextAlignmentLeft;
    contactTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
    contactTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [self.scrollView addSubview:contactTitle];
    y=y+25;
    
    
    
//    int escalation_count = [[self.requestInfo valueForKey:@"escalation_count"] intValue];

//    if (escalation_count > 0) {
        NSLog(@"Show Escalted Contact Details");
//        "escalation_count" = 1;
        NSArray *escalatedAry = [self.requestInfo valueForKey:@"escalation_detail"];
        int escalation_count = (int)escalatedAry.count;
        NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"escalation_level" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        escalatedAry = [escalatedAry sortedArrayUsingDescriptors:sortDescriptors];

        if (escalatedAry.count) {
            for (int i=0; i<escalation_count; i++) {
                
                NSDictionary *escalatedInfo = [escalatedAry objectAtIndex:i];
                
                UILabel *escalatedTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
                escalatedTitle.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Escalation %@",[escalatedInfo valueForKey:@"escalation_level"]] attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
                [self.scrollView addSubview:escalatedTitle];
                y=y+25;

                NSString *escalatedStr = @"";
                
                if ([[escalatedInfo valueForKey:@"escalation_level"] intValue] != 1) {
                    escalatedStr = [NSString stringWithFormat:@"Name : %@\nEmail id : %@\n",[escalatedInfo valueForKey:@"name"],[escalatedInfo valueForKey:@"email"]];
                }else{
                    NSString *mobile = @"";
                    if (![[escalatedInfo valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                        mobile = [escalatedInfo valueForKey:@"mobile"];
                    }
                    escalatedStr = [NSString stringWithFormat:@"Name : %@\nMobile : %@\nEmail id : %@\n",[escalatedInfo valueForKey:@"name"],mobile,[escalatedInfo valueForKey:@"email"]];
                }
                
                UITextView *escalatedContactValue = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
                NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:escalatedStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
                
                escalatedContactValue.textContainerInset = UIEdgeInsetsZero;
                [escalatedContactValue textContainer].lineFragmentPadding = 0;
                
                CGFloat escalatedContactValueHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-100]+10;
                escalatedContactValue.backgroundColor = [UIColor clearColor];
                escalatedContactValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
                escalatedContactValue.dataDetectorTypes = UIDataDetectorTypeAll;
                escalatedContactValue.editable = NO;
                escalatedContactValue.selectable = YES;
                escalatedContactValue.attributedText = contactValueStr;
                [self.scrollView addSubview:escalatedContactValue];
                escalatedContactValue.frame = CGRectMake(10, y, screen_wdth-100, escalatedContactValueHgt);
                y=y+escalatedContactValueHgt;
            }
        }
        
        
        /*
         "escalation_count" = 1;
         "escalation_detail" =                 (
         {
         email = "vivek.sharma@olympus-ap.com";
         "escalation_level" = 1;
         mobile = 9435709602;
         name = "Vivek Kumar Sharma";
         }
         );

         */
    
    

    
    if ([[self.requestInfo valueForKey:@"fseAry"] count]>0) {
        fseAry = [NSMutableArray arrayWithArray:[self.requestInfo valueForKey:@"fseAry"]];
        
        [assignPerImg sd_setImageWithURL:[NSURL URLWithString:[[fseAry firstObject] valueForKey:@"employee_image"]] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
        UITapGestureRecognizer *imgTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToExcecutive:)];
        imgTapGes.numberOfTapsRequired = 1;
        [assignPerImg addGestureRecognizer:imgTapGes];
        assignPerImg.userInteractionEnabled = YES;
        [self.scrollView addSubview:assignPerImg];

        assignPerName.text = [[fseAry firstObject] valueForKey:@"name"];

        for (int i=0; i<fseAry.count; i++) {
            NSDictionary *fseInfo = [fseAry objectAtIndex:i];
            NSString *tStr = @"";
//            if (i==0) {
//                tStr = @"Assigned Engineer / Executive";
//            }else if(i==1){
//                tStr = @"Supervisor of assigned Engineer / Executive";
//            }else{
//                tStr = @"Manager of assigned Engineer / Executive";
//            }
            tStr = @"Assigned Engineer / Executive";
            excutiveY = y;
            UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
            NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:tStr attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
            
            contactTitle.attributedText = titleAtr;
            [self.scrollView addSubview:contactTitle];
            y=y+25;
            
            NSString *mobNum = @"";
            if (![[fseInfo valueForKey:@"mobile"] isKindOfClass:[NSNull class]]) {
                mobNum = [fseInfo valueForKey:@"mobile"];
            }
            //Designation : %@\nBranch : %@\n  [fseInfo valueForKey:@"designation"],[fseInfo valueForKey:@"branch"],
            NSString *infoStr = [NSString stringWithFormat:@"Name : %@\nMobile : %@\nEmail id : %@\n",[fseInfo valueForKey:@"name"],mobNum,[fseInfo valueForKey:@"email"]];
            
            UITextView *contactValue = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
            NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:infoStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
            
            contactValue.textContainerInset = UIEdgeInsetsZero;
            [contactValue textContainer].lineFragmentPadding = 0;
            
            CGFloat contactValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-120]+10;
            contactValue.backgroundColor = [UIColor clearColor];
            contactValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
            contactValue.dataDetectorTypes = UIDataDetectorTypeAll;
            contactValue.editable = NO;
            contactValue.selectable = YES;
            contactValue.attributedText = contactValueStr;
            [self.scrollView addSubview:contactValue];
            contactValue.frame = CGRectMake(10, y, screen_wdth-100, contactValueStrHgt);
            y=y+contactValueStrHgt;
            
        }
    }
    
    
    
    
    UILabel *hospitalTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
    NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:@"Olympus Office" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
    hospitalTitle.attributedText = titleAtr;
    [self.scrollView addSubview:hospitalTitle];
    y=y+25;
    
    UITextView *hospitalValue = [[UITextView alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
    NSMutableAttributedString *hospitalValueStr = [[UtilsManager sharedObject] getMutableStringWithString:@"Olympus Medical Systems India\nGround Floor, Tower- C, SAS Tower, The Medicity Complex Sector – 38, Gurgaon – 122001, Haryana, India\nContact : 1800 102 3654\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];//\nSales Enquiry : endosale.omsi@olympus-ap.com\n\nService Enquiry : endoservice.omsi@olympus-ap.com
    
    hospitalValue.textContainerInset = UIEdgeInsetsZero;
    [hospitalValue textContainer].lineFragmentPadding = 0;
    
    CGFloat hospitalValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:hospitalValueStr withWidth:screen_wdth-120]+10;
    hospitalValue.backgroundColor = [UIColor clearColor];
    hospitalValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    hospitalValue.dataDetectorTypes = UIDataDetectorTypeAll;
    hospitalValue.editable = NO;
    hospitalValue.selectable = YES;
    hospitalValue.attributedText = hospitalValueStr;
    [self.scrollView addSubview:hospitalValue];
    hospitalValue.frame = CGRectMake(10, y, screen_wdth-100, hospitalValueStrHgt);
    y=y+hospitalValueStrHgt;

    
    
    

    /*
     
     if (self.showEngineerInfo) {
     // Ongoing Request
     UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
     contactTitle.text = @"CONTACT :";
     contactTitle.textAlignment = NSTextAlignmentLeft;
     contactTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0];
     contactTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
     [self.scrollView addSubview:contactTitle];
     y=y+25;
     
     if ([[self.requestInfo valueForKey:@"fseAry"] count]>0) {
     fseAry = [NSMutableArray arrayWithArray:[self.requestInfo valueForKey:@"fseAry"]];
     
     for (int i=0; i<fseAry.count; i++) {
     NSDictionary *fseInfo = [fseAry objectAtIndex:i];
     NSString *tStr = @"";
     if (i==0) {
     tStr = @"Assigned Engineer / Executive";
     }else if(i==1){
     tStr = @"Supervisor of assigned Engineer / Executive";
     }else{
     tStr = @"Manager of assigned Engineer / Executive";
     }
     
     UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:tStr attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
     
     contactTitle.attributedText = titleAtr;
     [self.scrollView addSubview:contactTitle];
     y=y+25;
     
     
     NSString *infoStr = [NSString stringWithFormat:@"Name : %@\nDesignation : %@\nBranch : %@\nMobile : %@\nEmail id : %@\n",[fseInfo valueForKey:@"name"],[fseInfo valueForKey:@"designation"],[fseInfo valueForKey:@"branch"],[fseInfo valueForKey:@"mobile"],[fseInfo valueForKey:@"email"]];
     
     UITextView *contactValue = [[UITextView alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:infoStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
     
     contactValue.textContainerInset = UIEdgeInsetsZero;
     [contactValue textContainer].lineFragmentPadding = 0;
     
     CGFloat contactValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-120]+10;
     contactValue.backgroundColor = [UIColor clearColor];
     contactValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
     contactValue.dataDetectorTypes = UIDataDetectorTypeAll;
     contactValue.editable = NO;
     contactValue.selectable = YES;
     contactValue.attributedText = contactValueStr;
     [self.scrollView addSubview:contactValue];
     contactValue.frame = CGRectMake(30, y, screen_wdth-120, contactValueStrHgt);
     y=y+contactValueStrHgt;
     
     }
     }
     
     
     
     
     UILabel *hospitalTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:@"Olympus Office" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
     hospitalTitle.attributedText = titleAtr;
     [self.scrollView addSubview:hospitalTitle];
     y=y+25;
     
     UITextView *hospitalValue = [[UITextView alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSMutableAttributedString *hospitalValueStr = [[UtilsManager sharedObject] getMutableStringWithString:@"Olympus Medical Systems India Pvt ltd\nGround Floor, Tower- C, SAS Tower, The Medicity Complex | Sector – 38, Gurgaon – 122001, Haryana, India\nSales Enquiry : endosale.omsi@olympus-ap.com\nService Enquiry : endoservice.omsi@olympus-ap.com" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
     
     hospitalValue.textContainerInset = UIEdgeInsetsZero;
     [hospitalValue textContainer].lineFragmentPadding = 0;
     
     CGFloat hospitalValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:hospitalValueStr withWidth:screen_wdth-120]+10;
     hospitalValue.backgroundColor = [UIColor clearColor];
     hospitalValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
     hospitalValue.dataDetectorTypes = UIDataDetectorTypeAll;
     hospitalValue.editable = NO;
     hospitalValue.selectable = YES;
     hospitalValue.attributedText = hospitalValueStr;
     [self.scrollView addSubview:hospitalValue];
     hospitalValue.frame = CGRectMake(30, y, screen_wdth-120, hospitalValueStrHgt);
     y=y+hospitalValueStrHgt;
     
     
     
     }else{
     
     UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, y, screen_wdth-100, 20)];
     contactTitle.text = @"CONTACT :";
     contactTitle.textAlignment = NSTextAlignmentLeft;
     contactTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:11.0];
     contactTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
     [self.scrollView addSubview:contactTitle];
     y=y+25;
     
     if ([[self.requestInfo valueForKey:@"fseAry"] count]>0) {
     fseAry = [NSMutableArray arrayWithArray:[self.requestInfo valueForKey:@"fseAry"]];
     
     for (int i=0; i<fseAry.count; i++) {
     NSDictionary *fseInfo = [fseAry objectAtIndex:i];
     NSString *tStr = @"";
     if (i==0) {
     tStr = @"Assigned Engineer / Executive";
     }else if(i==1){
     tStr = @"Supervisor of assigned Engineer / Executive";
     }else{
     tStr = @"Manager of assigned Engineer / Executive";
     }
     
     UILabel *contactTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:tStr attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
     
     contactTitle.attributedText = titleAtr;
     [self.scrollView addSubview:contactTitle];
     y=y+25;
     
     
     NSString *infoStr = [NSString stringWithFormat:@"Name : %@\nDesignation : %@\nBranch : %@\nMobile : %@\nEmail id : %@\n",[fseInfo valueForKey:@"name"],[fseInfo valueForKey:@"designation"],[fseInfo valueForKey:@"branch"],[fseInfo valueForKey:@"mobile"],[fseInfo valueForKey:@"email"]];
     
     UITextView *contactValue = [[UITextView alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSMutableAttributedString *contactValueStr = [[UtilsManager sharedObject] getMutableStringWithString:infoStr font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
     
     contactValue.textContainerInset = UIEdgeInsetsZero;
     [contactValue textContainer].lineFragmentPadding = 0;
     
     CGFloat contactValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:contactValueStr withWidth:screen_wdth-120]+10;
     contactValue.backgroundColor = [UIColor clearColor];
     contactValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
     contactValue.dataDetectorTypes = UIDataDetectorTypeAll;
     contactValue.editable = NO;
     contactValue.selectable = YES;
     contactValue.attributedText = contactValueStr;
     [self.scrollView addSubview:contactValue];
     contactValue.frame = CGRectMake(30, y, screen_wdth-120, contactValueStrHgt);
     y=y+contactValueStrHgt;
     
     }
     }
     
     
     UILabel *hospitalTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSAttributedString *titleAtr = [[NSAttributedString alloc] initWithString:@"Olympus Office" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor]}];
     hospitalTitle.attributedText = titleAtr;
     [self.scrollView addSubview:hospitalTitle];
     y=y+25;
     
     UITextView *hospitalValue = [[UITextView alloc] initWithFrame:CGRectMake(30, y, screen_wdth-120, 20)];
     NSMutableAttributedString *hospitalValueStr = [[UtilsManager sharedObject] getMutableStringWithString:@"Olympus Medical Systems India Pvt ltd\nGround Floor, Tower- C, SAS Tower, The Medicity Complex | Sector – 38, Gurgaon – 122001, Haryana, India\nSales Enquiry : endosale.omsi@olympus-ap.com\nService Enquiry : endoservice.omsi@olympus-ap.com" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
     
     hospitalValue.textContainerInset = UIEdgeInsetsZero;
     [hospitalValue textContainer].lineFragmentPadding = 0;
     
     CGFloat hospitalValueStrHgt = [[UtilsManager sharedObject] heightOfAttributesString:hospitalValueStr withWidth:screen_wdth-120]+10;
     hospitalValue.backgroundColor = [UIColor clearColor];
     hospitalValue.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0];
     hospitalValue.dataDetectorTypes = UIDataDetectorTypeAll;
     hospitalValue.editable = NO;
     hospitalValue.selectable = YES;
     hospitalValue.attributedText = hospitalValueStr;
     [self.scrollView addSubview:hospitalValue];
     hospitalValue.frame = CGRectMake(30, y, screen_wdth-120, hospitalValueStrHgt);
     y=y+hospitalValueStrHgt;
     
     
     
     if ([[self.type lowercaseString] isEqualToString:@"service"]) {
     // Show only for service type
     UIButton *feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-230)/2, y, 150, 40)];
     feedbackBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
     
     if ([[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
     [feedbackBtn setAttributedTitle:[self getMutableStringWithString:@"RATE US" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
     } else {
     [feedbackBtn setAttributedTitle:[self getMutableStringWithString:@"UPDATE RATING" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
     }
     
     feedbackBtn.layer.cornerRadius = 7;
     feedbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
     [feedbackBtn addTarget:self action:@selector(feedbackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
     [self.scrollView addSubview:feedbackBtn];
     y=y+65;
     }
     
     }
     

     */
    
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth-80, y);
}

-(void)scrollToExcecutive:(UIGestureRecognizer *)ges{
    [self.scrollView scrollRectToVisible:CGRectMake(0, excutiveY, 10, self.scrollView.bounds.size.height) animated:YES];
//    self.scrollView.contentOffset = CGPointMake(0,excutiveY);
}
-(IBAction)rateUsButtonTapped:(id)sender{
    [self feedbackButtonTapped];
}
-(void)feedbackButtonTapped{
    
    
    
    if ([[self.requestInfo valueForKey:@"feedback_id"] isKindOfClass:[NSNull class]]) {
        UIStoryboard *mainStoryboard;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        }else{
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        }
        
        FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
        fpvc.delegate = self;
        fpvc.requestType = [self.requestInfo valueForKey:@"request_type"];
        fpvc.requestSubType = [self.requestInfo valueForKey:@"sub_type"];
        fpvc.requestId = [self.requestInfo valueForKey:@"id"];
        if (![[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
            fpvc.requestRemark =  [self.requestInfo valueForKey:@"remarks"];
        }
        fpvc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:fpvc animated:YES completion:^{
        }];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to update rating?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *mainStoryboard;
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            }else{
                mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            }
            
            FeedbackViewController *fpvc=[mainStoryboard instantiateViewControllerWithIdentifier:@"feedbackVC"];
            fpvc.delegate = self;
            fpvc.requestType = [self.requestInfo valueForKey:@"request_type"];
            fpvc.requestSubType = [self.requestInfo valueForKey:@"sub_type"];
            fpvc.requestId = [self.requestInfo valueForKey:@"id"];
            if (![[self.requestInfo valueForKey:@"remarks"] isKindOfClass:[NSNull class]]) {
                fpvc.requestRemark =  [self.requestInfo valueForKey:@"remarks"];
            }
            fpvc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:fpvc animated:YES completion:^{
            }];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:yes];
        [alert addAction:no];
        [self presentViewController:alert animated:YES completion:nil];
    }
    

}

-(void)dismissFeedbackViewController{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)showFeedbackView{
    
    
}

-(void)callStaffMember{
    NSLog(@"Call Number:+919876543210");
    NSString *url = [NSString stringWithFormat:@"tel://+919876543210"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Cannot open url." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)mailStaffMember{
    NSLog(@"Email Id:abc@gmail.com");
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
        composeVC.mailComposeDelegate = self;
        [composeVC setToRecipients:[NSArray arrayWithObject:@"abc@gmail.com"]];
        composeVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:composeVC animated:YES completion:nil];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Mail services are not available." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



-(NSMutableAttributedString *)getMutableStringWithString:(NSString *)string font:(UIFont *)font spacing:(float )spacing textColor:(UIColor *)textColor lineSpacing:(CGFloat )lineSpacing andNSTextAlignment:(NSTextAlignment )alignment{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    if (font!=nil) {
        [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    }
    if (spacing!=0) {
        [attrStr addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:spacing] range:NSMakeRange(0, string.length)];
    }
    if (textColor!=nil) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, string.length)];
    }
    
    if (lineSpacing>0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = lineSpacing;
        paraStyle.alignment = alignment;
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    }
    
    
    return attrStr;
    
}


-(CGFloat )heightOfAttributesString:(NSAttributedString *)attrStr withWidth:(CGFloat )width{
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}

@end


@implementation EmployeeCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.empImg.layer.cornerRadius = 45;//20;
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}
-(IBAction)phoneNumberTapped:(id)sender{
    if (self.delegate) {
        [self.delegate phoneNumberTappedWithCell:self index:self.index];
    }
}
-(IBAction)emailTapped:(id)sender{
    if (self.delegate) {
        [self.delegate emailTappedWithCell:self index:self.index];
    }
}

@end



@implementation RequestEscalationCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end

@implementation RequestCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end


@implementation TimelineCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end


@implementation StatusFeedbackCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end




@implementation ProductInfoCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end

@implementation ReportCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 7;
}

@end


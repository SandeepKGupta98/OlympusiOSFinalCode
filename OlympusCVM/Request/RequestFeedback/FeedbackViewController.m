//
//  FeedbackViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 04/06/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UtilsManager.h"
#import "UIImageView+WebCache.h"

#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface FeedbackViewController ()<FeedbackCellDelegate, FeedbackRemarkCellDelegate>{
    NSMutableArray *feedbackAry;
    NSString *remarkString;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    remarkString = @"";
    self.loaderView.hidden = YES;
    
    feedbackAry = [[NSMutableArray alloc] init];
    [feedbackAry addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Response Speed",@"name",[NSNumber numberWithInt:0],@"rating", nil]];
    [feedbackAry addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Quality of Response",@"name",[NSNumber numberWithInt:0],@"rating", nil]];
    [feedbackAry addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"App Experience",@"name",[NSNumber numberWithInt:0],@"rating", nil]];
    [feedbackAry addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Performance of Olympus Employee",@"name",[NSNumber numberWithInt:0],@"rating", nil]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.cornerRadius = 7;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    
    [self createHeaderView];
    [self createFooterView];
    // Do any additional setup after loading the view.
}

-(void)createFooterView{
    
    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screen_wdth-40 , 100)];
//    [self.tableView setTableFooterView:footerView];
//    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth - 220)/2, 30, 180, 40)];
//    nextBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
//    [nextBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"SUBMIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
//    nextBtn.layer.cornerRadius = 7;
//    nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [nextBtn addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:nextBtn];
    
    
    // Fix Ratus Button
    _ratusBtn.layer.cornerRadius = 7;


}
-(IBAction)submitButtonTapped:(id)sender{
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}

    if ([[[feedbackAry objectAtIndex:0] valueForKey:@"rating"] intValue]==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Voice" message:@"Kindly rate \"Response speed\" before proceed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([[[feedbackAry objectAtIndex:1] valueForKey:@"rating"] intValue]==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Voice" message:@"Kindly rate \"Quality of response\" before proceed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([[[feedbackAry objectAtIndex:2] valueForKey:@"rating"] intValue]==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Voice" message:@"Kindly rate \"App Experience\" before proceed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([[[feedbackAry objectAtIndex:3] valueForKey:@"rating"] intValue]==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Voice" message:@"Kindly rate \"Olympus staff performance\" before proceed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    remarkString = [remarkString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (remarkString.length==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Voice" message:@"Kindly enter remarks." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:Auth_Token forKey:Auth_Token_KEY];
    [param setObject:self.requestId forKey:@"request_id"];
    [param setObject:[NSString stringWithFormat:@"%@",[[feedbackAry objectAtIndex:0] valueForKey:@"rating"]] forKey:@"response_speed"];
    [param setObject:[NSString stringWithFormat:@"%@",[[feedbackAry objectAtIndex:1] valueForKey:@"rating"]] forKey:@"quality_of_response"];
    [param setObject:[NSString stringWithFormat:@"%@",[[feedbackAry objectAtIndex:2] valueForKey:@"rating"]] forKey:@"app_experience"];
    [param setObject:[NSString stringWithFormat:@"%@",[[feedbackAry objectAtIndex:3] valueForKey:@"rating"]] forKey:@"olympus_staff_performance"];
    [param setObject:remarkString forKey:@"remarks"];

    NSLog(@"param: %@",param);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.loaderView.hidden = NO;
    NSString *apiurl;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *access_token = [userData valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
    
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        apiurl = [NSString stringWithFormat:@"%@/api/v2/service/feedback",[userData valueForKey:@"testing_url"]];
    }else{
        apiurl = [NSString stringWithFormat:@"%@/api/v2/service/feedback",base_url];
    }

    [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            
            NSString *reqId = [[[[responseDict valueForKey:@"data"] valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject];
            
            NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
            NSString *username;
            username = [NSString stringWithFormat:@"%@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Dear %@",username] message:[NSString stringWithFormat:@"Thank you for sharing your feedback for the request ID:%@. Your feedback is valuable to us.",reqId] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self crossButtonTapped:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }
        
        
        NSLog(@"success! with response: %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        NSLog(@"error: %@", error.localizedDescription);
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
#pragma mark-  Keyboard Method

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)hideKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        if([self tabBarController] && ![[[self tabBarController] tabBar] isHidden]){
            self.tableViewBottomMargin.constant = keyboardSize.height-50;
        } else {
            self.tableViewBottomMargin.constant = keyboardSize.height;
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.tableViewBottomMargin.constant = 80;
    }];
}
#pragma mark- UITableView Methods
-(void)createHeaderView{
    float y=10;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_wdth-40, 100)];
    [self.tableView setTableHeaderView:headerView];
    
    
//    self.feedbackLbl.text = [NSString stringWithFormat:@"Thanks you so much for using My Voice App! How was your experience with service support %@ on %@.",self.name,self.createdAt];
    //    Thanks you so much for using My Voice App! How was your experience with service support Mr. ABC on 26th Oct 2018  Mr. ABC on 26th Oct 2018


    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 100)];
    lbl.numberOfLines = 0;
    

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:self.createdAt];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    lbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"Thank you so much for using My Voice App! How was your Experience with our representative %@ on %@.",self.name,[dateFormatter stringFromDate:yourDate]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0]
    
    float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:lbl.attributedText withWidth:screen_wdth-80]+10;
    lbl.frame = CGRectMake(20, y, screen_wdth-80, lglHgt);
    [headerView addSubview:lbl];
    y = y+lglHgt;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((screen_wdth-140)/2, y, 100, 100)];
    img.layer.cornerRadius = 50;
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    [img sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]];
    [headerView addSubview:img];
    y = y+110;


    
    UILabel *callNo = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 20)];
    callNo.text = [@"Request No :" uppercaseString];//@"NUMBER :";//
    callNo.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    callNo.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    callNo.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:callNo];
    y = y+20;
    
    UILabel *callNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 25)];
    callNoLbl.text = [NSString stringWithFormat:@"%@",self.requestId];
    callNoLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:17.0];
    callNoLbl.textColor = [UIColor whiteColor];
    callNoLbl.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:callNoLbl];
    y = y+35;

    UILabel *reqTypeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 20)];
    reqTypeTitle.text = [@"Request Type :" uppercaseString];//@"NUMBER :";//
    reqTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    reqTypeTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    reqTypeTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:reqTypeTitle];
    y = y+20;
    
    UILabel *reqType = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 25)];
    reqType.text = [self.requestType capitalizedString];
    reqType.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:17.0];
    reqType.textColor = [UIColor whiteColor];
    reqType.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:reqType];
    y = y+35;

    
    UILabel *reqSubTypeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 20)];
    reqSubTypeTitle.text = [@"Request Subtype :" uppercaseString];//@"NUMBER :";//
    reqSubTypeTitle.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0];
    reqSubTypeTitle.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    reqSubTypeTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:reqSubTypeTitle];
    y = y+20;
    
    UILabel *reqSubType = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 25)];
    reqSubType.text = [self.requestSubType capitalizedString];
    reqSubType.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:17.0];
    reqSubType.textColor = [UIColor whiteColor];
    reqSubType.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:reqSubType];
    y = y+35;

    
    
    UILabel *remarkTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 20)];
    remarkTitleLbl.text = @"REMARKS :";
    remarkTitleLbl.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:17.0];
    remarkTitleLbl.textColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    remarkTitleLbl.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:remarkTitleLbl];
    y = y+20;
    
    
    
    
    
    
    
    NSString *remarkString = @"";
    if (self.requestRemark !=nil) {
        remarkString =  self.requestRemark;
    }
    if (remarkString == nil) {
        remarkString = @"";
    }
    
    NSMutableAttributedString *atrStr = [[UtilsManager sharedObject] getMutableStringWithString:remarkString font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:3 andNSTextAlignment:NSTextAlignmentLeft];
    
    UILabel *remark = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 20)];
    remark.attributedText = atrStr;
    remark.numberOfLines = 0;
    remark.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:remark];
    float hgt =[[UtilsManager sharedObject] heightOfAttributesString:atrStr withWidth:screen_wdth-80]+20;
    remark.frame = CGRectMake(20, y, screen_wdth-80, hgt);
    y = y+hgt+10;

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-80, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:line];
    y = y+1;

    
    headerView.frame = CGRectMake(0, 0, screen_wdth-40, y);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == feedbackAry.count) {
        return 180;
    }else{
        return 110;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return feedbackAry.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == feedbackAry.count) {
        FeedbackRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackRemarkCell"];
        if (cell == nil) {
            cell = [[FeedbackRemarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedbackRemarkCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        FeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedbackCell"];
        if (cell == nil) {
            cell = [[FeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"feedbackCell"];
        }
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.name.text = [[feedbackAry objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell setFeedbackValue:[[[feedbackAry objectAtIndex:indexPath.row] valueForKey:@"rating"] intValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark- FeedbackCellDelagate Methods

- (void)firstStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    [feedbackAry replaceObjectAtIndex:index withObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[cell.name text],@"name",[NSNumber numberWithInt:1],@"rating", nil]];
}
- (void)secondStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    [feedbackAry replaceObjectAtIndex:index withObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[cell.name text],@"name",[NSNumber numberWithInt:2],@"rating", nil]];

}
- (void)thirdStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    [feedbackAry replaceObjectAtIndex:index withObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[cell.name text],@"name",[NSNumber numberWithInt:3],@"rating", nil]];

}
- (void)forthStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    [feedbackAry replaceObjectAtIndex:index withObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[cell.name text],@"name",[NSNumber numberWithInt:4],@"rating", nil]];

}
- (void)fifthStarTappedWithCell:(FeedbackCell *)cell andIndex:(NSInteger)index{
    [self hideKeyboard];
    [feedbackAry replaceObjectAtIndex:index withObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[cell.name text],@"name",[NSNumber numberWithInt:5],@"rating", nil]];
}
#pragma mark- FeedbackRemarkCellDelegate Methods

- (void)textViewString:(NSString *)textViewText{
    remarkString = textViewText;
    NSLog(@"textViewText: %@",remarkString);
}

- (IBAction)crossButtonTapped:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        if (self.delegate) {
            [self.delegate dismissFeedbackViewController];
        }
    }
}
@end

@implementation FeedbackCell
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setFeedbackValue:(int )rating{
    if (rating ==1) {
        [self.firstStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];

    }else if (rating ==2){
        [self.firstStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
    }else if (rating ==3){
        [self.firstStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
    }else if (rating ==4){
        [self.firstStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
    }else if (rating ==5){
        [self.firstStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"select_star.png"] forState:UIControlStateNormal];
    }else{
        [self.firstStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.secondStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.thirdStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.forthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
        [self.fifthStar setImage:[UIImage imageNamed:@"unselect_star.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)firstStarTapped:(id)sender {
    [self setFeedbackValue:1];
    if (self.delegate) {
        [self.delegate firstStarTappedWithCell:self andIndex:self.index];
    }
}
- (IBAction)secondStarTapped:(id)sender {
    [self setFeedbackValue:2];
    if (self.delegate) {
        [self.delegate secondStarTappedWithCell:self andIndex:self.index];
    }
}
- (IBAction)thirdStarTapped:(id)sender {
    [self setFeedbackValue:3];
    if (self.delegate) {
        [self.delegate thirdStarTappedWithCell:self andIndex:self.index];
    }
}

- (IBAction)forthStarTapped:(id)sender {
    [self setFeedbackValue:4];
    if (self.delegate) {
        [self.delegate forthStarTappedWithCell:self andIndex:self.index];
    }
}
- (IBAction)fifthStarTapped:(id)sender {
    [self setFeedbackValue:5];
    if (self.delegate) {
        [self.delegate fifthStarTappedWithCell:self andIndex:self.index];
    }
}
@end


@implementation FeedbackRemarkCell
-(void)awakeFromNib{
    [super awakeFromNib];
//    self.textView.backgroundColor = [UIColor colorWithRed:16/255.0 green:28/255.0 blue:113/255.0 alpha:1.0];
    self.textView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 7;

}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];

    if (self.delegate) {
        [self.delegate textViewString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }

    return YES;
}
@end

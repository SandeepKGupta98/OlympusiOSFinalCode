//
//  RequestEscalationViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 30/05/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "RequestEscalationViewController.h"
#import "UtilsManager.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface RequestEscalationViewController ()<UITextFieldDelegate, EscalationCellDelegate>{
    UITextField *ansTextField;
    UITextField *depTextField;
    UITextView *remarkTextView;
    CGFloat scrolContainHgt;
    NSMutableArray *ansAry;
    NSMutableArray *selectedAnsAry;
    float ansY;
    UIButton *sendBtn;
    UILabel *remarkTitle;
    UIView *selectedAnsView;
}

@end

/*
 if (index == 0) {
 historyVC.type = @"service";
 }else if(index == 1){
 historyVC.type = @"enquiry";
 }else{
 historyVC.type = @"academic";
 }
 
*/

@implementation RequestEscalationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrolContainHgt = 0;
    self.ansView.hidden = YES;
    self.loaderView.hidden = YES;
    
    selectedAnsAry = [[NSMutableArray alloc] init];
    ansAry = [[NSMutableArray alloc] init];
//    for (int i=0; i<10; i++) {
//        [ansAry addObject:[NSString stringWithFormat:@"Answer : %d",i]];
//    }
    if ([self.reqType isEqualToString:@"service"]) {
        [ansAry addObject:@"Product related issue"];
        [ansAry addObject:@"Delivery related issue"];
        [ansAry addObject:@"Loaner related issue"];
        [ansAry addObject:@"Repair related issue"];
        [ansAry addObject:@"Installation related issue"];
        [ansAry addObject:@"Service Contract related issue"];
        [ansAry addObject:@"No response from Olympus"];
        [ansAry addObject:@"Delayed action from Olympus"];
        [ansAry addObject:@"Other"];

    }else if ([self.reqType isEqualToString:@"service"]){
        [ansAry addObject:@"Product related issue"];
        [ansAry addObject:@"Demo related issue"];
        [ansAry addObject:@"Quotation related issue"];
        [ansAry addObject:@"Delivery related issue"];
        [ansAry addObject:@"No response from olympus"];
        [ansAry addObject:@"Delayed action from Olympus"];
        [ansAry addObject:@"Other"];
    }else{
        [ansAry addObject:@"I did not get enough information"];
        [ansAry addObject:@"No response from olympus"];
        [ansAry addObject:@"Delayed action from Olympus"];
        [ansAry addObject:@"Other"];
    }

    

    
    

    self.doneBtn.layer.cornerRadius = 7;

    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
//    self.tableView.layer.cornerRadius = 7;
//    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    self.tableView.layer.borderWidth = 1;

//    [self createFooterView];
    [self createScrollSubView];
    

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.ansView.hidden = NO;
    return NO;
}
#pragma mark-  Scroll SubView Method

-(void)createScrollSubView{
    CGFloat y=30;
    CGFloat tabHgt = [self.tabBarController tabBar].bounds.size.height;
    
    
    CGFloat titleHgt = 30;
    CGFloat textFieldHgt = 40;
    CGFloat sendBtnHgt = 40;
    CGFloat sendBtnWdth = 120;
    CGFloat textFieldFont = 14;
    CGFloat titleFont = 13;
    CGFloat cornerRadius = 7;
    CGFloat topHgt = 100;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        titleHgt = 45;
        textFieldHgt = 60;
        sendBtnHgt = 60;
        sendBtnWdth = 180;
        textFieldFont = 22;
        titleFont = 20;
        cornerRadius = 10;
        topHgt = 180;
    }
    
    UILabel *queTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, titleHgt)];
    queTitle.numberOfLines = 0;
    
    queTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"Sorry for inconvenience. Kindly select the reason of escalation." font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [[UtilsManager sharedObject] createShadowForLabel:queTitle];
    titleHgt = [[UtilsManager sharedObject] heightOfAttributesString:queTitle.attributedText withWidth:screen_wdth-100];
    queTitle.frame = CGRectMake(50, y, screen_wdth-100, titleHgt);
    [self.scrollView addSubview:queTitle];
    y = y+titleHgt+10;
    
    ansTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, textFieldHgt)];
    ansTextField.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:textFieldFont];
    ansTextField.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"Select Reasons" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    ansTextField.textColor = [UIColor whiteColor];
    ansTextField.delegate = self;
    ansTextField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    ansTextField.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
    ansTextField.layer.borderWidth =  1.0f;
    ansTextField.layer.cornerRadius = cornerRadius;
    ansTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UIView *downArrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 12, 14)];
    arrow.image = [UIImage imageNamed:@"down_arrow_w.png"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    [downArrow addSubview:arrow];
    ansTextField.rightView = downArrow;
    ansTextField.rightViewMode = UITextFieldViewModeAlways;
    ansTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:ansTextField];
    
    UITapGestureRecognizer *hospitalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hospitalArrowTapped:)];
    hospitalTap.numberOfTapsRequired = 1;
    [downArrow addGestureRecognizer:hospitalTap];
    y = y+textFieldHgt+10;
    ansY = y;
    
    
    remarkTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 20)];
    remarkTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"REMARKS" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    
    [[UtilsManager sharedObject] createShadowForLabel:remarkTitle];
    [self.scrollView addSubview:remarkTitle];
    y = y+20;
    
    
    CGFloat remarkTextViewHgt = 0;
    remarkTextViewHgt = screen_hgt - topHgt - y - tabHgt - sendBtnHgt - 60 ;
    remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, remarkTextViewHgt)];//screen_hgt-tabHgt-200 - y
    remarkTextView.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:textFieldFont];
    remarkTextView.textColor = [UIColor whiteColor];
    remarkTextView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    remarkTextView.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
    remarkTextView.layer.borderWidth =  1.0f;
    remarkTextView.layer.cornerRadius = cornerRadius;
    remarkTextView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.scrollView addSubview:remarkTextView];
    y = y+remarkTextViewHgt+30;//(screen_hgt-tabHgt-200 - y)
    
    
    sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-sendBtnWdth)/2, y, sendBtnWdth, sendBtnHgt)];
    sendBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [sendBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"ESCALATE" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont-1] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    [[UtilsManager sharedObject] createShadowForLabel:(UILabel *)sendBtn];
    [sendBtn addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = cornerRadius;
    
    [self.scrollView addSubview:sendBtn];
    y = y+sendBtnHgt+30;
    scrolContainHgt = y;
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}
-(void)createRestView{
    float y = ansY;
    
    [selectedAnsView removeFromSuperview];
    if (selectedAnsAry.count>0) {
        float yy = 0;

        selectedAnsView = [[UIView alloc] initWithFrame:CGRectMake(0, y, screen_wdth, 40)];
        [self.scrollView addSubview:selectedAnsView];
        
        UILabel *ansTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, yy, screen_wdth-100, 20)];
        ansTitle.numberOfLines = 0;
        ansTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"ANSWERS" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
//        ansTitle.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [[UtilsManager sharedObject] createShadowForLabel:ansTitle];
        [selectedAnsView addSubview:ansTitle];
        yy = yy+20;
        
        
        for (int i=0; i<selectedAnsAry.count; i++) {
            UIView *ansBgView = [[UIView alloc] initWithFrame:CGRectMake(50, yy, screen_wdth-100, 60)];
            ansBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
            ansBgView.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
            ansBgView.layer.borderWidth =  1.0f;
            ansBgView.layer.cornerRadius = 7;
            [selectedAnsView addSubview:ansBgView];

            UILabel *ans = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_wdth-150, 60)];
            ans.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:13];
            ans.text = [selectedAnsAry objectAtIndex:i];
            ans.textColor = [UIColor whiteColor];
            ans.numberOfLines = 0;
            [ansBgView addSubview:ans];
            
            UIImageView *crossImg = [[UIImageView alloc] initWithFrame:CGRectMake(screen_wdth-125, 22, 15, 15)];
            crossImg.contentMode = UIViewContentModeScaleAspectFit;
            crossImg.image = [UIImage imageNamed:@"yellow_cross.png"];
            [ansBgView addSubview:crossImg];

            UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_wdth-130, 17, 25, 25)];
            deleteBtn.tag = 1111111+i;
            [deleteBtn addTarget:self action:@selector(deleteAnswerBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//            [deleteBtn setImage:[UIImage imageNamed:@"yellow_cross.png"] forState:UIControlStateNormal];//delete.png
            [ansBgView addSubview:deleteBtn];

            
            yy = yy+70;
        }
        selectedAnsView.frame = CGRectMake(0, y, screen_wdth, yy);
        y = yy+y+10;

    }
    
    
    remarkTitle.frame = CGRectMake(50, y, screen_wdth-100, 20);
    y = y+20;
    remarkTextView.frame = CGRectMake(50, y, screen_wdth-100, remarkTextView.bounds.size.height);
    y = y+remarkTextView.bounds.size.height+30;
    
    sendBtn.frame = CGRectMake((screen_wdth-sendBtn.bounds.size.width)/2, y, sendBtn.bounds.size.width, sendBtn.bounds.size.height);
    y = y+sendBtn.bounds.size.height+30;
    scrolContainHgt = y;
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}

-(void)deleteAnswerBtnTapped:(UIButton *)btn{
    NSInteger index = btn.tag-1111111;
    NSString *ansStr = [selectedAnsAry objectAtIndex:index];
    [selectedAnsAry removeObject:ansStr];
    [self createRestView];
    [self.tableView reloadData];

}
-(void)hospitalArrowTapped:(UIButton *)sender{
    self.ansView.hidden = NO;

}
-(void)nextButtonTapped:(UIButton *)sender{
    
    if (selectedAnsAry.count>0) {
        NSError *error = nil;
        NSString *createJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:selectedAnsAry options:nil error:&error] encoding:NSUTF8StringEncoding];//NSJSONWritingPrettyPrinted
        
        
        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selectedAnsAry options:NSJSONWritingPrettyPrinted error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"jsonString:%@",jsonString);
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        
        [param setObject:Auth_Token forKey:Auth_Token_KEY];
        [param setObject:self.reqId forKey:@"request_id"];
        [param setObject:createJSON forKey:@"reasons"];
        [param setObject:remarkTextView.text forKey:@"remarks"];
        
        NSLog(@"param: %@",param);
        
        if (![[UtilsManager sharedObject] checkUserActivityValid]){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
            return;
        }
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSSet *accptableTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
        [manager.responseSerializer setAcceptableContentTypes:accptableTypes];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.loaderView.hidden = NO;
        
        
        NSString *url;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        NSString *access_token = [userData valueForKey:@"access_token"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v2/service/escalate",[userData valueForKey:@"testing_url"]];
        }else{
            url = [NSString stringWithFormat:@"%@/api/v2/service/escalate",base_url];
        }

        [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.loaderView.hidden = YES;
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                
                
                NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
                NSString *username;
                if([[userInfo valueForKey:@"middle_name"] isKindOfClass:[NSNull class]]){
                    username = [NSString stringWithFormat:@"%@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
                }else{
                    if ([[userInfo valueForKey:@"middle_name"] length]>0) {
                        username = [NSString stringWithFormat:@"%@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
                    }else{
                        username = [NSString stringWithFormat:@"%@ %@ %@ %@",[userInfo valueForKey:@"title"],[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"middle_name"],[userInfo valueForKey:@"last_name"]];
                    }
                }

                NSDictionary *reqInfo = [NSDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Dear %@",username] message:[NSString stringWithFormat:@"Your request id : %@ has been escalated.",[[[reqInfo valueForKey:@"cvm_id"] componentsSeparatedByString:@"/"] lastObject]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popToRootViewControllerAnimated:NO];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
                [[UtilsManager sharedObject] sessionExpirePopup:self];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
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
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select at least one reason for escalation." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonTapped:(id)sender{
    if(self.navigationController == nil){
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
        
}

#pragma mark-  Keyboard Method

-(void)hideKeyboard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

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
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGFloat tabHgt = [self.tabBarController tabBar].bounds.size.height;
    CGFloat keyboardSizeHgt = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height-tabHgt;
    
    
    self.scrollView.contentSize = CGSizeMake(screen_wdth, scrolContainHgt+keyboardSizeHgt);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.scrollView.contentSize = CGSizeMake(screen_wdth, scrolContainHgt);
}

#pragma mark-  Answer Tableview Method
-(void)createFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,screen_wdth, 150)];
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-100)/2, 55,100, 40)];
    done.layer.cornerRadius = 7;
    done.titleLabel.font = [UIFont fontWithName:@"EncodeSansNormal-Medium" size:13];
    [done setTitle:@"DONE" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    done.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [done addTarget:self action:@selector(footerDoneBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:done];
    self.tableView.tableFooterView = footerView;
}

- (IBAction)doneButtonTapped:(id)sender{
    [self hideKeyboard];
    self.ansView.hidden = YES;
    NSLog(@"selectedAnsAry: %@",selectedAnsAry);
    [self createRestView];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ansAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EscalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[EscalationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    if ([selectedAnsAry containsObject:[ansAry objectAtIndex:indexPath.row]]) {
        cell.checkboxImg.image = [UIImage imageNamed:@"checkbox.png"];
    }else{
        cell.checkboxImg.image = [UIImage imageNamed:@"uncheckbox.png"];
    }

    cell.ansLbl.text =  [ansAry objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)buttonTappedWithCell:(EscalationCell *)cell anIndex:(NSInteger)index{
    [self hideKeyboard];

    if ([selectedAnsAry containsObject:[ansAry objectAtIndex:index]]) {
        [selectedAnsAry removeObject:[ansAry objectAtIndex:index]];
    }else{
        [selectedAnsAry addObject:[ansAry objectAtIndex:index]];
    }
    [self.tableView reloadData];

    
    
    
//    ansTextField.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[ansAry objectAtIndex:index] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:12] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];

}

-(void)footerDoneBtnTapped{

}
- (IBAction)hideAnsList:(id)sender {
    self.ansView.hidden = YES;
//    [selectedAnsAry removeAllObjects];
//    [self.tableView reloadData];
}

@end



@implementation EscalationCell
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)buttonTapped:(id)sender {
    if (_delegate) {
        [_delegate buttonTappedWithCell:self anIndex:self.index];
    }
    
}
@end

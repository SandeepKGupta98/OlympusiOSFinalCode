
//
//  InboxDetailViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 20/12/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "InboxDetailViewController.h"
#import "PDFReaderViewController.h"
#import "UtilsManager.h"
#import "UIImageView+WebCache.h"
#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface InboxDetailViewController (){
    NSMutableDictionary *inboxDetailInfo;
    NSArray *dataAry;
}

@end

@implementation InboxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.loaderView.hidden = YES;
    self.scrollView.layer.cornerRadius = 7;
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    inboxDetailInfo = [[NSMutableDictionary alloc] init];
    [self getInboxFromServer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-  Get Inbox From Servar Method
-(void)getInboxFromServer{
    if (!_mailId) {
        return;
    }
    if (![[UtilsManager sharedObject] checkUserActivityValid]){
        [[UtilsManager sharedObject] sessionExpirePopup:self];
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue] != YES) {return;}

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
        self.loaderView.hidden = NO;
//    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:Auth_Token_New forKey:Auth_Token_KEY];
    [param setObject:_mailId forKey:@"id"];
    
    
    NSString *apiurl;
    NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
    NSString *access_token = [userData valueForKey:@"access_token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];
    if ([[userData valueForKey:@"is_testing"] boolValue]) {
        apiurl = [NSString stringWithFormat:@"%@/api/v2/getPromailer",[userData valueForKey:@"testing_url"]];
    }else{
        apiurl = [NSString stringWithFormat:@"%@/api/v2/getPromailer",base_url];
    }

    [manager POST:apiurl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loaderView.hidden = YES;
        NSLog(@"success! with response: %@", responseObject);
        NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
        
        if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
            inboxDetailInfo = [NSMutableDictionary dictionaryWithDictionary:[responseDict valueForKey:@"data"]];
                               
            [self createScrollSubView];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
        }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
            [[UtilsManager sharedObject] showPasswordExpirePopup:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loaderView.hidden = YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
-(void)createScrollSubView{
    float y = 10;
    
//    created_at
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:[inboxDetailInfo valueForKey:@"created_at"]];
    dateFormatter.dateFormat = @"dd MMM yyyy";
    NSString *created_at = [dateFormatter stringFromDate:yourDate];
    NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"DATE :" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0.5 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [attributedText appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:created_at font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    titleLbl.attributedText = attributedText;
    [self.scrollView addSubview: titleLbl];
    y=y+40;

    
    
    
    
    
    NSString *body = [inboxDetailInfo valueForKey:@"body"];
    dataAry = [NSJSONSerialization JSONObjectWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    for (int i=0; i<dataAry.count; i++) {
        NSDictionary *dataInfo = [dataAry objectAtIndex:i];
        
        if ([[dataInfo valueForKey:@"type"] isEqualToString:@"title"]) {
            y = [self createTitleWithY:y withInfo:dataInfo];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"image"]) {
            y = [self createImageWithY:y withInfo:dataInfo];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"paragraph"]) {
            y = [self createParaWithY:y withInfo:dataInfo];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"pdf"]) {
            y = [self createPDFWithY:y withInfo:dataInfo withIndex:i];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"phone"]) {
            y = [self createWeblinkWithY:y withInfo:dataInfo withIndex:i];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"url"]) {
            y = [self createWeblinkWithY:y withInfo:dataInfo withIndex:i];
        }else if ([[dataInfo valueForKey:@"type"] isEqualToString:@"email"]) {
            y = [self createWeblinkWithY:y withInfo:dataInfo withIndex:i];
        }
    }
    
    UILabel *thankLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 60)];
    thankLbl.numberOfLines = 0;
    NSMutableAttributedString *thankLblText = [[UtilsManager sharedObject] getMutableStringWithString:@"Thank you!\n" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [thankLblText appendAttributedString:[[UtilsManager sharedObject] getMutableStringWithString:@"Olympus India" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft]];
    
    thankLbl.attributedText = thankLblText;
    [self.scrollView addSubview: thankLbl];
    y=y+60;

    self.scrollView.contentSize = CGSizeMake(screen_wdth-100, y+10);
    
}
-(float)createTitleWithY:(float)y withInfo:(NSDictionary *)dict{
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    titleLbl.numberOfLines = 0;
    NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"value"]] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:15.0] spacing:0.5 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    titleLbl.attributedText = attributedText;
    [self.scrollView addSubview: titleLbl];
    float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:screen_wdth-100]+10;
    titleLbl.frame = CGRectMake(20, y, screen_wdth-100, lglHgt);
    y=y+lglHgt;
    return y;
}

-(float)createImageWithY:(float)y withInfo:(NSDictionary *)dict{
    y=y+10;

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, screen_wdth-100)];
    img.layer.cornerRadius = 7;
    img.clipsToBounds = YES;
    img.contentMode = UIViewContentModeScaleAspectFit;
    [img sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"value"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
//    [img sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"value"]]];
    [self.scrollView addSubview: img];
    y=y+screen_wdth-100;
    y=y+10;
    return y;
}

-(float)createParaWithY:(float)y withInfo:(NSDictionary *)dict{
    //    UITextView *titleLbl = [[UITextView alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    titleLbl.backgroundColor = [UIColor clearColor];
//    titleLbl.scrollEnabled = NO;
//    titleLbl.selectable = YES;
//    titleLbl.editable = NO;
//    titleLbl.dataDetectorTypes = UIDataDetectorTypeAll;
    titleLbl.numberOfLines = 0;
    NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[dict valueForKey:@"value"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    titleLbl.attributedText = attributedText;
    [self.scrollView addSubview: titleLbl];
    float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:screen_wdth-100]+10;
    lglHgt = ceil(lglHgt);
    titleLbl.frame = CGRectMake(20, y, screen_wdth-100, lglHgt);
    y=y+lglHgt;
    return y;
}
    
-(float)createPDFWithY:(float)y withInfo:(NSDictionary *)dict withIndex:(NSInteger )index{
    y=y+10;
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"For more info, refer to attached file." font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    titleLbl.attributedText = attributedText;
    [self.scrollView addSubview: titleLbl];
    float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:screen_wdth-100]+10;
    titleLbl.frame = CGRectMake(20, y, screen_wdth-100, lglHgt);
    y=y+lglHgt;
    y=y+15;
    
    
    
    UIImageView *pdf_icon = [[UIImageView alloc] initWithFrame:CGRectMake(30, y, 40, 40)];
    pdf_icon.image = [UIImage imageNamed:@"pdf_icon.png"];
    pdf_icon.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview: pdf_icon];

    UILabel *pdfLabl = [[UILabel alloc] initWithFrame:CGRectMake(80, y, screen_wdth-170, 40)];
    pdfLabl.numberOfLines = 0;
    
    if ([dict valueForKey:@"file_name"]) {
        NSString *fileName = [dict valueForKey:@"file_name"];
        pdfLabl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[NSString stringWithFormat:@"%@",fileName] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    }else{
        pdfLabl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"See attachment" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    }
    [self.scrollView addSubview: pdfLabl];
    
    
    UIButton *pdf = [[UIButton alloc] initWithFrame:CGRectMake(20, y-5, screen_wdth-100, 50)];
    pdf.layer.cornerRadius = 7;
    pdf.layer.borderWidth = 1;
    pdf.layer.borderColor = [[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor];
    [pdf addTarget:self action:@selector(pdfLinkTapped:) forControlEvents:UIControlEventTouchUpInside];
    pdf.tag = index+92553;
    [self.scrollView addSubview: pdf];

    
    y=y+60;
    return y;
}

-(float)createWeblinkWithY:(float)y withInfo:(NSDictionary *)dict withIndex:(NSInteger) index{

    NSLog(@"dict : %@",dict);
    if (![dict valueForKey:@"value"]) {
        return y;
    }
    
    UITextView *titleLbl = [[UITextView alloc] initWithFrame:CGRectMake(20, y, screen_wdth-100, 40)];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.scrollEnabled = NO;
    titleLbl.selectable = YES;
    titleLbl.editable = NO;
    titleLbl.dataDetectorTypes = UIDataDetectorTypeAll;
    //    titleLbl.numberOfLines = 0;
    NSMutableAttributedString *attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[dict valueForKey:@"value"] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    titleLbl.attributedText = attributedText;
    [self.scrollView addSubview: titleLbl];
    float lglHgt = [[UtilsManager sharedObject] heightOfAttributesString:attributedText withWidth:screen_wdth-100]+10;
    titleLbl.frame = CGRectMake(20, y, screen_wdth-100, lglHgt);
    y=y+lglHgt;
    return y;
}


-(void)pdfLinkTapped:(UIButton *)btn{
    if (dataAry && dataAry.count) {
        NSInteger index = btn.tag - 92553;
        NSLog(@"dataAry: %@",[dataAry objectAtIndex:index]);
        NSDictionary *dataInfo = [dataAry objectAtIndex:index];

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        PDFReaderViewController *pDFReaderVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"pDFReaderVC"];
        pDFReaderVC.pdfUrl = [dataInfo valueForKey:@"value"] ;
        [self.navigationController pushViewController:pDFReaderVC animated:NO];
    }
}


@end





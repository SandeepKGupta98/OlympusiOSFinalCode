//
//  RemarksViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/02/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "RemarksViewController.h"
#import "ThankYouViewController.h"
#import "UtilsManager.h"
#import "MFSideMenuContainerViewController.h"
#import <Speech/Speech.h>


#define screen_hgt ([[UIScreen mainScreen] bounds].size.height)
#define screen_wdth ([[UIScreen mainScreen] bounds].size.width)

@interface RemarksViewController ()<ThankYouViewControllerDelegate,UIPickerViewDelegate,ProdCateCellDelegate,SFSpeechRecognizerDelegate>{
    NSMutableArray *hospitalAry;
    NSMutableArray *depAry;
    NSMutableArray *cateAry;
    NSMutableArray *selectCateAry;
    NSString *selectCate;
    CGFloat scrolContainHgt;
    UITextField *hosTextField;
    UITextField *depTextField;
    UITextField *cateTextField;
    UITextView *remarkTextView;
    BOOL isHospital;

    UILabel *remarkTitle;
    NSMutableDictionary *selectedHospital, *selectedDeparment;
    
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    AVAudioEngine *audioEngine;
}

@end

@implementation RemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    scrolContainHgt = 0;
    isHospital = NO;
    selectCate = @"";
    self.doneButton.layer.cornerRadius = 7;
    self.loaderView.hidden = YES;
    self.prodCateView.hidden = YES;
    self.pickerBgView.hidden = YES;
    selectCateAry  = [[NSMutableArray alloc] init];
    selectedHospital = [[NSMutableDictionary alloc] init];
    selectedDeparment = [[NSMutableDictionary alloc] init];
    self.pickerDoneButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Medium" size:14.0];
    hospitalAry = [[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:HOSARY_KEY];
    depAry = [[NSMutableArray alloc] init];
    cateAry = [NSMutableArray arrayWithObjects:@"Capital Product (Processor, Light Source, Monitor, Cautery, Scopes, etc) ",@"Therapeutic Devices (EndoTherapy Devices, Endosurgery Devices etc)",@"Other()", nil];//@"Accessory (EndoTherapy Devices, Endosurgery Devices etc)
    self.titleLbl.text = [self.superCate uppercaseString];
    self.titleLbl.hidden = YES;

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    [self createScrollSubView];
//    [self createHeaderView];
    

//    [self initialSetup];
    
}
-(NSArray *)getDeparmentArrayFromHospitalAry{
    NSMutableSet *depSet = [[NSMutableSet alloc] init];
    for (int i=0; i<hospitalAry.count; i++) {
//        NSString *deps = [[hospitalAry objectAtIndex:i] valueForKey:DEPNAME_KEY];
        NSArray *depAry = [[hospitalAry objectAtIndex:i] valueForKey:@"deptAry"];//[deps componentsSeparatedByString:@","];
        [depSet addObjectsFromArray:depAry];
    }
    return [depSet allObjects];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    UILabel *hosTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, titleHgt)];
    hosTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"HOSPITAL NAME" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [[UtilsManager sharedObject] createShadowForLabel:hosTitle];
    [self.scrollView addSubview:hosTitle];
    y = y+titleHgt;
    
    hosTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, textFieldHgt)];
    hosTextField.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:textFieldFont];
    hosTextField.textColor = [UIColor whiteColor];
    hosTextField.delegate = self;
    hosTextField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    hosTextField.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
    hosTextField.layer.borderWidth =  1.0f;
    hosTextField.layer.cornerRadius = cornerRadius;
    hosTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UIView *downArrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 12, 14)];
    arrow.image = [UIImage imageNamed:@"down_arrow_w.png"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    [downArrow addSubview:arrow];
    hosTextField.rightView = downArrow;
    hosTextField.rightViewMode = UITextFieldViewModeAlways;
    hosTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:hosTextField];
    
    UITapGestureRecognizer *hospitalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hospitalArrowTapped:)];
    hospitalTap.numberOfTapsRequired = 1;
    [downArrow addGestureRecognizer:hospitalTap];
    y = y+textFieldHgt+10;

    UILabel *depTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, titleHgt)];
    depTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"DEPARTMENT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    [[UtilsManager sharedObject] createShadowForLabel:depTitle];
    [self.scrollView addSubview:depTitle];
    y = y+titleHgt;
    
    depTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, textFieldHgt)];
    depTextField.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:textFieldFont];
    depTextField.textColor = [UIColor whiteColor];
    depTextField.delegate = self;
    depTextField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    depTextField.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
    depTextField.layer.borderWidth =  1.0f;
    depTextField.layer.cornerRadius = cornerRadius;
    depTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    UIView *downArrow1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 12, 14)];
    arrow1.image = [UIImage imageNamed:@"down_arrow_w.png"];
    arrow1.contentMode = UIViewContentModeScaleAspectFit;
    [downArrow1 addSubview:arrow1];

    depTextField.rightView = downArrow1;
    depTextField.rightViewMode = UITextFieldViewModeAlways;
    depTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.scrollView addSubview:depTextField];
    
    UITapGestureRecognizer *depTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(departmentArrowTapped:)];
    depTap.numberOfTapsRequired = 1;
    [downArrow1 addGestureRecognizer:depTap];

    y = y+textFieldHgt+10;
    
    
    
//    (lldb) po [self.superCate lowercaseString]
//    enquiry

    if ([[self.superCate lowercaseString] isEqualToString:@"enquiry"]) {
        UILabel *cateTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, titleHgt)];
        cateTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:@"PRODUCT CATEGORY" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
        [[UtilsManager sharedObject] createShadowForLabel:cateTitle];
        [self.scrollView addSubview:cateTitle];
        y = y+titleHgt;
        
        cateTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, textFieldHgt)];
        cateTextField.font = [UIFont fontWithName:@"EncodeSansNormal-Regular" size:textFieldFont];
        cateTextField.textColor = [UIColor whiteColor];
        cateTextField.delegate = self;
        cateTextField.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        cateTextField.layer.borderColor = [[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0f] CGColor];
        cateTextField.layer.borderWidth =  1.0f;
        cateTextField.layer.cornerRadius = cornerRadius;
        cateTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        UIView *downArrow2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 12, 14)];
        arrow2.image = [UIImage imageNamed:@"down_arrow_w.png"];
        arrow2.contentMode = UIViewContentModeScaleAspectFit;
        [downArrow2 addSubview:arrow2];
        
        cateTextField.rightView = downArrow2;
        cateTextField.rightViewMode = UITextFieldViewModeAlways;
        cateTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.scrollView addSubview:cateTextField];
        
        UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cateArrowTapped:)];
        cateTap.numberOfTapsRequired = 1;
        [downArrow2 addGestureRecognizer:cateTap];
        y = y+textFieldHgt+10;
    }

    
    
    
    
    
    
    
    

    remarkTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, titleHgt)];
    if ([self.superCate.lowercaseString isEqualToString:@"academic"]) {
        
        remarkTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[@"Request/Requirement" uppercaseString] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    }else if ([self.superCate.lowercaseString isEqualToString:@"enquiry"]) {
        
        remarkTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[@"Requirement" uppercaseString] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    }else{
        
        remarkTitle.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[@"REMARKS" uppercaseString] font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont] spacing:0 textColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] lineSpacing:0 andNSTextAlignment:NSTextAlignmentLeft];
    }
    [[UtilsManager sharedObject] createShadowForLabel:remarkTitle];
    [self.scrollView addSubview:remarkTitle];
    y = y+titleHgt;
    // tabHgt + sendBtnHgt+ 60 + 100 iphone
    // 180 ipad + sendBtnHgt + 60
    
    
//    UIButton *micBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, y, screen_wdth-100, 40)];
//    [micBtn setTitle:@"Start Rec" forState:UIControlStateNormal];
//    [micBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
////    [micBtn addTarget:self action:@selector(microphoneTapped) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollView addSubview:micBtn];
//
//    y = y+50;

    
    CGFloat remarkTextViewHgt = 0;
    remarkTextViewHgt = (screen_wdth-100)*0.8;//screen_hgt - topHgt - y - tabHgt - sendBtnHgt - 60 ;
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


    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake((screen_wdth-sendBtnWdth)/2, y, sendBtnWdth, sendBtnHgt)];
    sendBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0];
    [sendBtn setAttributedTitle:[[UtilsManager sharedObject] getMutableStringWithString:@"SUBMIT" font:[UIFont fontWithName:@"EncodeSansNormal-Medium" size:titleFont-1] spacing:0.5 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter] forState:UIControlStateNormal];
    [[UtilsManager sharedObject] createShadowForLabel:(UILabel *)sendBtn];
    [sendBtn addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = cornerRadius;

    [self.scrollView addSubview:sendBtn];
    y = y+sendBtnHgt+30;
    scrolContainHgt = y;
    self.scrollView.contentSize = CGSizeMake(screen_wdth, y);
}

#pragma mark-  Dictation Method
-(void)initialSetup{
    //The app's Info.plist must contain an NSSpeechRecognitionUsageDescription key with a string value explaining to the user how the app uses this data
    speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    speechRecognizer.delegate = self;
    audioEngine = [[AVAudioEngine alloc] init];
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                
                break;
                
            default:
                break;
                
                
                //                [[NSOperationQueue mainQueue] addOperation:<#(nonnull NSOperation *)#>]
        }
    }];
}
-(void)microphoneTapped{
    if ([audioEngine isRunning]) {
        [audioEngine stop];
        [recognitionRequest endAudio];
    }else{
        [self startRecording];
    }
}
-(void)startRecording{
    if (recognitionTask != nil) {  //1
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];  //2
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    if (!error) {
        [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
        if (!error) {
            [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
            if (error) {
                return;
            }
        }
        
    }

    recognitionRequest =[[SFSpeechAudioBufferRecognitionRequest alloc] init];//3
    AVAudioInputNode *inputNode = [audioEngine inputNode];
    if (!inputNode) {
        NSLog(@"Audio engine has no input node");
    }//4

    if (!recognitionRequest) {
        NSLog(@"Unable to create an SFSpeechAudioBufferRecognitionRequest object");
    }//5

    
    recognitionRequest.shouldReportPartialResults = YES;  //6
    
    recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal =  NO;
        if (!result) {
            NSLog(@"%@",[[result bestTranscription] formattedString]);//9
            isFinal = [result isFinal];
        }
        if (!error || isFinal) {//10
            [audioEngine stop];
            [inputNode removeTapOnBus:0];
            
            recognitionRequest = nil;
            recognitionTask = nil;

        }
    }];

    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];//11
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [audioEngine prepare ];  //12
    NSError *err;
    [audioEngine startAndReturnError:&err ];
    

}

#pragma mark-  UITextField Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideKeyboard];
    if (textField == hosTextField) {
        isHospital = YES;
        self.pickerBgView.hidden = NO;
        self.pickerView.delegate = self;
        [self.pickerView reloadAllComponents];
    }else if (textField == cateTextField){
        self.prodCateView.hidden = NO;
        self.pickerBgView.hidden = YES;
        [self.tableView reloadData];
    }else{
        isHospital = NO;
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        if (hosTextField.text.length==0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select hospital first." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            self.pickerBgView.hidden = NO;
        }
        self.pickerView.delegate = self;
        [self.pickerView reloadAllComponents];
    }
    return NO;
}

-(void)cateArrowTapped:(UITapGestureRecognizer *)ges{
    NSLog(@"cateArrowTapped");
    isHospital = NO;
    [self hideKeyboard];
    self.prodCateView.hidden = NO;
    self.pickerBgView.hidden = YES;
    [self.tableView reloadData];

}


-(void)departmentArrowTapped:(UITapGestureRecognizer *)ges{
    NSLog(@"departmentArrowTapped");
    isHospital = NO;
    if (hosTextField.text.length==0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select hospital first." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        self.pickerBgView.hidden = NO;
    }

    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self hideKeyboard];
    self.pickerView.delegate = self;
    [self.pickerView reloadAllComponents];

}

-(void)hospitalArrowTapped:(UITapGestureRecognizer *)ges{
    NSLog(@"hospitalArrowTapped");
    isHospital = YES;
    [self hideKeyboard];
    self.pickerBgView.hidden = NO;
    self.pickerView.delegate = self;
    [self.pickerView reloadAllComponents];
//    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    self.placeHolderLbl.hidden = YES;
//    return YES;
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    if (textView.text.length > 0) {
////        self.placeHolderLbl.hidden = YES;
////    }else{
////        self.placeHolderLbl.hidden = NO;
//    }
//    return YES;
//}

#pragma mark-  UIPickerView  Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (isHospital) {
        return hospitalAry.count;
    }else{
        return depAry.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;

}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED{
//    if (isProdCate) {
//        return [[UtilsManager sharedObject] getMutableStringWithString:[cateAry objectAtIndex:row] font:[UIFont fontWithName:@"Roboto-Medium" size:14.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
//    }else{
//        if (isHospital) {
//            return [[UtilsManager sharedObject] getMutableStringWithString:[[hospitalAry objectAtIndex:row] valueForKey:HOSNAME_KEY] font:[UIFont fontWithName:@"Roboto-Medium" size:14.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
//        }else{
//            //        NSLog(@"Dep Ary: %@",[[hospitalAry objectAtIndex:row] valueForKey:@"deptAry"]);
//            return [[UtilsManager sharedObject] getMutableStringWithString:[[depAry objectAtIndex:row]valueForKey:@"name"] font:[UIFont fontWithName:@"Roboto-Medium" size:14.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
//        }
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    if (isHospital) {
        UILabel *pickerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_wdth, 50)];
        pickerLbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[[hospitalAry objectAtIndex:row] valueForKey:HOSNAME_KEY] font:[UIFont fontWithName:@"Roboto-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter];
        return (UIView *)pickerLbl;
        
        //            return [[UtilsManager sharedObject] getMutableStringWithString:[[hospitalAry objectAtIndex:row] valueForKey:HOSNAME_KEY] font:[UIFont fontWithName:@"Roboto-Medium" size:14.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
    }else{
        UILabel *pickerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen_wdth, 50)];
        pickerLbl.attributedText = [[UtilsManager sharedObject] getMutableStringWithString:[[depAry objectAtIndex:row]valueForKey:@"name"] font:[UIFont fontWithName:@"Roboto-Medium" size:15.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0.1 andNSTextAlignment:NSTextAlignmentCenter];
        return (UIView *)pickerLbl;
        
        //            return [[UtilsManager sharedObject] getMutableStringWithString:[[depAry objectAtIndex:row]valueForKey:@"name"] font:[UIFont fontWithName:@"Roboto-Medium" size:14.0] spacing:0 textColor:[UIColor whiteColor] lineSpacing:0 andNSTextAlignment:NSTextAlignmentCenter];
    }

}



- (IBAction)doneButtonTapped:(id)sender {
    [self hideKeyboard];

    NSInteger index = [_pickerView selectedRowInComponent:0];

    if (isHospital) {
        if (hospitalAry.count>0) {
            hosTextField.text = [[hospitalAry objectAtIndex:index] valueForKey:HOSNAME_KEY];
            depAry = [[hospitalAry objectAtIndex:index] valueForKey:@"deptAry"];
            selectedHospital = [NSMutableDictionary dictionaryWithDictionary:[hospitalAry objectAtIndex:index]];
            depTextField.text = @"";
        }
    }else{
        if (depAry.count>0) {
            depTextField.text = [[depAry objectAtIndex:index]valueForKey:@"name"];
            selectedDeparment = [NSMutableDictionary dictionaryWithDictionary:[depAry objectAtIndex:index]];
        }
    }
    self.pickerBgView.hidden = YES;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
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

#pragma mark-  Product Category & TableView Method
- (IBAction)prodCateCrossTapped:(id)sender {
    self.prodCateView.hidden = YES;
    self.pickerBgView.hidden = YES;
}

- (IBAction)prodCateDoneTapped:(id)sender {
    selectCate = @"";
    for (int i=0; i<selectCateAry.count; i++) {
        NSString *temp = [selectCateAry objectAtIndex:i];
        NSString *cate = [[temp componentsSeparatedByString:@"("] firstObject];
        
        if (selectCate.length>0) {
            selectCate = [NSString stringWithFormat:@"%@, %@",selectCate,cate];
        }else{
            selectCate = cate;
        }

    }
    cateTextField.text = selectCate;
    self.prodCateView.hidden = YES;
}


-(void)createHeaderView{
    float headerHgt = ([self.tableView bounds].size.height-180)/2;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_wdth, headerHgt)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:headerView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cateAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ProdCateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cateCell"];
    if (cell == nil) {
        cell = [[ProdCateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cateCell"];
    }
    
    if ([selectCateAry containsObject:[cateAry objectAtIndex:indexPath.row]]) {
        cell.checkboxImg.image = [UIImage imageNamed:@"checkbox.png"];
    }else{
        cell.checkboxImg.image = [UIImage imageNamed:@"uncheckbox.png"];
    }
    NSArray *components = [[cateAry objectAtIndex:indexPath.row] componentsSeparatedByString:@"("];
    NSString *lastObject = [components lastObject];
    
    NSString *subCate = [[lastObject componentsSeparatedByString:@")"] firstObject];
    cell.cateName.text = [components firstObject];
    cell.subCateName.text = subCate;
    cell.delegate = self;
    cell.index= indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)checkboxTappedWithCell:(ProdCateCell *)cell andIndex:(NSInteger)index{
    if ([selectCateAry containsObject:[cateAry objectAtIndex:index]]) {
        [selectCateAry removeObject:[cateAry objectAtIndex:index]];
    }else{
        [selectCateAry addObject:[cateAry objectAtIndex:index]];
    }
    [self.tableView reloadData];

}


#pragma mark-  Other Method
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController  popViewControllerAnimated:NO];
}
- (void)nextButtonTapped:(id)sender {
    
//    UITextField *hosTextField;
//    UITextField *depTextField;

    if (hosTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select hospital." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (depTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select department." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *remarks = [remarkTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (remarks.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter remarks." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    if ([[self.superCate lowercaseString] isEqualToString:@"enquiry"]) {
        if (cateTextField.text.length == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select product category." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }

    NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];


    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Confirmation" message:@"Please check if the details you have entered are correct." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[userInfo valueForKey:@"id"] forKey:@"customer_id"];
        [param setObject:Auth_Token forKey:Auth_Token_KEY];
        [param setObject:[self.superCate lowercaseString] forKey:@"request_type"];
        [param setObject:self.subCate forKey:@"sub_type"];
        if ([self.subCate isEqualToString:@"Installation"]) {
            [param setObject:@"installation" forKey:@"request_type"];
            [param setObject:@"" forKey:@"sub_type"];

        }
        if ([[self.superCate lowercaseString] isEqualToString:@"enquiry"]) {
            [param setObject:cateTextField.text forKey:@"product_category"];
        }
        [param setObject:[selectedHospital valueForKey:@"id"] forKey:@"hospital_id"];
        [param setObject:[selectedDeparment valueForKey:@"id"] forKey:@"dept_id"];
        if (remarks.length >0) {
            [param setObject:remarks forKey:@"remarks"];
        }

        
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
        NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        NSString *access_token = [userInfo valueForKey:@"access_token"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

        self.loaderView.hidden = NO;
        
//        NSString *url = [NSString stringWithFormat:@"%@/api/v1/%@",[self.superCate lowercaseString]];
        
        NSString *url;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v2/service",[userData valueForKey:@"testing_url"]];
        }else{
            url = [NSString stringWithFormat:@"%@/api/v2/service",base_url];
        }

        [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"success! with response: %@", responseObject);

            self.loaderView.hidden = YES;
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            
            if ([[responseDict valueForKey:@"status_code"] intValue] == 200) {
                UIStoryboard *mainStoryboard;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    mainStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
                }else{
                    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                }
                ThankYouViewController *svc = [mainStoryboard instantiateViewControllerWithIdentifier:@"thankYouVC"];
                svc.delegate = self;
                svc.remarkTitle = [[remarkTitle.attributedText string] uppercaseString];
                [param setObject:[selectedHospital valueForKey:@"hospital_name"] forKey:@"hospital_name"];
                [param setObject:[selectedDeparment valueForKey:@"name"] forKey:@"dept_name"];
                [param setObject:[responseDict valueForKey:@"cvm_id"] forKey:@"cvm_id"];
                [param setObject:[responseDict valueForKey:@"message_bottom"] forKey:@"message_bottom"];
                [param setObject:[responseDict valueForKey:@"message_top"] forKey:@"message_top"];

                svc.requestInfo = [NSDictionary dictionaryWithDictionary:param];
                [self.navigationController presentViewController:svc animated:NO completion:nil];
            }else if ([[responseObject valueForKey:@"status_code"] intValue] == 402){
                [[UtilsManager sharedObject] sessionExpirePopup:self];
            }else if ([[responseObject valueForKey:@"status_code"] intValue] == 407){
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];

            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[responseDict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.loaderView.hidden = YES;
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }];

        
        
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
    
//    [self.navigationController pushViewController:svc animated:NO];

}

-(void)thankYouMsgDidDismissed{
    [self fetchCountForLoginUser];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
-(void)fetchCountForLoginUser{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] boolValue]) {
        if (![[UtilsManager sharedObject] checkUserActivityValid]){
            [[UtilsManager sharedObject] sessionExpirePopup:self];
            return;
        }
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSDictionary *userInfo = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        NSString *access_token = [userInfo valueForKey:@"access_token"];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",access_token] forHTTPHeaderField:@"Authorization"];

        
        
        NSString *url;
        NSDictionary *userData = [[UtilsManager sharedObject] getUserDetailsFromDefaultUser];
        if ([[userData valueForKey:@"is_testing"] boolValue]) {
            url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",[userData valueForKey:@"testing_url"],[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token];
            
        }else{
            url = [NSString stringWithFormat:@"%@/api/v2/historyCount/%@?auth_token=%@",base_url,[[[UtilsManager sharedObject] getUserDetailsFromDefaultUser] valueForKey:@"id"],Auth_Token];
        }
        

        
        
        
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"completedUnitCount: %lld \n totalUnitCount: %lld",downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([[responseDict valueForKey:@"status_code"] intValue] == 200){
                NSDictionary *countInfo = [responseDict valueForKey:@"history"];
                int count = [[countInfo valueForKey:@"ongoingCountAcademic"] intValue]+[[countInfo valueForKey:@"ongoingCountService"]intValue]+[[countInfo valueForKey:@"ongoingCountEnquiry"] intValue];
                MFSideMenuContainerViewController *mfController = (MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
                
                UITabBarController *tabBarController = [mfController centerViewController];
                if (count!=0) {
                    [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",count]];
                }else{
                    [[tabBarController.tabBar.items objectAtIndex:1] setBadgeValue:nil];
                }
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 402){
                [[UtilsManager sharedObject] sessionExpirePopup:self];
            }else if ([[responseDict valueForKey:@"status_code"] intValue] == 407){
                [[UtilsManager sharedObject] showPasswordExpirePopup:self];
            }


        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
    }
}


@end


@implementation ProdCateCell
//@property (weak, nonatomic) IBOutlet UILabel *depName;
//@property (weak, nonatomic) IBOutlet UIImageView *checkboxImg;
//@property (strong, nonatomic) id<ProdCateCellDelegate> delegate;
//@property (assign, nonatomic)NSInteger index;

-(void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)checkBoxTapped:(id)sender{
    if (self.delegate) {
        [self.delegate checkboxTappedWithCell:self andIndex:self.index];
    }
    
}

@end


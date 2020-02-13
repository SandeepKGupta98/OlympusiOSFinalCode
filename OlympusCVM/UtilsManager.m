
#import "UtilsManager.h"
#import "MFSideMenu/MFSideMenu.h"

@implementation UtilsManager
-(instancetype)init{
    if((self = [super init]))
    {
    }
    return self;
}

+ (UtilsManager *)sharedObject
{
    static UtilsManager *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[UtilsManager alloc] init];
    });
    return objUtility;
}

-(void)createShadowForLabel:(UILabel *)lbl{
    lbl.layer.shadowOpacity = 1.0;
    lbl.layer.shadowRadius = 0.0;
    lbl.layer.shadowColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0].CGColor;
    lbl.layer.shadowOffset = CGSizeMake(0.0, 1.0);

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
    
    if (lineSpacing) {
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

-(NSString *)convertProperRateFormat:(NSUInteger) price{
    
    if (price >= 100000) {
        return [NSString stringWithFormat:@".3%fLac",price/100000.00];
    }else if(price >= 10000000){
        return [NSString stringWithFormat:@".3%fCr",price/10000000.00];
        
    }else{
        return [NSString stringWithFormat:@"%lu",(unsigned long)price];
    }
}

-(NSString *) stringByStrippingHTML:(NSString *)s {
    NSRange r;
    
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    
    s = [s stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"&amp;lsquo;" withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&amp;rsquo;" withString:@"'"];
    s = [s stringByReplacingOccurrencesOfString:@"&ndash;" withString:@"-"];
    s = [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"-"];
    return s;
}

-(NSString *)extractManagingCommitteeMemberWithString:(NSString *)string{
    NSString *str = nil;
    NSMutableArray *componentAry = [[[[string stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"] componentsSeparatedByString:@"\n\n\n"] mutableCopy];
    
    NSArray *tempAry = [NSArray arrayWithArray:componentAry];
    for (NSString *str in tempAry) {
        if ([str isEqualToString:@""]) {
            [componentAry removeObject:str];
        }
    }
    if (componentAry.count) {
        [componentAry removeObjectAtIndex:0];
    }
    
    for (int i =0; i<componentAry.count; i++) {
        NSArray *temp = [[componentAry objectAtIndex:i] componentsSeparatedByString:@"\n"];
        if (str) {
            str = [NSString stringWithFormat:@"%@\n%@. %@ (%@)",str,[temp firstObject],[temp objectAtIndex:1],[temp lastObject]];
        }else{
            str = [NSString stringWithFormat:@"%@. %@ (%@)",[temp firstObject],[temp objectAtIndex:1],[temp lastObject]];
        }
        
    }
 //   NSLog(@"componentAry: %@",str);
    return str;
    
}

-(void)sharePageLinkWithUrl:(NSString *)link withVC:(UIViewController *)vc{
//    NSLog(@"sharePageLinkWithUrl: %@",link);
    NSArray *activityItems = [NSArray arrayWithObjects:link, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [vc presentViewController:activityViewController animated:YES completion:nil];
    
//    [activityViewController setCompletionHandler:^(NSString *act, BOOL done)
//     {
//         //Code here when the action performed.
//         
//     }];

}


-(NSString *)getDocumentDirectoryPathWithFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return [libraryDirectory stringByAppendingPathComponent:fileName];

}
- (BOOL)checkFileWithFileName:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL fileExists = [fileManager fileExistsAtPath:[self getDocumentDirectoryPathWithFileName:fileName]];
    return fileExists;
}
    
- (BOOL)downloadImageFileFrom:(NSString *)path newFileName:(NSString *)newFileName
{
    return NO;

//    NSURL *URL = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//
//    ;
//
//
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSLog(@"downloadImageFileFrom data:%@",data);
//    }];
//
//
//
//    return NO;
//
//    NSData *data = [NSData dataWithContentsOfURL:URL];
//
//    if (data == nil) {
//        NSLog(@"error");
//
//    }
//    NSString *appDocDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *storePath = [appDocDir stringByAppendingPathComponent:newFileName];
//
//    return [data writeToFile:storePath atomically:YES];
    
}

- (BOOL)saveFileWithData:(NSMutableData *)data withFileName:(NSString *)fileName{
    
    if (data == nil) {
        return NO;
    }
    NSString *appDocDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [appDocDir stringByAppendingPathComponent:fileName];
    return [data writeToFile:storePath atomically:YES];
}

- (NSString *)extractYoutubeIdFromLink:(NSString *)link {
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}
-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)isValidPhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:phoneNumber];
}


- (NSString *)relativeTimestamp:(NSDate*)date {
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date toDate:[NSDate date] options:0];
    
    NSString * time;
    if ([dateComponents year] > 0) {
        if ([dateComponents year] == 1) {
            time = [NSString stringWithFormat:@"%ld year", (long)[dateComponents year]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld years", (long)[dateComponents year]];
        }
    }
    else if ([dateComponents month] > 0) {
        if ([dateComponents month] == 1) {
            time = [NSString stringWithFormat:@"%ld month", (long)[dateComponents month]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld months", (long)[dateComponents month]];
        }
    }
    else if ([dateComponents weekOfYear] > 0) {
        if ([dateComponents weekOfYear] == 1) {
            time = [NSString stringWithFormat:@"%ld week", (long)[dateComponents weekOfYear]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld weeks", (long)[dateComponents weekOfYear]];
        }
    }
    else if ([dateComponents day] > 0) {
        if ([dateComponents day] == 1) {
            time = [NSString stringWithFormat:@"%ld day", (long)[dateComponents day]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld days", (long)[dateComponents day]];
        }
    }
    else if ([dateComponents hour] > 0) {
        if ([dateComponents hour] == 1) {
            time = [NSString stringWithFormat:@"%ld hour", (long)[dateComponents hour]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld hours", (long)[dateComponents hour]];
        }
    }
    else if ([dateComponents minute] > 0) {
        if ([dateComponents minute] == 1) {
            time = [NSString stringWithFormat:@"%ld min", (long)[dateComponents minute]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld min", (long)[dateComponents minute]];
        }
    }
    else if ([dateComponents second] > 0) {
        if ([dateComponents second] == 0) {
            time = [NSString stringWithFormat:@"%ld sec", (long)[dateComponents second]];
        }
        else {
            time = [NSString stringWithFormat:@"%ld sec", (long)[dateComponents second]];
        }
    }
    if (time) {
        return [NSString stringWithFormat:@"%@ ago", time];
    }else{
        return @"0 sec ago";
    }
}

-(NSString *)getLocalTime:(NSDate *)currentDate{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    /*
     NSDate *mydate = [NSDate date];
     NSTimeInterval secondsInEightHours = 8 * 60 * 60;
     NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];

     
     
     NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
     float timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600.0;

     */
    // or Timezone with specific name like
    // [NSTimeZone timeZoneWithName:@"Europe/Riga"] (see link below)
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    return [self relativeTimestamp:[dateFormatter dateFromString:localDateString]];
    
//    NSLog(@"Get Local Time: %@",[self relativeTimestamp:[dateFormatter dateFromString:localDateString]]);
    
    
    
}


-(NSString *)getProperPostString:(NSString *)postText{
    
    NSString *str;
    
    postText = [postText substringFromIndex:9];
    postText = [postText substringToIndex:[postText length] - 2];
    postText = [postText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSArray *rnAry = [postText componentsSeparatedByString:@"\\r\\n"];
    NSArray *component = [postText componentsSeparatedByString:@"\\n"];
    if (rnAry.count>1) {
        for (int i=0; i<rnAry.count; i++) {
            if ([str length]==0) {
                str = [rnAry objectAtIndex:i];
            }else{
                str = [NSString stringWithFormat:@"%@\n%@",str,[rnAry objectAtIndex:i]];
            }
        }
    }else if (component.count>1){
        for (int i=0; i<component.count; i++) {
            if ([str length]==0) {
                str = [component objectAtIndex:i];
            }else{
                str = [NSString stringWithFormat:@"%@\n%@",str,[component objectAtIndex:i]];
            }
        }
    }
    
    if (str == nil) {
        str = postText;
    }
    return str;
}

-(BOOL)storeUserDatatoDefaultUser:(NSDictionary *)userDict{
    
    NSError *error;
    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:userDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    [[NSUserDefaults standardUserDefaults] setObject:dataFromDict forKey:@"userInfo"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary *)getUserDetailsFromDefaultUser{
    NSError *error;
    NSData *dataFromDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (dataFromDict == nil) {
        return [[NSDictionary alloc] init];
    }
    NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:dataFromDict
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:&error];
    return dictFromData;
}

-(NSString *)getDepartmentNameFromArray:(NSArray *)depAry {
    NSString *dep;
    for (int i=0; i<depAry.count; i++) {
        NSDictionary *depInfo = [depAry objectAtIndex:i];
        if (dep == nil) {
            dep = [depInfo valueForKey:@"name"];
        }else{
            dep = [NSString stringWithFormat:@"%@, %@",dep,[depInfo valueForKey:@"name"]];
        }
    }
    return dep;
}
-(void)inboxBadgeWithInbox:(NSArray *) inboxAry{
    
    NSLog(@"Hello");
    NSInteger count = inboxAry.count;
    MFSideMenuContainerViewController *mfController = (MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UITabBarController *tabBarController = [mfController centerViewController];
    [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    NSArray *storeReadInboxIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"readInboxIds"];
    
    NSMutableArray *readInboxIds = [[NSMutableArray alloc] init];
    
    for (int i=0; i<inboxAry.count; i++) {
        NSNumber *inbxId ;
        if ([[inboxAry objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            inbxId = [[inboxAry objectAtIndex:i] valueForKey:@"id"];
        }else{
            inbxId = [inboxAry objectAtIndex:i];
        }
        
        if ([storeReadInboxIds containsObject:inbxId]) {
            [readInboxIds addObject:inbxId];
        }
    }
    
    NSLog(@"readInboxIds: %@",readInboxIds);
    
    
//    "inboxIds": [
//                 11,
//                 12
//                 ]


    if (readInboxIds) {
        count = count-readInboxIds.count;
    }
    
    if (count>0) {
        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
    }else{
        [[tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    }

}


-(NSString *)dwoloadPdfFileWith:(NSString *)urlStr{
    // Get the PDF Data from the url in a NSData Object
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlStr]];
    
    
    NSString *fileName = [[urlStr componentsSeparatedByString:@"/"] lastObject];
    // Store the Data locally as PDF File
    
    NSString* resourceDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    
    NSString *filePath = [resourceDocPath stringByAppendingPathComponent:fileName];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];

    if (!fileExists) {
        [pdfData writeToFile:filePath atomically:YES];
    }
    
    return filePath;
//
}


-(NSString *)removeNullFromString:(NSString *)string{
    NSString *str = @"";
    if (![string isKindOfClass:[NSNull class]]) {
        if (string != nil) {
            str = [NSString stringWithFormat:@"%@",string];
        }
    }
    str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<\/p>" withString:@""];
    return str;
}

//-(void)setContraintsWithView:(UIView *)subView toView:(UIView *)parentView withLeading:(CGFloat )lead trailing:(CGFloat )trail topMargin:(CGFloat)top andBottomMargin:(CGFloat)bottom height:(CGFloat)height width:(CGFloat)width{
//    subView.translatesAutoresizingMaskIntoConstraints = NO;
//
//    if (trail>=0) {
//        //Trailing
//        NSLayoutConstraint *trailing =[NSLayoutConstraint
//                                       constraintWithItem:subView
//                                       attribute:NSLayoutAttributeTrailing
//                                       relatedBy:NSLayoutRelationEqual
//                                       toItem:parentView
//                                       attribute:NSLayoutAttributeTrailing
//                                       multiplier:1.0f
//                                       constant:trail];
//        [trailing setActive:YES];
//    }
//
//    if (lead>=0) {
//        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:lead];
//        [leading setActive:YES];
//
//    }
//    if (height>=0) {
//        NSLayoutConstraint *hgt =[NSLayoutConstraint
//                                       constraintWithItem:subView
//                                       attribute:NSLayoutAttributeHeight
//                                       relatedBy:NSLayoutRelationEqual
//                                       toItem:nil
//                                       attribute:NSLayoutAttributeNotAnAttribute
//                                       multiplier:1.0f
//                                       constant:height];
//        [hgt setActive:YES];
//    }
// 
//    if (width>=0) {
//        NSLayoutConstraint *wdth =[NSLayoutConstraint
//                                  constraintWithItem:subView
//                                  attribute:NSLayoutAttributeWidth
//                                  relatedBy:NSLayoutRelationEqual
//                                  toItem:nil
//                                  attribute:NSLayoutAttributeNotAnAttribute
//                                  multiplier:1.0f
//                                  constant:width];
//        [wdth setActive:YES];
//    }
//
//    
//}

@end



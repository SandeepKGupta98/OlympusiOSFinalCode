//https://www.appcoda.com/siri-speech-framework/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "PopupViewController.h"
#import "HundredYearLogo.h"
#import "AboutViewController.h"

#define Yellow_Border_Color ([[UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0] CGColor])
#define Yellow_Color ([UIColor colorWithRed:255/255.0 green:180/255.0 blue:61/255.0 alpha:1.0])
#define Dark_Yellow_Color ([UIColor colorWithRed:144/255.0 green:99/255.0 blue:27/255.0 alpha:1.0])
#define TextField_Font ([UIFont fontWithName:@"EncodeSansNormal-Medium" size:13.0])


#define Auth_Token @"5c2b9071-a675-49b0-8fb2-9cd894da1c87"
#define Auth_Token_New @"5c2b9071-a675-49b0-8fb2-9cd894da1c81"

#define Auth_Token_KEY @"auth_token"

#define PWD_KEY @"password"
#define EMAIL_KEY @"email"
#define FNAME_KEY @"first_name"
#define HOSARY_KEY @"hospitalAry"
#define ADDRESS_KEY @"address"
#define CITY_KEY @"city"
#define COUNTRY_KEY @"country"
#define HOSNAME_KEY @"hospital_name"
#define DEPNAME_KEY @"depName"
#define STATE_KEY @"state"
#define ZIP_KEY @"zip"
#define LNAME_KEY @"last_name"
#define MNAME_KEY @"middle_name"
#define MOBILE_KEY @"mobile_number"
#define TITLE_KEY @"title"
#define DEP_ID_KEY @"dept_id"
#define HISTORY_COUNT_KEY @"totalHistoryCount"


#define base_url @"https://www.olympusmyvoice.com"







#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface UtilsManager : NSObject
+ (UtilsManager *)sharedObject;
-(void)createShadowForLabel:(UILabel *)lbl;
-(NSMutableAttributedString *)getMutableStringWithString:(NSString *)string font:(UIFont *)font spacing:(float )spacing textColor:(UIColor *)textColor lineSpacing:(CGFloat )lineSpacing andNSTextAlignment:(NSTextAlignment )alignment;
-(CGFloat )heightOfAttributesString:(NSAttributedString *)attrStr withWidth:(CGFloat )width;
-(NSString *)convertProperRateFormat:(NSUInteger) price;
-(NSString *) stringByStrippingHTML:(NSString *)s;
-(NSString *)extractManagingCommitteeMemberWithString:(NSString *)string;
-(void)sharePageLinkWithUrl:(NSString *)link withVC:(UIViewController *)vc;
- (BOOL)checkFileWithFileName:(NSString *)fileName;
- (BOOL)downloadImageFileFrom:(NSString *)path newFileName:(NSString *)newFileName;
- (BOOL)saveFileWithData:(NSMutableData *)data withFileName:(NSString *)fileName;
-(NSString *)getDocumentDirectoryPathWithFileName:(NSString *)fileName;
- (NSString *)extractYoutubeIdFromLink:(NSString *)link ;
-(BOOL) isValidEmail:(NSString *)checkString;
- (BOOL)isValidPhone:(NSString *)phoneNumber;
- (NSString *)relativeTimestamp:(NSDate*)date ;
-(NSString *)getLocalTime:(NSDate *)currentDate;
-(NSString *)getProperPostString:(NSString *)postText;


-(BOOL)storeUserDatatoDefaultUser:(NSDictionary *)userDict;
-(NSDictionary *)getUserDetailsFromDefaultUser;
-(NSString *)getDepartmentNameFromArray:(NSArray *)depAry ;
-(void)inboxBadgeWithInbox:(NSArray *) inboxAry;
-(NSString *)dwoloadPdfFileWith:(NSString *)urlStr;
-(NSString *)removeNullFromString:(NSString *)string;

@end

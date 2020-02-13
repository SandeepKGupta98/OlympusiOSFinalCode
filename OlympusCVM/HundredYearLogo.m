//
//  HundredYearLogo.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 01/07/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import "HundredYearLogo.h"

@implementation HundredYearLogo

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}
-(void)commonInit{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageTapped)];
    tapGes.numberOfTapsRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGes];
}
-(void)logoImageTapped{
    NSString *url = @"https://www.olympus-global.com/features/100years/";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end

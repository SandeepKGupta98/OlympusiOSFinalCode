//
//  UIViewController+Presentation.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 30/01/20.
//  Copyright © 2020 Sandeep Kr Gupta. All rights reserved.
//

#import "UIViewController+Presentation.h"

#import <objc/runtime.h>




@implementation UIViewController (Presentation)
- (void)setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    [self setPrivateModalPresentationStyle:modalPresentationStyle];
}

-(UIModalPresentationStyle)modalPresentationStyle {
    UIModalPresentationStyle style = [self privateModalPresentationStyle];
    if (style == NSNotFound) {
        return UIModalPresentationFullScreen;
    }
    return style;
}

- (void)setPrivateModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    NSNumber *styleNumber = [NSNumber numberWithInteger:modalPresentationStyle];
     objc_setAssociatedObject(self, @selector(privateModalPresentationStyle), styleNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIModalPresentationStyle)privateModalPresentationStyle {
    NSNumber *styleNumber = objc_getAssociatedObject(self, @selector(privateModalPresentationStyle));
    if (styleNumber == nil) {
        return NSNotFound;
    }
    return styleNumber.integerValue;
}

@end

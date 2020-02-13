//
//  PDFReaderViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/01/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface PDFReaderViewController : UIViewController
@property (strong, nonatomic)NSString *pdfUrl;
@property (weak, nonatomic)IBOutlet UIWebView *webView;
@property (weak, nonatomic)IBOutlet UIView *loaderView;
-(IBAction)backButtonTapped:(id)sender;
-(IBAction)shareButtonTapped:(id)sender;
@end


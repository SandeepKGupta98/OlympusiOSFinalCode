//
//  PDFReaderViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 02/01/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import "PDFReaderViewController.h"
#import "UtilsManager.h"

@interface PDFReaderViewController ()<UIWebViewDelegate>

@end

@implementation PDFReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loaderView.hidden = NO;
    if (self.pdfUrl) {
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSString *filePath = [[UtilsManager sharedObject] dwoloadPdfFileWith:self.pdfUrl];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update UI
                // Example:
                NSURL *url = [NSURL fileURLWithPath:filePath];
                NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
                NSLog(@"requestObj: %@",requestObj);
                self.webView.scalesPageToFit = YES;
                
                
                [self.webView setUserInteractionEnabled:YES];
                [self.webView setDelegate:self];
                [self.webView loadRequest:requestObj];
            });
        });

        
        
        
        
        
        
        
//        NSURL *targetURL = [NSURL URLWithString:filePath];
//        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
//        self.webView.scalesPageToFit = YES;
//        self.webView.delegate = self;
//        [self.webView loadRequest:request];
        
        
        // Now create Request for the file that was saved in your documents folder

        
        
    }



}
-(IBAction)backButtonTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.loaderView.hidden = NO;
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.loaderView.hidden = NO;

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.loaderView.hidden = YES;

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.loaderView.hidden = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];

}
-(IBAction)shareButtonTapped:(id)sender{
    
    if (self.pdfUrl) {
        
        
        
        NSString *fileName = [[self.pdfUrl componentsSeparatedByString:@"/"] lastObject];
        NSString* resourceDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [resourceDocPath stringByAppendingPathComponent:fileName];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (fileExists) {
            NSURL *pdfFileUrl = [NSURL fileURLWithPath:filePath];
            NSArray *objectsToShare = @[pdfFileUrl];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            [self presentViewController:activityVC animated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"File does not exist" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self backButtonTapped:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }

        
        
        
    }


}


@end

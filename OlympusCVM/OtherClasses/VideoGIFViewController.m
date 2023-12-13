//
//  VideoGIFViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 18/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import "VideoGIFViewController.h"

@interface VideoGIFViewController ()

@end

@implementation VideoGIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"frame_28_delay-0.1s.gif"]];
    [self showGIFonView];    // Do any additional setup after loading the view.
    [self performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:3.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showGIFonView{
    self.imageView.image = [UIImage animatedImageWithImages:[NSArray arrayWithObjects:
                                                              [UIImage imageNamed:@"frame_00_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_01_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_02_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_03_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_04_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_05_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_06_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_07_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_08_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_09_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_10_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_11_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_12_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_13_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_14_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_15_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_16_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_17_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_18_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_19_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_20_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_21_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_22_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_23_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_24_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_25_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_26_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_27_delay-0.1s.gif"],
                                                             [UIImage imageNamed:@"frame_28_delay-0.1s.gif"],nil] duration:3.5f];

}


@end

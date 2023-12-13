//
//  PopupViewController.m
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 18/06/19.
//  Copyright © 2019 Sandeep Kr Gupta. All rights reserved.
//

#import "PopupViewController.h"
#import "UtilsManager.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descLbl.text = self.descLblTxt;
    self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.borderColor = Yellow_Border_Color;
    self.contentView.layer.borderWidth = 1;
    self.contentView.clipsToBounds =YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    tapGes.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGes];
//     Do any additional setup after loading the view from its nib.
}
-(void)dismissPopup{
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished){
        if (self.delegate) {
            [self.delegate dismissPopupWithPopupController:self withType:self.type];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showPopup];
}

-(IBAction)gotoSubCategory:(id)sender{
    if (self.delegate) {
        [self.delegate enterButtonTapped:self withType:self.type];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(IBAction)crossButtonTapped:(id)sender{
    if (self.delegate) {
        [self.delegate dismissPopupWithPopupController:self withType:self.type];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)showPopup{
    self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
//        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);

//        [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//                self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            } completion:^(BOOL finished){
//                //                self->popUpView.hidden = YES;
//
//            }];
//        }];
    }];
}

-(void)hidePopup{
    
    [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}



@end

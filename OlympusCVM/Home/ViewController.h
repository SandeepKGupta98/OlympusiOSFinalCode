//
//  ViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 19/12/17.
//  Copyright © 2017 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "OptionsViewController.h"
#import "VideoGIFViewController.h"
#import "MFSideMenu.h"
@protocol ViewControllerCellDelegate;
@protocol CategoryCellDelegate;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
- (IBAction)menuBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;


@property (weak, nonatomic) IBOutlet UIImageView *serviceImg;
@property (weak, nonatomic) IBOutlet UIImageView *enquiryImg;
@property (weak, nonatomic) IBOutlet UIImageView *academicImg;
@property (weak, nonatomic) IBOutlet UIImageView *otherImg;
@property (weak, nonatomic) IBOutlet UIView *loaderView;

- (IBAction)serviceButtonTapped:(id)sender;
- (IBAction)serviceTouchDown:(id)sender;
- (IBAction)serviceDragInside:(id)sender;
- (IBAction)serviceDragOutside:(id)sender;


- (IBAction)enquiryButtonTapped:(id)sender;
- (IBAction)enquiryTouchDown:(id)sender;
- (IBAction)enquiryDragInside:(id)sender;
- (IBAction)enquiryDragOutside:(id)sender;

- (IBAction)academicButtonTapped:(id)sender;
- (IBAction)academicTouchDown:(id)sender;
- (IBAction)academicDragInside:(id)sender;
- (IBAction)academicDragOutside:(id)sender;

- (IBAction)otherButtonTapped:(id)sender;
- (IBAction)otherTouchDown:(id)sender;
- (IBAction)otherDragInside:(id)sender;
- (IBAction)otherDragOutside:(id)sender;
@end



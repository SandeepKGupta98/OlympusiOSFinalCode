//
//  FirstTutorialViewController.h
//  OlympusCVM
//
//  Created by Sandeep Kr Gupta on 26/04/18.
//  Copyright © 2018 Sandeep Kr Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTutorialViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)skipButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

@end

@interface FirstTutorialCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHgt;

@end

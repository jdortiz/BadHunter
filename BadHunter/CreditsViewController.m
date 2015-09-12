//
//  CreditsViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 10/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "CreditsViewController.h"


@interface CreditsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *initialVerticalConstraintCredits;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finalVerticalConstraintCredits;

@end



@implementation CreditsViewController

#pragma mark - Parameters & Constants

//static NSTimeInterval iconAnimationDuration = 0.4;
static NSTimeInterval totalAnimationDuration = 0.5;
static NSTimeInterval creditsAnimationRelativeDuration = 0.5;
static NSTimeInterval iconAnimationRelativeDuration = 0.6;
static NSTimeInterval iconAnimationDelay = 0.2;

#pragma mark - View Controller Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.iconImageView.alpha = 0.0;
    self.iconImageView.transform = CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformMakeTranslation(-100.0, -100), M_PI), 0.1, 0.1);
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    if (animated) {
        [UIView animateKeyframesWithDuration:totalAnimationDuration delay:0.0
                                     options:0 animations:^{
                                         [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:creditsAnimationRelativeDuration animations:^{
                                             self.initialVerticalConstraintCredits.priority = UILayoutPriorityDefaultHigh - 5;
                                             self.finalVerticalConstraintCredits.priority = UILayoutPriorityDefaultHigh + 5;
                                             [self.view layoutIfNeeded];
                                         }];
                                         [UIView addKeyframeWithRelativeStartTime:iconAnimationDelay relativeDuration:iconAnimationRelativeDuration animations:^{
                                             self.iconImageView.alpha = 1.0;
                                             self.iconImageView.transform = CGAffineTransformIdentity;
                                         }];
                                     } completion:nil];

//        [UIView animateWithDuration:iconAnimationDuration delay:0.0
//             usingSpringWithDamping:1 initialSpringVelocity:0.1
//                            options:0 animations:^{
//                                self.initialVerticalConstraintCredits.priority = UILayoutPriorityDefaultHigh - 5;
//                                self.finalVerticalConstraintCredits.priority = UILayoutPriorityDefaultHigh + 5;
//                                [self.view layoutIfNeeded];
//                            } completion:^(BOOL finished) {
//                                [UIView animateWithDuration:iconAnimationDuration delay:0.0
//                                     usingSpringWithDamping:1 initialSpringVelocity:0.1
//                                                    options:0 animations:^{
//                                                        self.iconImageView.alpha = 1.0;
//                                                        self.iconImageView.transform = CGAffineTransformIdentity;
//                                                    } completion:nil];
//                            }];
    }
}

@end

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

@end



@implementation CreditsViewController

#pragma mark - Parameters & Constants

static NSTimeInterval iconAnimationDuration = 0.5;

#pragma mark - View Controller Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    self.iconImageView.alpha = 0.0;
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
//        [UIView animateWithDuration:iconAnimationDuration animations:^{
//            self.iconImageView.alpha = 1.0;
//        }];
//        [UIView animateWithDuration:iconAnimationDuration delay:0.0
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             self.iconImageView.alpha = 1.0;
//                         } completion:nil];
        [UIView animateWithDuration:iconAnimationDuration delay:0.0
             usingSpringWithDamping:1 initialSpringVelocity:0.1
                            options:0 animations:^{
                                self.iconImageView.alpha = 1.0;
                            } completion:nil];
    }
}

@end

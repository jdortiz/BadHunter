//
//  CreditsViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 10/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "CreditsViewController.h"
#import <QuartzCore/QuartzCore.h>


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
                                     } completion:^(BOOL finished) {
                                         float fireDuration = 1.5;
                                         CGRect iconFrame = self.iconImageView.frame;
                                         CAEmitterLayer *emitter = [CAEmitterLayer layer];
                                         emitter.emitterPosition = CGPointMake(CGRectGetMidX(iconFrame), CGRectGetMidY(iconFrame));
                                         emitter.emitterMode = kCAEmitterLayerOutline;
                                         emitter.emitterShape = kCAEmitterLayerCircle;
                                         emitter.renderMode = kCAEmitterLayerAdditive;
                                         emitter.emitterSize =  iconFrame.size;

                                         //Create the emitter cell
                                         CAEmitterCell* particle = [CAEmitterCell emitterCell];
                                         particle.emissionLongitude = M_PI;
                                         particle.birthRate = 30.0;
                                         particle.lifetime = 0.5;
                                         particle.lifetimeRange = 0.3;
                                         particle.velocity = 20;
                                         particle.velocityRange = 20;
                                         particle.yAcceleration = -100;
                                         particle.emissionRange = M_PI;
                                         particle.scale = 0.8;
                                         particle.scaleRange = 0.4;
                                         particle.scaleSpeed = 0.2;
                                         particle.contents = (__bridge id)([UIImage imageNamed:@"FireParticle"].CGImage);
                                         particle.name = @"particle";
                                         
                                         emitter.emitterCells = @[particle];
                                         [self.view.layer insertSublayer:emitter below:self.iconImageView.layer];

                                         dispatch_time_t extinguishTime = dispatch_time(DISPATCH_TIME_NOW, fireDuration * NSEC_PER_SEC);
                                         dispatch_after(extinguishTime, dispatch_get_main_queue(), ^(void) {
                                             [emitter setValue:@0.0 forKeyPath:@"emitterCells.particle.birthRate"];
                                         });
                                     }];
    }
}

@end

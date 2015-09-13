//
//  PresenterAnimator.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 13/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "PresenterAnimator.h"


@interface PresenterAnimator ()

@property (assign, nonatomic) BOOL forward;

@end


@implementation PresenterAnimator

static const NSTimeInterval duration = 0.4;


- (instancetype) initForwardTransition:(BOOL)forward {
    if (self = [super init]) {
        _forward = forward;
    }

    return self;
}


- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (self.forward) {
        [self animateTransitionForwardWithContext:transitionContext
                               fromViewController:fromViewController toViewController:toViewController
                                         fromView:fromView toView:toView];
    } else {
        [self animateTransitionBackwardWithContext:transitionContext
                               fromViewController:fromViewController toViewController:toViewController
                                         fromView:fromView toView:toView];
    }
}


- (void) animateTransitionForwardWithContext:(id<UIViewControllerContextTransitioning>)context
                          fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
                                    fromView:(UIView *)fromView toView:(UIView *)toView {
    UIView *containerView = [context containerView];
    if ([context isAnimated]) {
        CGRect startFrame = CGRectMake(0.0, -containerView.frame.size.height, containerView.frame.size.width, containerView.frame.size.height);
        toView.frame = startFrame;
        [containerView addSubview:toView];
        [UIView animateWithDuration:duration delay:0.0
             usingSpringWithDamping:1.0 initialSpringVelocity:0.1
                            options:0 animations:^{
                                toView.frame = [context finalFrameForViewController:toViewController];
                            } completion:^(BOOL finished) {
                                [context completeTransition:YES];
                            }];
    } else {
        toView.frame = [context finalFrameForViewController:toViewController];
        [containerView addSubview:toView];
    }
}


- (void) animateTransitionBackwardWithContext:(id<UIViewControllerContextTransitioning>)context
                           fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
                                     fromView:(UIView *)fromView toView:(UIView *)toView {

}


- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return duration;
}

@end

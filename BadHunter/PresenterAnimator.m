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

#pragma mark - Constants & Parameters

static const NSTimeInterval duration = 0.4;
static const float perspectiveFactor = -1/500.0;


#pragma mark - Initialization

- (instancetype) initForwardTransition:(BOOL)forward {
    if (self = [super init]) {
        _forward = forward;
    }

    return self;
}


#pragma mark - View Controller Animated Transitioning

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
    toView.frame = [context finalFrameForViewController:toViewController];
    if ([context isAnimated]) {
        CGSize viewSize = fromView.frame.size;
        CGRect topFrame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.height/2);
        CGRect bottomFrame = CGRectMake(0.0, viewSize.height/2, viewSize.width, viewSize.height/2);
        UIView *topHalfImage = [fromView resizableSnapshotViewFromRect:topFrame
                                                    afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        topHalfImage.frame = topFrame;
        UIView *bottomHalfImage = [fromView resizableSnapshotViewFromRect:bottomFrame
                                                       afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        bottomHalfImage.frame = bottomFrame;

        [containerView addSubview:toView];
        [toView addSubview:topHalfImage];
        topHalfImage.layer.anchorPoint = CGPointMake(0.5, 0.0);
        topHalfImage.layer.position = CGPointMake(viewSize.width / 2.0, 0.0);
        [toView addSubview:bottomHalfImage];
        bottomHalfImage.layer.anchorPoint = CGPointMake(0.5, 1.0);
        bottomHalfImage.layer.position = CGPointMake(viewSize.width / 2.0, viewSize.height);
        [UIView animateWithDuration:duration delay:0.0
                            options:0 animations:^{
                                CATransform3D rotate3DUp = CATransform3DMakeRotation(M_PI_2, 1.0, 0.0, 0.0);
                                rotate3DUp.m34 = perspectiveFactor;
                                topHalfImage.layer.transform = rotate3DUp;
                                CATransform3D rotate3DDown = CATransform3DMakeRotation(-M_PI_2, 1.0, 0.0, 0.0);
                                rotate3DDown.m34 = perspectiveFactor;
                                bottomHalfImage.layer.transform = rotate3DDown;
                            } completion:^(BOOL finished) {
                                [topHalfImage removeFromSuperview];
                                [bottomHalfImage removeFromSuperview];
                                [context completeTransition:YES];
                            }];
    } else {
        [containerView addSubview:toView];
    }
}


- (void) animateTransitionBackwardWithContext:(id<UIViewControllerContextTransitioning>)context
                           fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
                                     fromView:(UIView *)fromView toView:(UIView *)toView {
    static const float perspectiveFactor = -1/500.0;
    UIView *containerView = [context containerView];
    toView.frame = [context finalFrameForViewController:toViewController];
    if ([context isAnimated]) {
        CGSize viewSize = toView.frame.size;
        [containerView addSubview:toView];

        CGRect topFrame = CGRectMake(0.0, 0.0, viewSize.width, viewSize.height/2);
        CGRect bottomFrame = CGRectMake(0.0, viewSize.height/2, viewSize.width, viewSize.height/2);
        UIView *topHalfImage = [toView resizableSnapshotViewFromRect:topFrame
                                                  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        topHalfImage.frame = topFrame;
        UIView *bottomHalfImage = [toView resizableSnapshotViewFromRect:bottomFrame
                                                     afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
        bottomHalfImage.frame = bottomFrame;

        [fromView addSubview:topHalfImage];
        topHalfImage.layer.anchorPoint = CGPointMake(0.5, 0.0);
        topHalfImage.layer.position = CGPointMake(viewSize.width / 2.0, 0.0);
        [fromView addSubview:bottomHalfImage];
        bottomHalfImage.layer.anchorPoint = CGPointMake(0.5, 1.0);
        bottomHalfImage.layer.position = CGPointMake(viewSize.width / 2.0, viewSize.height);
        [toView removeFromSuperview];

        CATransform3D rotate3DUp = CATransform3DMakeRotation(M_PI_2, 1.0, 0.0, 0.0);
        rotate3DUp.m34 = perspectiveFactor;
        topHalfImage.layer.transform = rotate3DUp;
        CATransform3D rotate3DDown = CATransform3DMakeRotation(-M_PI_2, 1.0, 0.0, 0.0);
        rotate3DDown.m34 = perspectiveFactor;
        bottomHalfImage.layer.transform = rotate3DDown;

        [containerView insertSubview:toView belowSubview:fromView];
        [UIView animateWithDuration:duration delay:0.0
                            options:0 animations:^{
                                topHalfImage.layer.transform = CATransform3DIdentity;
                                bottomHalfImage.layer.transform = CATransform3DIdentity;
                            } completion:^(BOOL finished) {
                                [containerView addSubview:toView];
                                [topHalfImage removeFromSuperview];
                                [bottomHalfImage removeFromSuperview];
                                [context completeTransition:YES];
                            }];
    } else {
        [containerView addSubview:toView];
    }
}


- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return duration;
}

@end

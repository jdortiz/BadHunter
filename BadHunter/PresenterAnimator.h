//
//  PresenterAnimator.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 13/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface PresenterAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype) initForwardTransition:(BOOL)forward;

@end

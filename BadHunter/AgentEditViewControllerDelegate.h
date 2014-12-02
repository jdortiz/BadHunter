//
//  AgentEditViewControllerProtocol.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


@class DetailViewController;

@protocol AgentEditViewControllerDelegate <NSObject>

- (void) dismissAgentEditViewController:(DetailViewController *)agentEditVC
                           modifiedData:(BOOL)modifiedData;

@end
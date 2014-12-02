//
//  AgentEditViewControllerProtocol.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


@class AgentEditViewController;

@protocol AgentEditViewControllerDelegate <NSObject>

- (void) dismissAgentEditViewController:(AgentEditViewController *)agentEditVC
                           modifiedData:(BOOL)modifiedData;

@end
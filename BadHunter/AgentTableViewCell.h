//
//  AgentTableViewCell.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 9/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface AgentTableViewCell : UITableViewCell

- (void) displayName:(NSString *)name;
- (void) displayAppraisal:(NSNumber *)assessment;
- (void) displayPicture:(UIImage *)picture;
- (void) displayDescription:(NSString *)agentDescription;

@end

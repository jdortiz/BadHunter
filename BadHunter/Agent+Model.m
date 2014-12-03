//
//  Agent+Model.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 3/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"

NSString *const agentPropertyName = @"name";
NSString *const agentPropertyAppraisal = @"appraisal";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";
NSString *const agentPropertyPictureUUID = @"pictureUUID";


@implementation Agent (Model)

#pragma mark - Dependencies


+ (NSSet *) keyPathsForValuesAffectingAppraisal {
    return [NSSet setWithArray:@[agentPropertyDestructionPower,
                                             agentPropertyMotivation]];
}


#pragma mark - Custom getters & setters

- (NSNumber *) appraisal {
    [self willAccessValueForKey:agentPropertyAppraisal];
    NSUInteger destructionPower = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.motivation unsignedIntegerValue];
    NSUInteger appraisal = (destructionPower + motivation) / 2;
    [self didAccessValueForKey:agentPropertyAppraisal];
    
    return @(appraisal);
}


@end

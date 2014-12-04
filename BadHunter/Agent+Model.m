//
//  Agent+Model.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 3/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";
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
    NSNumber *appraisalValue;
    if ([self primitiveValueForKey:agentPropertyAppraisal] == nil) {
        [self updateAppraisalValue];
    }
    [self willAccessValueForKey:agentPropertyAppraisal];
    appraisalValue = [self primitiveValueForKey:agentPropertyAppraisal];
    [self didAccessValueForKey:agentPropertyAppraisal];

    return appraisalValue;
}


- (void) setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:agentPropertyDestructionPower];
    [self setPrimitiveValue:destructionPower forKey:agentPropertyDestructionPower];
    [self updateAppraisalValue];
    [self didChangeValueForKey:agentPropertyDestructionPower];
}


- (void) setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:agentPropertyMotivation];
    [self setPrimitiveValue:motivation forKey:agentPropertyMotivation];
    [self updateAppraisalValue];
    [self didChangeValueForKey:agentPropertyMotivation];
}


- (void) updateAppraisalValue {
    NSUInteger destructionPower = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.motivation unsignedIntegerValue];
    NSUInteger appraisal = (destructionPower + motivation) / 2;
    [self setPrimitiveValue:@(appraisal) forKey:agentPropertyAppraisal];
}


#pragma mark - Fetch requests

+ (NSFetchRequest *) fetchForAllAgents {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:agentEntityName];
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:agentPropertyName
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    return fetchRequest;
}


+ (NSFetchRequest *) fetchForAllAgentsWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:agentEntityName];
    fetchRequest.fetchBatchSize = 20;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:agentPropertyName
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    fetchRequest.predicate = predicate;
    
    return fetchRequest;
}

#pragma mark - Picture logic

- (NSString *) generatePictureUUID {
    CFUUIDRef     fileUUID;
    CFStringRef   fileUUIDString;
    fileUUID = CFUUIDCreate(kCFAllocatorDefault);
    fileUUIDString = CFUUIDCreateString(kCFAllocatorDefault, fileUUID);
    CFRelease(fileUUID);
    return (__bridge_transfer NSString *)fileUUIDString;
}

@end

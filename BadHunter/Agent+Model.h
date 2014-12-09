//
//  Agent+Model.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 3/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

extern NSString *const agentEntityName;
extern NSString *const agentPropertyAppraisal;
extern NSString *const agentPropertyName;
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;
extern NSString *const agentPropertyPictureUUID;


@interface Agent (Model)

+ (instancetype) agentInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (NSFetchRequest *) fetchForAllAgents;
+ (NSFetchRequest *) fetchForAllAgentsWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *) fetchForAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors;
- (NSString *) generatePictureUUID;

@end

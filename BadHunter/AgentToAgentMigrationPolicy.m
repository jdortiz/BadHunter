//
//  AgentToAgentMigrationPolicy.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 8/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "AgentToAgentMigrationPolicy.h"
#import "Power+Model.h"

NSString *const agentOldPropertyPower = @"power";


@implementation AgentToAgentMigrationPolicy

- (BOOL) createDestinationInstancesForSourceInstance:(NSManagedObject *)srcInstance
                                       entityMapping:(NSEntityMapping *)mapping
                                             manager:(NSMigrationManager *)manager
                                               error:(NSError *__autoreleasing *)error {
    NSManagedObject *dstInstance = [NSEntityDescription insertNewObjectForEntityForName:mapping.destinationEntityName
                                                               inManagedObjectContext:manager.destinationContext];
    [self transferAttributesFromInstance:srcInstance toInstance:dstInstance];
    [self extractPowerInstanceWithName:[srcInstance valueForKey:agentOldPropertyPower]
                   relatedWithInstance:dstInstance];
    [manager associateSourceInstance:srcInstance
             withDestinationInstance:dstInstance
                    forEntityMapping:mapping];
    return YES;
}


- (void) transferAttributesFromInstance:(NSManagedObject *)srcInstance
                             toInstance:(NSManagedObject *)dstInstance {
    NSArray *dstAttributes = [dstInstance.entity.attributesByName allKeys];
    for (NSString *key in dstAttributes) {
        id value = [srcInstance valueForKey:key];
        
        if (value && ![value isEqual:[NSNull null]]) {
            [dstInstance setValue:value forKey:key];
        }
    }
}


- (void) extractPowerInstanceWithName:(NSString *)name relatedWithInstance:(NSManagedObject *)dstInstance {
    if (name) {
        Power *power = [Power fetchPowerInMOC:dstInstance.managedObjectContext withName:name];
        if (!power) {
            power = [NSEntityDescription insertNewObjectForEntityForName:powerEntityName
                                                  inManagedObjectContext:dstInstance.managedObjectContext];
            power.name = name;
        }
        [power addAgentsObject:(Agent *)dstInstance];
    }

}

@end

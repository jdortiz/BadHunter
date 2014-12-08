//
//  Power.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 8/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Agent;

@interface Power : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *agents;
@end

@interface Power (CoreDataGeneratedAccessors)

- (void)addAgentsObject:(Agent *)value;
- (void)removeAgentsObject:(Agent *)value;
- (void)addAgents:(NSSet *)values;
- (void)removeAgents:(NSSet *)values;

@end

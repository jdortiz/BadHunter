//
//  Model.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 9/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Model.h"
#import "Agent+Model.h"
#import "FreakType+Model.h"



@implementation Model

#pragma mark - Constants & Parameters

static NSUInteger importedObjectsCount = 10000;

- (void) importData {
    NSManagedObjectContext *background = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    background.parentContext = self.managedObjectContext;
    [self importDataInMOC:background];
}


- (void) importDataInMOC:(NSManagedObjectContext *)moc {
    [moc performBlock:^{
        for (NSUInteger i = 0; i < importedObjectsCount; i++) {
            FreakType *freakType = [FreakType freakTypeInMOC:moc
                                                    withName:@"Monster"];
            Agent *agent = [Agent agentInMOC:moc
                                    withName:[NSString stringWithFormat:@"Agent %lu",(unsigned long)i]];
            agent.category = freakType;
            usleep(5000000/importedObjectsCount);
        }
        [moc save:NULL];
    }];
}


@end

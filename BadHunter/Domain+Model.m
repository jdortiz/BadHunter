//
//  Domain+Model.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 4/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain+Model.h"

NSString *const domainEntityName = @"Domain";
NSString *const domainPropertyName = @"name";


@implementation Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:domainEntityName
                                                   inManagedObjectContext:moc];
    domain.name = name;
    
    return domain;
}


+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:domainEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", domainPropertyName, name];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:NULL];
    
    return [results lastObject];
}

@end

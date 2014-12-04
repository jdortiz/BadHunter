//
//  FreakType+Model.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 4/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "FreakType+Model.h"

NSString *const freakTypeEntityName = @"FreakType";
NSString *const freakTypePropertyName = @"name";


@implementation FreakType (Model)

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:freakTypeEntityName
                                                         inManagedObjectContext:moc];
    freakType.name = name;

    return freakType;
}


+ (FreakType *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:freakTypeEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@",
                              freakTypePropertyName, name];

    return [[moc executeFetchRequest:fetchRequest error:NULL] firstObject];
}

@end

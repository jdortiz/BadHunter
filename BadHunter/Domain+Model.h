//
//  Domain+Model.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 4/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain.h"

extern NSString *const domainEntityName;
extern NSString *const domainPropertyName;


@interface Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;

@end

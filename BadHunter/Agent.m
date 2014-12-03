//
//  Agent.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 3/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"


@implementation Agent

@dynamic appraisal;
@dynamic destructionPower;
@dynamic motivation;
@dynamic name;

#pragma mark - Model Logic

- (NSNumber *) appraisal {
    [self willAccessValueForKey:@"appraisal"];
    NSUInteger destructionPower = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.motivation unsignedIntegerValue];
    NSUInteger appraisal = (destructionPower + motivation) / 2;
    [self didAccessValueForKey:@"appraisal"];
    
    return @(appraisal);
}


- (void) setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:@"destructionPower"];
    [self willChangeValueForKey:@"appraisal"];
    [self setPrimitiveValue:destructionPower forKey:@"destructionPower"];
    [self didChangeValueForKey:@"destructionPower"];
    [self didChangeValueForKey:@"appraisal"];
}


- (void) setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:@"motivation"];
    [self willChangeValueForKey:@"appraisal"];
    [self setPrimitiveValue:motivation forKey:@"motivation"];
    [self didChangeValueForKey:@"motivation"];
    [self didChangeValueForKey:@"appraisal"];
}

@end

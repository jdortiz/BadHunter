//
//  AppDelegateTests.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 5/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "AppDelegate.h"


@interface AppDelegateTests : XCTestCase {
    // Object to test.
    AppDelegate *sut;
}

@end



@interface MocFake : NSManagedObjectContext

@property (assign) BOOL saveWasCalled;

@end

@implementation MocFake

- (BOOL) hasChanges {
    return YES;
}

- (BOOL) save:(NSError *__autoreleasing *)error {
    self.saveWasCalled = YES;
    return YES;
}

@end



@implementation AppDelegateTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createSut];
}


- (void) createSut {
    sut = [[AppDelegate alloc] init];
}


- (void) tearDown {
    [self releaseSut];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

@end

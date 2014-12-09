//
//  AppDelegate.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AppDelegate.h"
#import "AgentEditViewController.h"
#import "AgentsViewController.h"
#import "Agent+Model.h"
#import "FreakType+Model.h"



@interface AppDelegate ()

@end



@implementation AppDelegate

#pragma mark - Constants & Parameters

static NSUInteger importedObjectsCount = 10000;


#pragma mark - Application lifecycle

- (BOOL) application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self importData];
    [self prepareRootViewController];
    return YES;
}


- (void) prepareRootViewController {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    AgentsViewController *controller = (AgentsViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Data importer

- (void) importData {
    __weak typeof(self)weakSelf = self;
    [self.managedObjectContext performBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (NSUInteger i = 0; i < importedObjectsCount; i++) {
            FreakType *freakType = [FreakType freakTypeInMOC:strongSelf.managedObjectContext
                                                    withName:@"Monster"];
            Agent *agent = [Agent agentInMOC:strongSelf.managedObjectContext
                                    withName:[NSString stringWithFormat:@"Agent %lu",i]];
            agent.category = freakType;
            usleep(5000000/importedObjectsCount);
        }
        [strongSelf.managedObjectContext save:NULL];
    }];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSURL *) applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.powwau.BadHunter" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSManagedObjectModel *) managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BadHunter" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator == nil) {
        // Create the coordinator and store
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BadHunter.sqlite"];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        NSDictionary *lightweightOptions = @{ NSInferMappingModelAutomaticallyOption: @YES,
                                              NSMigratePersistentStoresAutomaticallyOption: @YES };
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:lightweightOptions
                                                               error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *) managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];

            [self prepareUndoForContext:_managedObjectContext];
        }
    }

    return _managedObjectContext;
}


- (void) prepareUndoForContext:(NSManagedObjectContext *)moc {
    moc.undoManager = [[NSUndoManager alloc] init];
    moc.undoManager.groupsByEvent = NO;
    moc.undoManager.levelsOfUndo = 10;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

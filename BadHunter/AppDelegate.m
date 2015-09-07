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
#import "Model.h"



@interface AppDelegate ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *rootMOC;
@property (strong, nonatomic) Model *model;

@end



@implementation AppDelegate

#pragma mark - Application lifecycle

- (BOOL) application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeModel];
    [self prepareRootViewController];
    return YES;
}


- (void) initializeModel {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.model.fileURL path]]) {
        // Create the document if it doesn't exist.
        __weak typeof(self)weakSelf = self;
        [self.model saveToURL:self.model.fileURL
             forSaveOperation:UIDocumentSaveForCreating
            completionHandler:^(BOOL success) {
                if (success) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf.model importData];
                }
            }];
    } else {
        // Open it if is not opened yet.
        if (self.model.documentState == UIDocumentStateClosed) {
            [self.model openWithCompletionHandler:^(BOOL success) {
                if (success) {
                }
            }];
        }
    }
}


- (void) prepareRootViewController {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    AgentsViewController *controller = (AgentsViewController *)navigationController.topViewController;
    controller.model = self.model;
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
}


#pragma mark - Core Data stack

- (Model *) model {
    if (_model == nil) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"model.badhunter"];
        _model = [[Model alloc] initWithFileURL:storeURL];
    }
    
    return _model;
}


- (NSURL *) applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.powwau.BadHunter" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

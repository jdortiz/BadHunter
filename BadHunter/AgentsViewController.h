//
//  MasterViewController.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AgentEditViewControllerDelegate.h"
#import "Model.h"


@interface AgentsViewController : UITableViewController <UIViewControllerTransitioningDelegate,
NSFetchedResultsControllerDelegate, AgentEditViewControllerDelegate>

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Model *model;

@end


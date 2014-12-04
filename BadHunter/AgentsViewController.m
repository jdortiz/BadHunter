//
//  MasterViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AgentsViewController.h"
#import "AgentEditViewController.h"
#import "Agent+Model.h"


@interface AgentsViewController ()

@end


@implementation AgentsViewController

#pragma mark - Parameters & Constants

static NSString *const segueCreateAgent = @"CreateAgent";
static NSString *const segueEditAgent = @"EditAgent";


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:segueCreateAgent]) {
        AgentEditViewController *agentEditVC = (AgentEditViewController *)[[segue destinationViewController] topViewController];
        [self prepareAgentEditViewController:agentEditVC withAgent:nil];
    } else if ([[segue identifier] isEqualToString:segueEditAgent]) {
        AgentEditViewController *agentEditVC = (AgentEditViewController *)[[segue destinationViewController] topViewController];
        Agent *agent = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        [self prepareAgentEditViewController:agentEditVC withAgent:agent];
    }
}


- (void) prepareAgentEditViewController:(AgentEditViewController *)agentEditVC
                              withAgent:(Agent *)agent {
    [self.managedObjectContext.undoManager beginUndoGrouping];
    if (agent == nil) {
        [self.managedObjectContext.undoManager setActionName:@"new agent"];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        agent = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                              inManagedObjectContext:self.managedObjectContext];
    } else {
        [self.managedObjectContext.undoManager setActionName:@"edit agent"];
    }
    agentEditVC.agent = agent;
    agentEditVC.delegate = self;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = agent.name;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController == nil) {
        [NSFetchedResultsController deleteCacheWithName:@"Agents"];
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K < %@",
                                  agentPropertyDestructionPower, @2];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Agent fetchForAllAgentsWithPredicate:predicate]
                                                                        managedObjectContext:self.managedObjectContext
                                                                                                      sectionNameKeyPath:nil cacheName:@"Agents"];
        _fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        if (![_fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Agent edit view controller delegate

- (void) dismissAgentEditViewController:(id)agentEditVC modifiedData:(BOOL)modifiedData {
    [self.managedObjectContext.undoManager endUndoGrouping];
    if (modifiedData) {
        [self saveContext];
    } else {
        [self.managedObjectContext.undoManager undo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) saveContext {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Couldn't save data: %@, %@", error, [error userInfo]);
        abort();
    }
}

@end

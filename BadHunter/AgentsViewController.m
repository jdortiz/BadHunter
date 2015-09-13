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
#import "Domain+Model.h"
#import "ImageMapper.h"
#import "AgentTableViewCell.h"
#import "PresenterAnimator.h"


@interface AgentsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) ImageMapper *imageMapper;

@end



@implementation AgentsViewController

#pragma mark - Parameters & Constants

static NSString *const segueCreateAgent = @"CreateAgent";
static NSString *const segueEditAgent = @"EditAgent";
static NSString *const segueShowCredits = @"ShowCredits";
static CGFloat estimatedHeight = 88;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self registerModelObserver];
    [self setTableViewForDynamicHeights];
    [self displayControlledDomainsInTitle];
}


- (void)setTableViewForDynamicHeights {
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = estimatedHeight;
}


- (void) registerModelObserver {
    [self.notificationCenter addObserver:self
                                selector:@selector(modelStatusChanged)
                                    name:UIDocumentStateChangedNotification
                                  object:self.model];
}


- (void) modelStatusChanged {
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}


#pragma mark - Display information

- (void) displayControlledDomainsInTitle {
    NSError *error;
    NSUInteger controlledDomains = [self.model.managedObjectContext countForFetchRequest:[Domain fetchForControlledDomains]
                                                                             error:&error];
    self.title = [NSString stringWithFormat:@"Controlled domains: %lu", (unsigned long)controlledDomains];
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((UIViewController *)segue.destinationViewController).transitioningDelegate = self;
    if ([segue.identifier isEqualToString:segueCreateAgent]) {
        AgentEditViewController *agentEditVC = (AgentEditViewController *)[[segue destinationViewController] topViewController];
        [self prepareAgentEditViewController:agentEditVC withAgent:nil];
    } else if ([segue.identifier isEqualToString:segueEditAgent]) {
        AgentEditViewController *agentEditVC = (AgentEditViewController *)[[segue destinationViewController] topViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Agent *agent = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        [self prepareAgentEditViewController:agentEditVC withAgent:agent];
    }
}


- (void) prepareAgentEditViewController:(AgentEditViewController *)agentEditVC
                              withAgent:(Agent *)agent {
    [self.model.managedObjectContext.undoManager beginUndoGrouping];
    if (agent == nil) {
        [self.model.managedObjectContext.undoManager setActionName:@"new agent"];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        agent = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                              inManagedObjectContext:self.model.managedObjectContext];
    } else {
        [self.model.managedObjectContext.undoManager setActionName:@"edit agent"];
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
    AgentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
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


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *categoryName = [[self.fetchedResultsController sections][section] name];
    NSNumber *dpAvg = [[[[self.fetchedResultsController sections] objectAtIndex:section] objects] valueForKeyPath:@"@avg.destructionPower"];
    return [NSString stringWithFormat:@"%@ (%@)", categoryName, dpAvg];
}


- (void) configureCell:(AgentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell displayPicture:[self.imageMapper retrieveImageWithUUID:agent.pictureUUID]];

    [cell displayName:agent.name];
    [cell displayAppraisal:agent.appraisal];
    NSInteger randomDescr = indexPath.row % 3;
    NSString *agentDescription;
    switch (randomDescr) {
        case 0:
            agentDescription = @"This is an agent that everybody would like to hire.";
            break;
        case 1:
            agentDescription = @"This is an agent that we might consider to hire. It may be very valuable in field operations.";
            break;
        case 2:
            agentDescription = @"Don't ever hire an agent like this one it is very dangerous. It can be lethal not only to our enemies, but also to us. You have been warned. I will say that I told you so.";
            break;
            
        default:
            break;
    }
    [cell displayDescription:agentDescription];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController == nil) {
        static NSString *const sectionName = @"category.name";
        [NSFetchedResultsController deleteCacheWithName:@"Agents"];
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSSortDescriptor *categorySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sectionName ascending:YES];
        NSSortDescriptor *dpSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyDestructionPower ascending:YES];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Agent fetchForAllAgentsWithSortDescriptors:@[categorySortDescriptor, dpSortDescriptor, nameSortDescriptor]]
                                                                        managedObjectContext:self.model.managedObjectContext
                                                                                                      sectionNameKeyPath:sectionName cacheName:@"Agents"];
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

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self displayControlledDomainsInTitle];
}


#pragma mark - Agent edit view controller delegate

- (void) dismissAgentEditViewController:(id)agentEditVC modifiedData:(BOOL)modifiedData {
    [self.model.managedObjectContext.undoManager endUndoGrouping];
    if (modifiedData) {
        [self saveContext];
    } else {
        [self.model.managedObjectContext.undoManager undo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) saveContext {
    NSError *error = nil;
    if (![self.model.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Couldn't save data: %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - Unwind Credits View Controller

- (IBAction) dismissCredits:(UIStoryboardSegue *)sender {
    
}


#pragma mark - View Controller Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[PresenterAnimator alloc] initForwardTransition:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[PresenterAnimator alloc] initForwardTransition:NO];
}


#pragma mark - Lazy instantiantion for dependency injection

- (ImageMapper *) imageMapper {
    if (_imageMapper == nil) {
        _imageMapper = [[ImageMapper alloc] init];
    }
    return _imageMapper;
}


- (NSNotificationCenter *) notificationCenter {
    if (_notificationCenter == nil) {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    return _notificationCenter;
}

@end

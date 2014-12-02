//
//  DetailViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Parameters & Constants

NSArray *appraisalValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.agent) {
        [self initializeDestroyPowerViews];
        [self initializeMotivationViews];
        [self initializeAppraisalView];
    }
}


- (void) initializeDestroyPowerViews {
    destroyPowerValues = @[@"Soft", @"Weak", @"Potential", @"Destroyer", @"Nuke"];
    self.destructionPowerLabel.text = [destroyPowerValues objectAtIndex:0];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite", @"Interested", @"Focused"];
    self.motivationLabel.text = [motivationValues objectAtIndex:0];
}


- (void) initializeAppraisalView {
    appraisalValues = @[@"No way", @"Better not", @"Maybe", @"Yes", @"A must"];
    self.appraisalLabel.text = [appraisalValues objectAtIndex:0];
}


#pragma mark - UI Actions

- (IBAction) cancel:(id)sender {
    [self.delegate dismissAgentEditViewController:self modifiedData:NO];
}


- (IBAction) save:(id)sender {
    [self assignDataToAgent];
    [self.delegate dismissAgentEditViewController:self modifiedData:YES];
}


- (void) assignDataToAgent {
    [self.agent setValue:self.nameTextField.text forKey:@"name"];
}


- (IBAction) changeDestructionPower:(id)sender {
    NSUInteger newDestructionPower = (NSUInteger)(self.destructionPowerStepper.value + 0.5);
    [self.agent setValue:@(newDestructionPower) forKey:@"destructionPower"];
}


- (IBAction) changeMotivation:(id)sender {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    [self.agent setValue:@(newMotivation) forKey:@"motivation"];
}


#pragma mark - Managing the detail item

- (void)setAgent:(id)newDetailItem {
    if (_agent != newDetailItem) {
        _agent = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

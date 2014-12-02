//
//  DetailViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AgentEditViewController.h"

@interface AgentEditViewController ()

@end

@implementation AgentEditViewController

#pragma mark - Parameters & Constants

NSArray *appraisalValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;


#pragma mark - Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    [self configureView];
}


- (void) configureView {
    // Update the user interface for the detail item.
    if (self.agent) {
        [self initializeDestroyPowerViews];
        [self initializeMotivationViews];
        [self initializeAppraisalView];
    }
}


- (void) initializeDestroyPowerViews {
    destroyPowerValues = @[@"Soft", @"Weak", @"Potential", @"Destroyer", @"Nuke"];
    [self displayDestructionPowerLabel];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite", @"Interested", @"Focused"];
    [self displayMotivationLabel];
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
    [self updateDestructionPowerValue];
    [self updateDestructionPowerViews];
}


- (void) updateDestructionPowerValue {
    NSUInteger newDestructionPower = (NSUInteger)(self.destructionPowerStepper.value + 0.5);
    [self.agent setValue:@(newDestructionPower) forKey:@"destructionPower"];
}


- (void) updateDestructionPowerViews {
    [self displayDestructionPowerLabel];
    [self displayAppraisalLabel];
}


- (IBAction) changeMotivation:(id)sender {
    [self updateMotivationValue];
    [self updateMotivationViews];
}


- (void) updateMotivationValue {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    [self.agent setValue:@(newMotivation) forKey:@"motivation"];
}


- (void) updateMotivationViews {
    [self displayMotivationLabel];
    [self displayAppraisalLabel];
}


#pragma mark - Presentation

- (void) displayDestructionPowerLabel {
    NSUInteger destructionPower = [[self.agent valueForKey:@"destructionPower"] unsignedIntegerValue];
    self.destructionPowerLabel.text = destroyPowerValues[destructionPower];
}


- (void) displayMotivationLabel {
    NSUInteger motivation = [[self.agent valueForKey:@"motivation"] unsignedIntegerValue];
    self.motivationLabel.text = motivationValues[motivation];
}


- (void) displayAppraisalLabel {
    NSUInteger destructionPower = [[self.agent valueForKey:@"destructionPower"] unsignedIntegerValue];
    NSUInteger motivation = [[self.agent valueForKey:@"motivation"] unsignedIntegerValue];
    NSUInteger appraisal = (destructionPower + motivation) / 2;
    self.appraisalLabel.text = appraisalValues[appraisal];
}

@end

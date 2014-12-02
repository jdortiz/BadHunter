//
//  DetailViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AgentEditViewController.h"
#import "Agent.h"


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


- (void) viewWillAppear:(BOOL)animated {
    [self addObserverForProperties];
}


- (void)addObserverForProperties {
    [self addObserver:self forKeyPath:@"agent.destructionPower"
              options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"agent.motivation"
              options:NSKeyValueObservingOptionNew context:NULL];
}


- (void) viewDidDisappear:(BOOL)animated {
    [self removeObserverForProperties];
}


- (void)removeObserverForProperties {
    [self removeObserver:self forKeyPath:@"agent.destructionPower"];
    [self removeObserver:self forKeyPath:@"agent.motivation"];
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
    self.agent.name = self.nameTextField.text;
}


- (IBAction) changeDestructionPower:(id)sender {
    [self updateDestructionPowerValue];
    [self displayAppraisalLabel];
}


- (void) updateDestructionPowerValue {
    NSUInteger newDestructionPower = (NSUInteger)(self.destructionPowerStepper.value + 0.5);
    self.agent.destructionPower = @(newDestructionPower);
}


- (IBAction) changeMotivation:(id)sender {
    [self updateMotivationValue];
    [self displayAppraisalLabel];
}


- (void) updateMotivationValue {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    self.agent.motivation = @(newMotivation);
}


#pragma mark - Presentation

- (void) displayDestructionPowerLabel {
    NSUInteger destructionPower = [self.agent.destructionPower unsignedIntegerValue];
    self.destructionPowerLabel.text = destroyPowerValues[destructionPower];
}


- (void) displayMotivationLabel {
    NSUInteger motivation = [self.agent.motivation unsignedIntegerValue];
    self.motivationLabel.text = motivationValues[motivation];
}


- (void) displayAppraisalLabel {
    NSUInteger destructionPower = [self.agent.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.agent.motivation unsignedIntegerValue];
    NSUInteger appraisal = (destructionPower + motivation) / 2;
    self.appraisalLabel.text = appraisalValues[appraisal];
}


#pragma mark - Observations

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"agent.destructionPower"]) {
        [self displayDestructionPowerLabel];
    } else if ([keyPath isEqualToString:@"agent.motivation"]) {
        [self displayMotivationLabel];
    }
}

@end

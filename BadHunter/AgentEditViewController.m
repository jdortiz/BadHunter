//
//  DetailViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AgentEditViewController.h"
#import "Agent+Model.h"


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
    if (self.agent) {
        [self displayAgentName];
        [self initializeDestroyPowerViews];
        [self initializeMotivationViews];
        [self initializeAppraisalView];
    }
}


- (void) initializeDestroyPowerViews {
    destroyPowerValues = @[@"Soft", @"Weak", @"Potential", @"Destroyer", @"Nuke"];
    [self initializeDestructionPowerStepper];
    [self displayDestructionPowerLabel];
}


- (void) initializeDestructionPowerStepper {
    self.destructionPowerStepper.value = [self.agent.destructionPower floatValue];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite", @"Interested", @"Focused"];
    [self initializeMotivationStepper];
    [self displayMotivationLabel];
}


- (void) initializeMotivationStepper {
    self.motivationStepper.value = [self.agent.motivation floatValue];
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
    [self addObserver:self forKeyPath:@"agent.appraisal"
              options:NSKeyValueObservingOptionNew context:NULL];
}


- (void) viewDidDisappear:(BOOL)animated {
    [self removeObserverForProperties];
}


- (void)removeObserverForProperties {
    [self removeObserver:self forKeyPath:@"agent.destructionPower"];
    [self removeObserver:self forKeyPath:@"agent.motivation"];
    [self removeObserver:self forKeyPath:@"agent.appraisal"];
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
    NSUInteger newDestructionPower = (NSUInteger)(self.destructionPowerStepper.value + 0.5);
    self.agent.destructionPower = @(newDestructionPower);
}


- (IBAction) changeMotivation:(id)sender {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    self.agent.motivation = @(newMotivation);
}


#pragma mark - Presentation

- (void) displayAgentName {
    self.nameTextField.text = self.agent.name;
}


- (void) displayDestructionPowerLabel {
    NSUInteger destructionPower = [self.agent.destructionPower unsignedIntegerValue];
    self.destructionPowerLabel.text = destroyPowerValues[destructionPower];
}


- (void) displayMotivationLabel {
    NSUInteger motivation = [self.agent.motivation unsignedIntegerValue];
    self.motivationLabel.text = motivationValues[motivation];
}


- (void) displayAppraisalLabel {
    NSUInteger appraisal = [self.agent.appraisal unsignedIntegerValue];
    self.appraisalLabel.text = appraisalValues[appraisal];
}


#pragma mark - Observations

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"agent.destructionPower"]) {
        [self displayDestructionPowerLabel];
    } else if ([keyPath isEqualToString:@"agent.motivation"]) {
        [self displayMotivationLabel];
    } else if ([keyPath isEqualToString:@"agent.appraisal"]) {
        [self displayAppraisalLabel];
    }
}


#pragma mark - Text field delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;
    if (textField == self.nameTextField) {
        [textField resignFirstResponder];
        shouldReturn = NO;
    }

    return shouldReturn;
}

@end

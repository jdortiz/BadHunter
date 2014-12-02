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
    if (self.detailItem) {
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


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

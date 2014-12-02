//
//  DetailViewController.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *appraisalLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionPowerStepper;
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;

@end


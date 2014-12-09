//
//  DetailViewController.h
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AgentEditViewControllerDelegate.h"

@class Agent;


@interface AgentEditViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Agent *agent;
@property (weak, nonatomic) id<AgentEditViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UILabel *appraisalLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destructionPowerStepper;
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;

@end

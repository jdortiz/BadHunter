//
//  DetailViewController.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 2/12/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "AgentEditViewController.h"
#import "Agent+Model.h"
#import "FreakType.h"
#import "Domain.h"
#import "ImageMapper.h"
#import "UIImage+AgentAdjust.h"


typedef NS_ENUM(NSInteger, actionSheetButtons) {
    actionSheetTakePicture = 0, // actionSheet.firstOtherButtonIndex
    actionSheetLibrary,
    actionSheetEditPicture
};

typedef NS_ENUM(NSInteger, ImageStatus) {
    ImageStatusDoNothing = 0,
    ImageStatusPreserveNew,
    ImageStatusDelete
};



@interface AgentEditViewController () {
    ImageStatus imageStatus;
}

@property (strong, nonatomic) UIImage *agentPicture;
@property (strong, nonatomic) ImageMapper *imageMapper;

@end



@implementation AgentEditViewController

#pragma mark - Parameters & Constants

NSArray *appraisalValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;
static const CGFloat pictureSide = 200.0;


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
        [self initializePictureView];
        [self initializeCategoryTextField];
        [self initializeDomainsTextField];
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


- (void) initializePictureView {
    [self loadAgentPicture];
    [self displayAgentPicture];
}


- (void) initializeCategoryTextField {
    if (self.agent.category != nil) {
        // if it is read from the data, it exists.
        [self decorateTextField:self.categoryTextField withContents:@[self.agent.category.name] values:@[@YES]];
    }
}


- (void) initializeDomainsTextField {
    if ([self.agent.domains count] > 0) {
        NSArray *contents = [[self.agent.domains valueForKey:@"name"] allObjects];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[contents count]];
        for (NSUInteger i = 0; i < [contents count]; i++) {
            [values addObject:@(YES)];
        }
        [self decorateTextField:self.domainsTextField withContents:contents values:values];
    }
}


- (void) loadAgentPicture {
    if (self.agent.pictureUUID) {
        self.agentPicture = [self.imageMapper retrieveImageWithUUID:self.agent.pictureUUID];
    }
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
    [self persistImageChanges];
    [self.delegate dismissAgentEditViewController:self modifiedData:YES];
}


- (void) persistImageChanges {
    if (imageStatus == ImageStatusPreserveNew) {
        if (self.agent.pictureUUID == nil) {
            self.agent.pictureUUID = [self.agent generatePictureUUID];
        }
        [self.imageMapper storeImage:self.agentPicture withUUID:self.agent.pictureUUID];
    } else if (imageStatus == ImageStatusDelete) {
        [self.imageMapper deleteImageWithUUID:self.agent.pictureUUID];
        self.agent.pictureUUID = nil;
    }
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


- (IBAction) editImage:(id)sender {
    [self offerImageActions];
}


- (void) offerImageActions {
    NSString *deleteButtonTitle = nil;
    if ((imageStatus == ImageStatusPreserveNew) || (self.agent.pictureUUID != nil)) {
        deleteButtonTitle = @"Delete Image";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:deleteButtonTitle
                                  otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:self.navigationController.view];
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


- (void) displayAgentPicture {
    [self.imageButton setImage:self.agentPicture forState:UIControlStateNormal];
}


#pragma mark - Lazy instantiantion for dependency injection

- (ImageMapper *) imageMapper {
    if (_imageMapper == nil) {
        _imageMapper = [[ImageMapper alloc] init];
    }
    return _imageMapper;
}


#pragma mark - Action Sheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self deletePicture];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self obtainPictureFromCamera:YES];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + actionSheetLibrary) {
        [self obtainPictureFromCamera:NO];
    }
}


- (void) obtainPictureFromCamera:(BOOL)useCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (useCamera &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void) deletePicture {
    imageStatus = ImageStatusDelete;
    self.agentPicture = nil;
    [self displayAgentPicture];
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


#pragma mark - Image picker view controller delegate

- (void) imagePickerController:(UIImagePickerController *)imagePickerController
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.agentPicture = [info[UIImagePickerControllerEditedImage] imageSquaredWithSide:pictureSide];
    // AgentPicture is not observed, because it changes while this controller is hidden.
    [self displayAgentPicture];
    imageStatus = ImageStatusPreserveNew;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField || textField == self.domainsTextField) {
        [self removeDecorationOfTextInTextField:textField];
    }
}


- (void) removeDecorationOfTextInTextField:(UITextField *)textField {
    textField.attributedText = [[NSAttributedString alloc] initWithString:textField.text
                                                               attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}


- (void) textFieldDidEndEditing:(UITextField *)textField {
    BOOL exists = YES;
    if (textField == self.categoryTextField) {
        NSString *category = self.categoryTextField.text;
//        exists = ([FreakType fetchInMOC:self.agent.managedObjectContext
//                               withName:category] != nil);
        [self decorateTextField:textField withContents:@[category] values:@[@(exists)]];
    } else if (textField == self.domainsTextField) {
        NSString *domainsString = self.domainsTextField.text;
        NSArray *domains = [domainsString componentsSeparatedByString:@","];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[domains count]];
        for (NSString *domain in domains) {
//            exists = ([Domain fetchInMOC:self.agent.managedObjectContext
//                                withName:domain] != nil);
            [values addObject:@(exists)];
            if (domain !=nil) exists = !exists;
        }
        [self decorateTextField:textField withContents:domains values:values];
    }
}


- (void) decorateTextField:(UITextField *)textField withContents:(NSArray *)contents
                    values:(NSArray *)values {
    NSMutableAttributedString *coloredString = [[NSMutableAttributedString alloc] init];
    for (NSUInteger i = 0; i < [contents count]; i++) {
        BOOL exists = [[values objectAtIndex:i] boolValue];
        NSString *substring = [contents objectAtIndex:i];
        UIColor *decorationColor = (exists)?[UIColor greenColor]:[UIColor redColor];
        NSAttributedString *attributedSubstring = [[NSAttributedString alloc] initWithString:substring attributes:@{NSForegroundColorAttributeName: decorationColor}];
        [coloredString appendAttributedString:attributedSubstring];
        if (i < ([contents count] - 1)) {
            [coloredString appendAttributedString:[[NSAttributedString alloc] initWithString:@","]];
        }
    }
    textField.attributedText = coloredString;
}

@end

//
//  AgentTableViewCell.m
//  BadHunter
//
//  Created by Jorge D. Ortiz Fuentes on 9/9/15.
//  Copyright (c) 2015 PoWWaU. All rights reserved.
//


#import "AgentTableViewCell.h"


@interface AgentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *agentImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appraisalLabel;

@end



@implementation AgentTableViewCell

#pragma mark - Display methods

- (void) displayName:(NSString *)name {
    self.nameLabel.text = name;
}


- (void) displayAppraisal:(NSNumber *)appraisal {
    NSString *stars;
    NSUInteger uiAppraisal = [appraisal integerValue];
    if (uiAppraisal < 1) {
        stars = @"⭐️";
    } else if (uiAppraisal < 2) {
        stars = @"⭐️⭐️";
    } else if (uiAppraisal < 3) {
        stars = @"⭐️⭐️⭐️";
    } else if (uiAppraisal < 4) {
        stars = @"⭐️⭐️⭐️⭐️";
    } else {
        stars = @"⭐️⭐️⭐️⭐️⭐️";
    }
    self.appraisalLabel.text = stars;
}


- (void) displayPicture:(UIImage *)picture {
    self.agentImageView.image = picture;
}


- (void) displayDescription:(NSString *)agentDescription {
    self.descriptionLabel.text = agentDescription;
}

@end

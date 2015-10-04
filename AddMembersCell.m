//
//  AddMembersCell.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/7/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "AddMembersCell.h"

@implementation AddMembersCell

- (void)awakeFromNib {
    // Initialization code
    self.memberImage.layer.cornerRadius = 6;
    self.memberImage.layer.masksToBounds = YES;
}

@end

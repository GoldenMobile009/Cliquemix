//
//  DiscoveryCell.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "DiscoveryCell.h"

@implementation DiscoveryCell
@synthesize overlayView;
@synthesize imagesView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)updateCellWithGroups:(Groups *)group color:(UIColor *)color{
    float customX = 0.0;
    float customWidth = self.frame.size.width/[group.users count];
    for (int i = 0; i<[group.users count]; i++){
        Profiles *profile = [[ParserEngine sharedInstance] getProfileWithID:[group.users objectAtIndex:i]];
        customX = i * customWidth;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(customX, 0, customWidth, self.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:profile.profilePic]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imagesView addSubview:imageView];
    }
    
    self.groupNameLabel.text = group.groupName;
    
    overlayView.backgroundColor = color;
}
@end

//
//  GroupsCell.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 5/31/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "GroupsCell.h"

@implementation GroupsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];
}
-(void)updateCellWithGroup:(Groups *)group slide:(BOOL)slide{
    self.groupNameLabel.text = group.groupName;
    self.membersNameLabel.text = group.desc;
    self.removeButton.tag = [group.gid integerValue];
    self.muteButton.tag = [group.gid integerValue];
    self.muteImageView.hidden = ![group.mute boolValue];
    
    if (slide) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.componentsView setFrame:CGRectMake(-70, 0, self.componentsView.frame.size.width, self.componentsView.frame.size.height)];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.componentsView setFrame:CGRectMake(0, 0, self.componentsView.frame.size.width, self.componentsView.frame.size.height)];
        }];
    }
    
}
- (void) didSwipe:(UISwipeGestureRecognizer *)recognizer{
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft){
        [UIView animateWithDuration:0.5 animations:^{
            if ([[self delegate] respondsToSelector:@selector(openSlide:)]) {
                [[self delegate] openSlide:YES];
            }
            [self.componentsView setFrame:CGRectMake(-70, 0, self.componentsView.frame.size.width, self.componentsView.frame.size.height)];
        }];
        //Swipe from right to left
        //Do your functions here
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            if ([[self delegate] respondsToSelector:@selector(openSlide:)]) {
                [[self delegate] openSlide:NO];
            }
            [self.componentsView setFrame:CGRectMake(0, 0, self.componentsView.frame.size.width, self.componentsView.frame.size.height)];
        }];
        //Swipe from left to right
        //Do your functions here
    }
}
-(void)onRemoveButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([[self delegate] respondsToSelector:@selector(removeGroup:)]) {
        [[self delegate] openSlide:NO];
        [[self delegate] removeGroup:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
}
-(void)onMuteButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([[self delegate] respondsToSelector:@selector(muteGroup:)]) {
        [[self delegate] openSlide:NO];
        [[self delegate] muteGroup:[NSString stringWithFormat:@"%ld",btn.tag]];
    }
}

@end

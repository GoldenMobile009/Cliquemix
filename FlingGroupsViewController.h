//
//  FlingGroupsViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableViewBackground.h"
#import "ParserEngine.h"

@interface FlingGroupsViewController : UIViewController<mainDragViewDelegate>
{
    IBOutlet UIView *flingView;
    IBOutlet UILabel *groupNameLabel;
}
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)Groups *currentGroup;
@property(nonatomic)BOOL fromChat;

-(id)initWithGroups:(NSArray *)groups currentGroup:(Groups *)group fromChat:(BOOL)fromChat;


-(IBAction)onBackButton:(id)sender;

@end

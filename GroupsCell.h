//
//  GroupsCell.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 5/31/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Groups.h"
@protocol groupsDelegate;

@interface GroupsCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *groupNameLabel;
@property(nonatomic,strong)IBOutlet UILabel *membersNameLabel;
@property(nonatomic,strong)IBOutlet UIView *componentsView;
@property(nonatomic,strong)IBOutlet UIButton *removeButton;
@property(nonatomic,strong)IBOutlet UIButton *muteButton;
@property(nonatomic,strong)IBOutlet UIImageView *muteImageView;

@property(nonatomic,weak)id<groupsDelegate>delegate;

-(IBAction)onRemoveButton:(id)sender;
-(IBAction)onMuteButton:(id)sender;
-(void)updateCellWithGroup:(Groups *)group slide:(BOOL)slide;

@end
@protocol groupsDelegate <NSObject>

-(void)removeGroup:(NSString *)gid;
-(void)muteGroup:(NSString *)gid;
-(void)openSlide:(BOOL)open;


@end
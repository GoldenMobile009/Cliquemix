//
//  MyGroupsViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIViewController+MMDrawerController.h>
#import "CreateGroupViewController.h"
#import "DiscoveryViewController.h"
#import "ChatEngine.h"
#import "GroupsCell.h"

@interface MyGroupsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,groupsDelegate>{
    IBOutlet UITableView *groupsTableView;
    GroupPost *myGroup;
    ParserEngine *myParser;
    ChatEngine *myChat;
    BOOL slide;
}
@property(nonatomic,strong)NSMutableArray *dialogs;

-(IBAction)onMenuButton:(id)sender;
-(IBAction)onAddGroupButton:(id)sender;
-(IBAction)onEditButton:(id)sender;


@end

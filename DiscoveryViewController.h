//
//  DiscoveryViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryCell.h"
#import "FlingGroupsViewController.h"
#import "ParserEngine.h"
#import <MBProgressHUD.h>
#import "ChatViewController.h"
#import "ChatEngine.h"

@interface DiscoveryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,chatDelegate,QBActionStatusDelegate,QBChatDelegate>
{
    IBOutlet UITableView *discoveryTableView;
    ParserEngine *myParser;
    NSArray *groups;
    NSDictionary *colorsDict;
    NSMutableArray *colorsArray;
    dispatch_source_t dispatchSource;
    IBOutlet UILabel *titleLabel;
    ChatEngine *myChat;
}
@property(nonatomic,strong)Groups *group;

-(id)initWithGroup:(Groups *)currentGroup;

-(IBAction)onBackButton:(id)sender;
-(IBAction)onChatButton:(id)sender;

@end

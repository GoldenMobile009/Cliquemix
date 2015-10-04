//
//  ChatViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/23/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "ChatEngine.h"
#import "ChatService.h"
#import <MBProgressHUD.h>
#import "ChatMessageTableViewCell.h"
#import "FlingGroupsViewController.h"
#import "ParserEngine.h"
#import "GroupPost.h"
#import "DraggableViewBackground.h"
#import "MyGroupsViewController.h"

@interface ChatViewController : UIViewController<QBActionStatusDelegate,QBChatDelegate,chatDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,mainDragViewDelegate,UIAlertViewDelegate>
{
    ChatEngine *myChat;
    ParserEngine *myParser;
    GroupPost *myGroupPost;
    
    IBOutlet UITextField *messageField;
    IBOutlet UIButton *sendButton;
    NSArray *chatUsers;
    IBOutlet UITableView *chatTableView;
    IBOutlet UILabel *groupNameLabel;
    IBOutlet UIView *editPopView;

    IBOutlet UIButton *removeButton;
    IBOutlet UIButton *muteButton;
    IBOutlet UIButton *blockButton;
    
    IBOutlet UIButton *groupButton;

    IBOutlet UIView *reasonView;
    IBOutlet UIView *reasonCustomView;
    IBOutlet UITextView *reasonTextView;
}

    
@property(nonatomic,strong)QBChatDialog *dialog;
@property(nonatomic,strong)QBChatRoom *chatRoom;
@property(nonatomic,strong)Groups *chatGroup;
@property(nonatomic,strong)Groups *myGroup;
@property(nonatomic,strong)NSMutableArray *messages;


-(IBAction)onBackButton:(id)sender;
-(IBAction)onSendMessageButton:(id)sender;
-(IBAction)onGroupButton:(id)sender;
-(IBAction)onCancelButton:(id)sender;

-(IBAction)onReportButton:(id)sender;
-(IBAction)onBlockButton:(id)sender;
-(IBAction)onMuteButton:(id)sender;

-(IBAction)onDoneReasonButton:(id)sender;
-(IBAction)onCancelReasonButton:(id)sender;

-(instancetype)initWithChatGroup:(Groups *)chat_grp myGroup:(Groups *)my_grp;

@end

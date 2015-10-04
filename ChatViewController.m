//
//  ChatViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/23/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
-(instancetype)initWithChatGroup:(Groups *)chat_grp myGroup:(Groups *)my_grp{
    self = [super init];
    if (self) {
        self.chatGroup = chat_grp;
        self.myGroup = my_grp;
    }
    return self;
}
-(void)relogin{
    [self joinDialog];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:) name:kNotificationDidReceiveNewMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)name:kNotificationDidReceiveNewMessageFromRoom object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relogin) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];


    myChat = [ChatEngine sharedInstance];
    myGroupPost = [GroupPost sharedInstance];
    myParser = [ParserEngine sharedInstance];
    
    groupButton.hidden = (self.chatGroup == self.myGroup);

    [myChat usersFromChatGroup:self.chatGroup myGroup:self.myGroup];
    self.messages = [[NSMutableArray alloc]init];
    groupNameLabel.text = self.chatGroup.groupName;
    
    [self joinDialog];
    
    if ([self.chatGroup.mute boolValue]) {
        [muteButton setTitle:@"UnMute" forState:UIControlStateNormal];
    }
    else{
        [muteButton setTitle:@"Mute" forState:UIControlStateNormal];
    }
}
-(void)joinDialog{
    if (![[QBChat instance] isLoggedIn]){
        [MBProgressHUD showHUDAddedTo:chatTableView animated:YES];
        [myChat loginToChat];
        myChat.delegate = self;
    }
    else{
        [QBChat dialogsWithExtendedRequest:nil delegate:self];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.chatRoom leaveRoom];
}
-(void)onGroupButton:(id)sender{
    [messageField resignFirstResponder];
    NSArray *groups = [[NSArray alloc]initWithObjects: self.chatGroup, nil];
    
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:CGRectMake(10, 80, 300, 320) groups:groups currentGroup:self.chatGroup viewController:self fromChat:YES];
    draggableBackground.delegate = self;
    draggableBackground.backgroundColor = [UIColor clearColor];
    [editPopView addSubview:draggableBackground];
    
    removeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    removeButton.layer.borderWidth = 1.0;
    blockButton.layer.borderColor = [UIColor whiteColor].CGColor;
    blockButton.layer.borderWidth = 1.0;
    muteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    muteButton.layer.borderWidth = 1.0;
    editPopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    [self.view addSubview:editPopView];
}
-(void)loggedInToChat{
    [QBChat dialogsWithExtendedRequest:nil delegate:self];
    [MBProgressHUD hideHUDForView:chatTableView animated:YES];
}
-(void)createDialog{
    if ([[QBChat instance] isLoggedIn]){
        QBChatDialog *chatDialog = [QBChatDialog new];
        if ([self.chatGroup.groupName isEqualToString:self.myGroup.groupName]) {
            chatDialog.name = [NSString stringWithFormat:@"%@ Chat",self.myGroup.groupName];
        }
        else{
            chatDialog.name = [NSString stringWithFormat:@"Chat between %@ and %@",self.chatGroup.groupName,self.myGroup.groupName];
        }
        
        chatDialog.occupantIDs = myChat.chatIDs;
        chatDialog.type = QBChatDialogTypeGroup;
        NSLog(@"Dialogs ; %@",chatDialog);
        
        [QBChat createDialog:chatDialog delegate:self];
    }
}
#pragma mark -
#pragma mark QBActionStatusDelegate
- (void)completedWithResult:(QBResult *)result{
    [MBProgressHUD hideAllHUDsForView:chatTableView animated:YES];
    if (result.success && [result isKindOfClass:[QBChatDialogResult class]]) {
        QBChatDialogResult *res = (QBChatDialogResult *)result;
        [self joinRoomWithDialog:res.dialog];
    }
    
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class]){
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        
        if(messages.count > 0){
            [self.messages addObjectsFromArray:[messages mutableCopy]];
            [chatTableView reloadData];
            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        NSArray *dialogs = pagedResult.dialogs;
        NSArray *sortedChatIDs = [myChat.chatIDs sortedArrayUsingSelector:@selector(compare:)];
        
        BOOL foundRoom = NO;
        for (QBChatDialog *tmpDialog in dialogs) {
            NSArray *sortedDialogIDs = [tmpDialog.occupantIDs sortedArrayUsingSelector:@selector(compare:)];
            
            if ([sortedChatIDs isEqualToArray:sortedDialogIDs]) {
                foundRoom = YES;
                [self joinRoomWithDialog:tmpDialog];
            }
        }
        
        if (!foundRoom) {
            NSLog(@"NO ROOM FOUND");
            
            [self createDialog];
        }
    }
}
-(void)joinRoomWithDialog:(QBChatDialog *)currentDialog{
    self.dialog = currentDialog;
    QBChatRoom *tmpRoom = currentDialog.chatRoom;
    self.chatRoom = tmpRoom;
    [MBProgressHUD showHUDAddedTo:chatTableView animated:YES];
    
    [[QBChat instance] setDelegate:self];
    [[QBChat instance] createOrJoinRoomWithName:self.chatRoom.name membersOnly:NO persistent:YES];
}
- (void)chatRoomDidEnter:(QBChatRoom *)room{
    self.chatRoom = room;
    [QBChat messagesWithDialogID:self.dialog.ID extendedRequest:nil delegate:self];
    [MBProgressHUD hideAllHUDsForView:chatTableView animated:YES];
}
- (void)chatRoomDidLeave:(NSString *)roomName{
    self.chatRoom = nil;
}

-(void)sendMessage:(NSString *)text{
    if (text.length != 0) {
        QBChatMessage *message = [[QBChatMessage alloc] init];
        message.text = text;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"save_to_history"] = @YES;
        [message setCustomParameters:params];
    
        [[ChatService instance] sendMessage:message toRoom:self.chatRoom];
        [myGroupPost sendMessage:message.text from:self.myGroup.gid users:[self chatUsers] groupID:self.chatGroup.gid callWithSuccess:nil errorCallback:nil];

        // Reload table
        [chatTableView reloadData];
        if(self.messages.count > 0){
            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
        // Clean text field
        [messageField setText:nil];
    }
}

#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    QBChatMessage *message = notification.userInfo[kMessage];
    
    if(message.senderID != self.dialog.recipientID){
        return;
    }
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [chatTableView reloadData];
    if(self.messages.count > 0){
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{

    QBChatMessage *message = notification.userInfo[kMessage];
    NSString *roomJID = notification.userInfo[kRoomJID];
    
    if(![self.chatRoom.JID isEqualToString:roomJID]){
        return;
    }
    // save message
    [self.messages addObject:message];
    

    // Reload table
    [chatTableView reloadData];
    if(self.messages.count > 0){
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    if(cell == nil){
        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
    }
    
    QBChatAbstractMessage *message = self.messages[indexPath.row];
    
    [cell configureCellWithMessage:message];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}
#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        messageField.transform = CGAffineTransformMakeTranslation(0, -250);
        sendButton.transform = CGAffineTransformMakeTranslation(0, -250);
        chatTableView.frame = CGRectMake(chatTableView.frame.origin.x,
                                         chatTableView.frame.origin.y,
                                         chatTableView.frame.size.width,
                                         chatTableView.frame.size.height-252);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        messageField.transform = CGAffineTransformIdentity;
        sendButton.transform = CGAffineTransformIdentity;
        chatTableView.frame = CGRectMake(chatTableView.frame.origin.x,
                                         chatTableView.frame.origin.y,
                                         chatTableView.frame.size.width,
                                         chatTableView.frame.size.height+252);
    }];
}

-(void)onSendMessageButton:(id)sender{
    [self sendMessage:messageField.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onCancelButton:(id)sender{
    [editPopView removeFromSuperview];
}
-(NSArray *)chatUsers{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    for (NSString *userID in self.chatGroup.users) {
        [array addObject:userID];
    }
    
    for (NSString *userID in self.myGroup.users) {
        if (![myParser.currentUser.fbId isEqualToString:userID]) {
            [array addObject:userID];
        }
    }
    
    return array;
}
#pragma mark Group Actions
-(void)refreshGroups{
    [myParser getGroupsWithSuccessBlock:^{
        [MBProgressHUD hideHUDForView:chatTableView animated:YES];
        [editPopView removeFromSuperview];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[DiscoveryViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        DiscoveryViewController *discoveryView = [[DiscoveryViewController alloc]init];
        [self.navigationController pushViewController:discoveryView animated:YES];
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:chatTableView animated:YES];
    }];
}
-(void)reportGroup{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [myGroupPost blockMatch:self.chatGroup.gid withUserId:myParser.currentUser.fbId reason:@"Spam" callWithSuccess:^{
        [reasonView removeFromSuperview];
        [self refreshGroups];
    } errorCallback:^(NSError *error) {
        [MBProgressHUD hideHUDForView:chatTableView animated:YES];
    }];
}
-(void)blockGroup{
    [MBProgressHUD showHUDAddedTo:chatTableView animated:YES];
    [myGroupPost blockMatch:self.chatGroup.gid withUserId:myParser.currentUser.fbId reason:nil callWithSuccess:^{
        [self refreshGroups];
    } errorCallback:^(NSError *error) {
        [MBProgressHUD hideHUDForView:chatTableView animated:YES];
    }];
}
-(void)muteGroup{
    [MBProgressHUD showHUDAddedTo:chatTableView animated:YES];
        [myGroupPost muteGroup:self.chatGroup.gid withUserId:myParser.currentUser.fbId callWithSuccess:^{
            [myParser getGroupsWithSuccessBlock:^{
                for (Groups *grp in myParser.groups) {
                    if ([grp.gid isEqualToString:self.chatGroup.gid]) {
                        self.chatGroup = grp;
                        break;
                    }
                }

                if ([self.chatGroup.mute boolValue]){
                    [muteButton setTitle:@"UnMute" forState:UIControlStateNormal];
                }
                else{
                    [muteButton setTitle:@"Mute" forState:UIControlStateNormal];
                }
                [MBProgressHUD hideHUDForView:chatTableView animated:YES];
            } errorBlock:^(NSError *error) {
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:chatTableView animated:YES];
            }];
            [editPopView removeFromSuperview];
        } errorCallback:^(NSError *error) {
            [MBProgressHUD hideHUDForView:chatTableView animated:YES];
        }];
}
-(void)onReportButton:(id)sender{
    [editPopView removeFromSuperview];
    [reasonView becomeFirstResponder];
    reasonTextView.layer.borderWidth = 1.0;
    reasonTextView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:reasonView];
}
-(void)onBlockButton:(id)sender{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to remove this match?" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    av.tag = 1;
    [av show];
}
-(void)onMuteButton:(id)sender{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"By muting you won't receive any push notifications for this group" message:@"Are you sure you want to do this?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    av.tag = 2;
    [av show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [self blockGroup];
    }
    else if (alertView.tag == 2 && buttonIndex == 1) {
        [self muteGroup];
    }
}
-(void)onDoneReasonButton:(id)sender{
    [self reportGroup];
}
-(void)onCancelReasonButton:(id)sender{
    [reasonView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

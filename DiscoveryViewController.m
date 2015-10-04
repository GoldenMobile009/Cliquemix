//
//  DiscoveryViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "DiscoveryViewController.h"

@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController
@synthesize group;

-(id)initWithGroup:(Groups *)currentGroup{
    self = [super init];
    if (self) {
        group = currentGroup;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)notification:(NSNotification *)notif{
    if ([notif.name isEqualToString:@"RefreshGroups"]) {
        [myParser getGroupsWithSuccessBlock:^{
            [self refreshGroups];
            [discoveryTableView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"RefreshGroups" object:nil];
    
    myParser = [ParserEngine sharedInstance];
    myChat = [ChatEngine sharedInstance];
    
    if ([[myParser sortedGroups] count] == 0) {
        discoveryTableView.hidden = YES;
    }
    else{
        groups = [myParser sortedGroups];
        titleLabel.text = group.groupName;
        [self refreshGroups];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshGroups) object:self];
}
-(void)onChatButton:(id)sender{
    ChatViewController *chatView = [[ChatViewController alloc]initWithChatGroup:group myGroup:group];
    [self.navigationController pushViewController:chatView animated:YES];
}
-(void)checkForUnreadMessages{
    if (![[QBChat instance] isLoggedIn]){
        [myChat loginToChat];
        myChat.delegate = self;
    }
    else{
        [QBChat dialogsWithExtendedRequest:nil delegate:self];
    }
}
-(void)loggedInToChat{
    [QBChat dialogsWithExtendedRequest:nil delegate:self];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark -
#pragma mark QBActionStatusDelegate
- (void)completedWithResult:(QBResult *)result{
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        NSArray *dialogs = pagedResult.dialogs;
        for (int i = 0; i<[groups count]; i++) {
            Groups *grp = [groups objectAtIndex:i];
            if ([[colorsDict valueForKey:@"liked"]containsObject:grp.gid]) {
                [myChat usersFromChatGroup:grp myGroup:group];
                NSArray *sortedChatIDs = [myChat.chatIDs sortedArrayUsingSelector:@selector(compare:)];
                for (QBChatDialog *tmpDialog in dialogs) {
                    NSArray *sortedDialogs =  [tmpDialog.occupantIDs sortedArrayUsingSelector:@selector(compare:)];
                    if ([sortedChatIDs isEqualToArray:sortedDialogs]) {
                        if (tmpDialog.unreadMessagesCount != 0) {
                            [colorsArray replaceObjectAtIndex:i withObject:BLUE_COLOR];
                        }
                    }
                }
            }
        }
        [discoveryTableView reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)refreshGroups{
    [myParser getGroupActionsWithSuccessBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self colorsForGroups];
        [self checkForUnreadMessages];
        [self performSelector:@selector(refreshGroups) withObject:self afterDelay:60.0];
    } errorBlock:^(NSError *error) {
        [self performSelector:@selector(refreshGroups) withObject:self afterDelay:60.0];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [groups count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Groups *grp = [groups objectAtIndex:indexPath.row];
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoveryCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DiscoveryCell" owner:self options:nil];
        cell = [nib firstObject];
    }
    [cell updateCellWithGroups:grp color:[colorsArray objectAtIndex:indexPath.row]];
    cell.muteImageView.hidden = ![grp.mute boolValue];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array = groups.mutableCopy;
    Groups *tmpGroups = [groups objectAtIndex:indexPath.row];
    Groups *firstObject = [groups firstObject];
    
    [array replaceObjectAtIndex:0 withObject:tmpGroups];
    [array replaceObjectAtIndex:indexPath.row withObject:firstObject];
    
    if ([[colorsArray objectAtIndex:indexPath.row] isEqual:GREEN_COLOR] || [[colorsArray objectAtIndex:indexPath.row] isEqual:BLUE_COLOR]) {        
        ChatViewController *chatView = [[ChatViewController alloc]initWithChatGroup:tmpGroups myGroup:group];
        [self.navigationController pushViewController:chatView animated:YES];
    }else{
        FlingGroupsViewController *flingView = [[FlingGroupsViewController alloc]initWithGroups:[self removeGreenGroupsFromArray:array] currentGroup:group fromChat:NO];
        [self.navigationController pushViewController:flingView animated:YES];
    }
}
-(NSArray *)removeGreenGroupsFromArray:(NSArray *)array{
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    for (Groups *grp in array) {
        if (![[colorsDict valueForKey:@"liked"]containsObject:grp.gid]) {
            [tmpArray addObject:grp];
        }
    }
    return tmpArray;
}
-(void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)colorsForGroups{
    colorsDict = [myParser interactionForGroup:group.gid];
    if ([colorsDict count] != 0) {
        colorsArray = [[NSMutableArray alloc]init];
        for (Groups *grp in groups) {
            UIColor *color = [UIColor clearColor];
            if ([[colorsDict valueForKey:@"liked"]containsObject:grp.gid]) {
                color = GREEN_COLOR;
            }
            if ([[colorsDict valueForKey:@"disliked"]containsObject:grp.gid]) {
                color = RED_COLOR;
            }
            [colorsArray addObject:color];
        }
    }
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

//
//  MyGroupsViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "MyGroupsViewController.h"

@interface MyGroupsViewController ()

@end

@implementation MyGroupsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void) refreshNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"RefreshProfiles"]) {
        myParser = [ParserEngine sharedInstance];
        myGroup = [GroupPost sharedInstance];
        Profiles *profile = [myParser currentUser];
        [myChat authenticateWithFirstName:profile.firstName email:profile.email successBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
        if ([myParser.groupsForCurrentUser count] != 0) {
            groupsTableView.hidden = NO;
            [groupsTableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNotification:)
                                                 name:@"RefreshProfiles"
                                               object:nil];
    
    UITapGestureRecognizer *tapToCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCancelButton:)];
    tapToCancel.numberOfTapsRequired=1;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myChat = [ChatEngine sharedInstance];
    slide = NO;
    
    groupsTableView.hidden = ([myParser.groupsForCurrentUser count] == 0);
    
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self refreshGroups];
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myParser.groupsForCurrentUser count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Groups *groups = [myParser.groupsForCurrentUser objectAtIndex:indexPath.row];
    GroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    
    [cell updateCellWithGroup:groups slide:slide];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Groups *groups = [myParser.groupsForCurrentUser objectAtIndex:indexPath.row];
    DiscoveryViewController *discoveryView = [[DiscoveryViewController alloc]initWithGroup:groups];
    [self.navigationController pushViewController:discoveryView animated:YES];
}

-(void)onMenuButton:(id)sender{
    [self.mm_drawerController setMaximumLeftDrawerWidth:260];
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)onAddGroupButton:(id)sender{
    CreateGroupViewController *createGroup = [[CreateGroupViewController alloc]init];
    [self.navigationController pushViewController:createGroup animated:YES];
}
-(void)removeGroup:(NSString *)gid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [myGroup removeGroup:gid withUserId:myParser.currentUser.fbId callWithSuccess:^{
        [self refreshGroups];
    } errorCallback:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)muteGroup:(NSString *)gid{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [myGroup muteGroup:gid withUserId:myParser.currentUser.fbId callWithSuccess:^{
        [self refreshGroups];
    } errorCallback:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)refreshGroups{
    [myParser getGroupsWithSuccessBlock:^{
        if ([myParser.groupsForCurrentUser count] == 0) {
            groupsTableView.hidden = YES;
        }
        else{
            [groupsTableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}
-(void)onEditButton:(id)sender{
    slide = !slide;
    [groupsTableView reloadData];
}
-(void)openSlide:(BOOL)open{
    slide = open;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

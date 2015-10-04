//
//  CreateGroupViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/6/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController
@synthesize members;
@synthesize userIDs;

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myParser = [ParserEngine sharedInstance];
    group = [GroupPost sharedInstance];
    profile = [myParser currentUser];
    
    UINib *nib = [UINib nibWithNibName:@"AddMembersCell" bundle:nil];
    [membersCollectionView registerNib:nib forCellWithReuseIdentifier:@"membersCell"];
    
    if (!members) {
        members = [[NSMutableArray alloc]init];
        userIDs = [[NSMutableArray alloc]init];
        if ([myParser currentUser]) {
            [members addObject:[myParser currentUser]];
            [userIDs addObject:[[myParser currentUser] fbId]];
        }
    }
    
    self.friendPicker = [[FBFriendPickerViewController alloc] init];
    self.friendPicker.delegate = self;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([members count] <= 5) {
        return [members count]+1;
    }
    else{
        return [members count];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AddMembersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"membersCell" forIndexPath:indexPath];
    
    if (indexPath.section == [members count]) {
        cell.memberImage.image = [UIImage imageNamed:@"add"];
    }
    else{
        Profiles *profiles = [members objectAtIndex:indexPath.section];
        [cell.memberImage sd_setImageWithURL:[NSURL URLWithString:profiles.profilePic]];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.friendPicker loadData];
    [self presentViewController:self.friendPicker animated:YES completion:nil];
}
-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker{
    friendsPickerArray = friendPicker.selection;
}
-(void)facebookViewControllerDoneWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [self reloadCollectionView];
    }];
}
-(void)reloadCollectionView{
    if ([friendsPickerArray count] > 0) {
        for (int i = 0; i<[friendsPickerArray count]; i++) {
            if ([members count] <= 5) {
                Profiles *fbProfiles = [myParser getProfileWithID:[[friendsPickerArray objectAtIndex:i] valueForKey:@"id"]];
                if (fbProfiles) {
                    if (![members containsObject:fbProfiles] && [fbProfiles.gender isEqualToString:profile.gender]) {                        
                        [members addObject:fbProfiles];
                        [userIDs addObject:fbProfiles.fbId];
                    }
                }
                else{
//                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Your friend cannot be found in the app probably his account got erased." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    av.tag = 1;
//                    [av show];
                }
            }
        }
        [membersCollectionView reloadData];
    }
}
-(void)facebookViewControllerCancelWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)onBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onCreateButton:(id)sender{
    if (![self groupExists:userIDs]) {
        if ([userIDs count] == 1) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You can't create a group by yourself." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
        }
        else{
            [self.view addSubview:groupNameView];
        }
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Group like this already exists." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }

}
-(void)onTextButton:(id)sender{
    [self sendSMSWithFirstName:profile.firstName gender:profile.gender];
}
-(void)onMailButton:(id)sender{
    [self sendMailWithFirstName:profile.firstName gender:profile.gender];
}
-(void)onDoneButton:(id)sender{
    [groupNameView removeFromSuperview];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self createGroup];
}
-(void)createGroup{
    [group createGroupWithName:groupNameField.text latitude:profile.latitude longitude:profile.longitude location:profile.location description:[self firstNamesForDescription] users:[userIDs componentsJoinedByString:@","] gender:profile.gender callWithSuccess:^{
        [myParser getGroupsWithSuccessBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshProfiles" object:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"You have successfully created a group." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            av.tag = 1;
            [av show];
        } errorBlock:nil];
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Something went wrong." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}
-(void)onCancelButton:(id)sender{
    [groupNameView removeFromSuperview];
}
-(BOOL)groupExists:(NSArray *)users{
    NSArray *sortedUsers = [users sortedArrayUsingSelector:@selector(compare:)];
    for (Groups *grp in myParser.groups) {
        NSArray *sortedGroupUsers = [grp.users sortedArrayUsingSelector:@selector(compare:)];
        if ([sortedUsers isEqualToArray:sortedGroupUsers]) {
            return YES;
        }
    }
    return NO;
}
-(NSString *)firstNamesForDescription{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Profiles *prof in members) {
        [array addObject:prof.firstName];
    }
    return [array componentsJoinedByString:@", "];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)sendSMSWithFirstName:(NSString *)first_name gender:(NSString *)gender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.body = [NSString stringWithFormat:@"%@ has invited you to join %@ group on Cliquemix. Download the app: https://itunes.apple.com/us/app/cliquemix/id985434929?ls=1&mt=8",first_name,[self defineGender:gender]];
    controller.messageComposeDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent){
        NSLog(@"Message sent");
    }
    else
    {
        NSLog(@"Message failed");
    }
}

- (void)sendMailWithFirstName:(NSString *)first_name gender:(NSString *)gender{
    if ([MFMailComposeViewController canSendMail]) {
        self.mailComposer = [[MFMailComposeViewController alloc] init];
        [self.mailComposer setMailComposeDelegate:self];
        [self.mailComposer setSubject:@"Join me!"];
        [self.mailComposer setMessageBody:[NSString stringWithFormat:@"%@ has invited you to join %@ group on Cliquemix. Download the app: https://itunes.apple.com/us/app/cliquemix/id985434929?ls=1&mt=8",first_name,[self defineGender:gender]] isHTML:NO];
        [self presentViewController:self.mailComposer animated:YES completion:nil];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please configure your mail." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (!error) {
        self.mailComposer = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Something went wrong, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        
    }
    //Add an alert in case of failure
}
-(NSString *)defineGender:(NSString *)gender{
    if ([gender isEqualToString:@"male"]) {
        return @"his";
    }
    else{
        return @"her";
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

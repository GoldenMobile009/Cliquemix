//
//  CreateGroupViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/6/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD.h>
#import "ParserEngine.h"
#import <UIImageView+WebCache.h>
#import "AddMembersCell.h"
#import "MembersLayout.h"
#import "GroupPost.h"

@interface CreateGroupViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,FBFriendPickerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    ParserEngine *myParser;
    GroupPost *group;
    Profiles *profile;

    IBOutlet UICollectionView *membersCollectionView;
    
    NSArray *friendsPickerArray;
    IBOutlet UIView *groupNameView;
    IBOutlet UITextField *groupNameField;
}

@property (nonatomic, strong) MFMailComposeViewController *mailComposer;
@property (nonatomic, strong)FBFriendPickerViewController *friendPicker;
@property (nonatomic, strong)NSMutableArray *userIDs;
@property (nonatomic, strong)NSMutableArray *members;

-(IBAction)onTextButton:(id)sender;
-(IBAction)onMailButton:(id)sender;
-(IBAction)onCreateButton:(id)sender;
-(IBAction)onBackButton:(id)sender;
-(IBAction)onCancelButton:(id)sender;
-(IBAction)onDoneButton:(id)sender;

@end

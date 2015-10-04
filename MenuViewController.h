//
//  MenuViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserEngine.h"
#import "User.h"
#import "Profiles.h"
#import "FBImagePickerViewController.h"
#import <UIButton+WebCache.h>
#import "ImagesView.h"

@interface MenuViewController : UIViewController
<imagePickerDelegate,UITextViewDelegate>
{
    ParserEngine *myParser;
    IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *profilePicButton;
    IBOutlet UIButton *removeProfilePicButton;
    IBOutlet UIButton *pic1;
    IBOutlet UIButton *pic2;
    IBOutlet UIButton *pic3;
    IBOutlet UIButton *pic4;
    IBOutlet UIButton *pic5;
    IBOutlet UITextView *description;
    IBOutlet UILabel *genderBackgroundLabel;
    IBOutlet UILabel *genderLabel;
    IBOutlet UILabel *descLabel;
    IBOutlet UIScrollView *menuScrollView;

    User *myUser;
    Profiles *profile;
    
    
    NSMutableArray *buttons;
    NSMutableArray *tmpArray;
}
@property(nonatomic,strong)UIButton *selectedButton;
@property(nonatomic,strong)NSMutableArray *uploadImages;
@property(nonatomic,strong)ImagesView *imagesView;

-(void)profileInfo;
-(void)interface;

-(IBAction)onPicButtons:(id)sender;
-(IBAction)onSaveChanges:(id)sender;
-(IBAction)onLogoutButton:(id)sender;
-(IBAction)onProfilePicButton:(id)sender;
-(IBAction)onRemoveProfileButton:(id)sender;

@end

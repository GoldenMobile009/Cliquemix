//
//  ProfileViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBImagePickerViewController.h"
#import "User.h"
#import "Profiles.h"
#import "ParserEngine.h"
#import <UIImageView+WebCache.h>
#import "AgreementViewController.h"

@interface ProfileViewController : UIViewController
<imagePickerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIImageView *profilePic;
    IBOutlet UIButton *pic1;
    IBOutlet UIButton *pic2;
    IBOutlet UIButton *pic3;
    IBOutlet UIButton *pic4;
    IBOutlet UIButton *pic5;
    IBOutlet UITextView *description;
    IBOutlet UITextField *emailField;
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *genderBackgroundLabel;
    IBOutlet UILabel *genderLabel;
    IBOutlet UILabel *descLabel;
    IBOutlet UIScrollView *profileScrollView;
    
    User *myUser;
    Profiles *profile;
    ParserEngine *myParser;

    NSMutableArray *buttons;
    NSMutableArray *tmpArray;
    
    IBOutlet UIView *genderPickerView;
    IBOutlet UIButton *genderPickerButton;
    IBOutlet UIButton *checkButton;
    IBOutlet UIButton *agreementButton;
    IBOutlet UILabel *userAgreementLabel;
}

@property(nonatomic,strong)UIButton *selectedButton;
@property(nonatomic,strong)NSMutableArray *uploadImages;

-(void)interface;

-(IBAction)onPicButtons:(id)sender;
-(IBAction)onDoneButton:(id)sender;
-(IBAction)onMaleButton:(id)sender;
-(IBAction)onFemaleButton:(id)sender;
-(IBAction)onGenderButton:(id)sender;
-(IBAction)onCheckBoxButton:(id)sender;
-(IBAction)onAgreementButton:(id)sender;

@end

//
//  ProfileViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
//#import "Facebook.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize uploadImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interface];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myParser = [ParserEngine sharedInstance];
    myUser = [User sharedInstance];
    [self collectFacebookInfo];
    
    if (isiPhone4s) {
        profileScrollView.contentSize = CGSizeMake(profileScrollView.frame.size.width, profileScrollView.frame.size.height + 150);
    }
    else{
        profileScrollView.contentSize = CGSizeMake(profileScrollView.frame.size.width, profileScrollView.frame.size.height + 60);
    }
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    userAgreementLabel.attributedText = [[NSAttributedString alloc] initWithString:userAgreementLabel.text
                                                                        attributes:underlineAttribute];
    
}
-(void)collectFacebookInfo{
    if (!uploadImages) {
        uploadImages = [[NSMutableArray alloc]initWithObjects:[myParser.userInfo valueForKey:@"profilePic"],@"",@"",@"",@"",@"", nil];
    }
//    if ([[myParser.userInfo valueForKey:@"gender"] length] != 0 ) {
//        genderLabel.text = [myParser.userInfo valueForKey:@"gender"];
        genderPickerButton.hidden = YES;
//    }
//    else{
//        genderPickerButton.hidden = NO;
//    }
    if ([[myParser.userInfo valueForKey:@"email"] length]!=0) {
        emailField.text = [myParser.userInfo valueForKey:@"email"];
        emailField.userInteractionEnabled = NO;
    }
    
    [profilePic sd_setImageWithURL:[NSURL URLWithString:[myParser.userInfo valueForKey:@"profilePic"]]];
}
-(void)interface{
    buttons = [[NSMutableArray alloc]initWithObjects:pic1,pic2,pic3,pic4,pic5, nil];
    profilePic.layer.cornerRadius = 6;
    profilePic.layer.masksToBounds = YES;
    description.layer.borderColor = [UIColor blackColor].CGColor;
    description.layer.borderWidth = 2.0;
//    genderBackgroundLabel.layer.borderColor = [UIColor blackColor].CGColor;
//    genderBackgroundLabel.layer.borderWidth = 2.0;
    descLabel.layer.borderColor = [UIColor blackColor].CGColor;
    descLabel.layer.borderWidth = 2.0;
    emailLabel.layer.borderColor = [UIColor blackColor].CGColor;
    emailLabel.layer.borderWidth = 2.0;
    
    for (UIButton *button in buttons) {
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 2.0;
    }
}
-(void)onPicButtons:(id)sender{
    self.selectedButton = (UIButton *)sender;
    FBImagePickerViewController *imagePickerView = [[FBImagePickerViewController alloc]init];
    imagePickerView.delegate = self;
    [self presentViewController:imagePickerView animated:YES completion:nil];
}
-(void)imagePickerWithImage:(NSString *)image isButton:(BOOL)isBtn{
    self.selectedButton.layer.borderWidth = 0.0;
    self.selectedButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.selectedButton.layer.masksToBounds = YES;
    
    for (UIView *view in [self.selectedButton subviews]) {
        [view removeFromSuperview];
    }
    
    [self.selectedButton setTitle:@"" forState:UIControlStateNormal];
    [self.selectedButton setImage:[UIImage new] forState:UIControlStateNormal];
    
    UIImageView *selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.selectedButton.frame.size.width, self.selectedButton.frame.size.height)];
    selectedImageView.layer.cornerRadius = 6;
    selectedImageView.layer.masksToBounds = YES;
    selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    [selectedImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    [self.selectedButton addSubview:selectedImageView];
    [uploadImages replaceObjectAtIndex:self.selectedButton.tag withObject:image];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    descLabel.text = @"";
    [UIView animateWithDuration:.25 animations:^{
        [self.view setFrame:CGRectMake(0, -80, 320, self.view.frame.size.height)];
    }];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        descLabel.text = @"    description";
    }
    [UIView animateWithDuration:.25 animations:^{
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)onDoneButton:(id)sender{
    NSString *alertText = [self alertText];
    if (alertText.length == 0) {
        [self createProfile];
    }
    else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning" message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
}
-(NSString *)alertText{
    if (checkButton.selected) {
//        if (genderLabel.text.length == 0) {
//            return @"Please click on the gender field and pick a gender.";
//        }
//        else
            if (description.text.length > 300){
            return @"Description cant be over 300 characters!";
        }
    }
    else{
        return @"You must check the agreements in order to continue";
    }
    return @"";
}
-(void)createProfile{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *facebook_token = [[User sharedInstance] pushToken];
    [myUser createProfileWithFBID:[myParser.userInfo valueForKey:@"fbID"] images:uploadImages firstName:[myParser.userInfo valueForKey:@"firstName"] age:[myParser.userInfo valueForKey:@"age"] description:description.text gender:genderLabel.text email:emailField.text callWithSuccess:^{
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"createdProfile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [myParser getProfiles:nil WithSuccessBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate changeRootView];
        } errorBlock:nil];
    } errorCallback:^(NSError *error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning." message:@"Something went wrong, please try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
        return;
    }];
}
-(void)onMaleButton:(id)sender{
    genderLabel.text = @"male";
    [genderPickerView removeFromSuperview];
}
-(void)onFemaleButton:(id)sender{
    genderLabel.text = @"female";
    [genderPickerView removeFromSuperview];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)onCheckBoxButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
    }
    else{
        [btn setImage:nil forState:UIControlStateNormal];
    }
}
-(void)onAgreementButton:(id)sender{
    AgreementViewController *agreementView = [[AgreementViewController alloc]init];
    [self.navigationController pushViewController:agreementView animated:YES];
}
-(void)onGenderButton:(id)sender{
//    [self.view addSubview:genderPickerView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  MenuViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize uploadImages;

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myUser = [User sharedInstance];
    myParser = [ParserEngine sharedInstance];
    [self interface];
    if ([myParser currentUser]) {
        profile = [myParser currentUser];
        [self profileInfo];
    }
}
-(void)interface{
    if (isiPhone4s) {
        [menuScrollView setContentSize:CGSizeMake(menuScrollView.frame.size.width, menuScrollView.frame.size.height + 88)];
    }
    
    buttons = [[NSMutableArray alloc]initWithObjects:pic1,pic2,pic3,pic4,pic5, nil];
    profilePic.layer.cornerRadius = 6;
    profilePic.layer.masksToBounds = YES;
    description.layer.borderColor = [UIColor blackColor].CGColor;
    description.layer.borderWidth = 2.0;
    genderBackgroundLabel.layer.borderColor = [UIColor blackColor].CGColor;
    genderBackgroundLabel.layer.borderWidth = 2.0;
    descLabel.layer.borderColor = [UIColor blackColor].CGColor;
    descLabel.layer.borderWidth = 2.0;
}
-(void)onPicButtons:(id)sender{
    self.selectedButton = (UIButton *)sender;
    FBImagePickerViewController *imagePickerView = [[FBImagePickerViewController alloc]initWithButton:YES];
    imagePickerView.delegate = self;
    [self presentViewController:imagePickerView animated:YES completion:nil];
}
-(void)imagePickerWithImage:(NSString *)image isButton:(BOOL)isBtn{
    if (isBtn) {
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
    else{
        [profilePic sd_setImageWithURL:[NSURL URLWithString:image]];
        profilePic.layer.borderWidth = 0.0;
        profilePic.contentMode = UIViewContentModeScaleAspectFill;
        [uploadImages replaceObjectAtIndex:0 withObject:image];
    }
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

-(void)onSaveChanges:(id)sender{
    [self editAccount];
}
-(void)profileInfo{
    if (!uploadImages){
        uploadImages = [[NSMutableArray alloc]initWithObjects:profile.profilePic,profile.pic1,profile.pic2,profile.pic3,profile.pic4,profile.pic5, nil];
        [profilePic sd_setImageWithURL:[NSURL URLWithString:profile.profilePic]];
    }
    
    if (profile.desc.length != 0) {
        descLabel.text = @"";
    }
    
    description.text = profile.desc;
    genderLabel.text = profile.gender;
    NSArray *images = [[NSArray alloc]initWithObjects:[uploadImages objectAtIndex:1],[uploadImages objectAtIndex:2],[uploadImages objectAtIndex:3],[uploadImages objectAtIndex:4],[uploadImages objectAtIndex:5], nil];
    
    if ([images count] > 0) {
        for (int i = 0; i<[buttons count]; i++) {
            UIButton *button = [buttons objectAtIndex:i];
            if ([[images objectAtIndex:i] length] != 0) {
                [button sd_setImageWithURL:[NSURL URLWithString:[images objectAtIndex:i]] forState:UIControlStateNormal];
                button.layer.borderWidth = 0.0;
                button.layer.cornerRadius = 6;
                button.layer.masksToBounds = YES;
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                button.layer.borderColor = [UIColor clearColor].CGColor;
                if (![button.subviews containsObject:[self addDeleteButtonWithTag:i]]) {
                    [button addSubview:[self addDeleteButtonWithTag:i]];
                }
            }
            else{
                [button sd_cancelImageLoadForState:UIControlStateNormal];
                [button sd_cancelImageLoadForState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:@"plus@2x"] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor blackColor].CGColor;
                button.layer.borderWidth = 2.0;
                for (UIView *view in button.subviews) {
                    if ([view isEqual:[self addDeleteButtonWithTag:button.tag]]) {
                        [view removeFromSuperview];
                    }
                }
            }
        }
    }
}
-(UIButton *)addDeleteButtonWithTag:(NSInteger)tag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_x_light"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(40, 0, 30, 30)];
    btn.tag = tag;
    [btn addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)onDeleteButton:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [btn setImage:nil forState:UIControlStateNormal];
    [uploadImages replaceObjectAtIndex:btn.tag+1 withObject:@""];
    UIButton *imageButton = [buttons objectAtIndex:btn.tag];
    imageButton.layer.borderColor = [UIColor blackColor].CGColor;
    imageButton.layer.borderWidth = 2.0;

    for (UIView *view in imageButton.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            [imageView setImage:nil];
            [imageView setImage:[UIImage imageNamed:@"plus@2x"]];
            [imageView setFrame:CGRectMake(15, 15, 40, 40)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    
    [imageButton setImage:[UIImage imageNamed:@"plus@2x"] forState:UIControlStateNormal];
    [imageButton sd_cancelImageLoadForState:UIControlStateNormal];

    [btn removeFromSuperview];
}

-(void)editAccount{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [myUser editProfileWithFBID:profile.fbId images:uploadImages description:description.text callWithSuccess:^{
        [myParser getProfiles:nil WithSuccessBlock:^{
            [self profileInfo];
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"You have sucessfully edited your account!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } errorBlock:nil];
    } errorCallback:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Warning." message:@"Something went wrong, please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }];
}
-(void)onProfilePicButton:(id)sender{
    FBImagePickerViewController *imagePickerView = [[FBImagePickerViewController alloc]initWithButton:NO];
    imagePickerView.delegate = self;
    [self presentViewController:imagePickerView animated:YES completion:nil];
}
-(void)onRemoveProfileButton:(id)sender{
    profilePic.layer.borderColor = [UIColor blackColor].CGColor;
    profilePic.layer.borderWidth = 2.0;
    [profilePic sd_setImageWithURL:[NSURL URLWithString:@""]];
    [profilePic setImage:[UIImage imageNamed:@"plus@2x"]];
    profilePic.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)onLogoutButton:(id)sender{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (FBSession.activeSession.isOpen)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [delegate backToLoginScreen];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

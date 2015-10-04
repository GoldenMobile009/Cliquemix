//
//  ImagesView.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 3/22/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profiles.h"
#import <UIButton+WebCache.h>
#import "FBImagePickerViewController.h"

@interface ImagesView : UIView
<imagePickerDelegate>
@property(nonatomic,strong) UIButton *profilePic;
@property(nonatomic,strong) UIButton *pic1;
@property(nonatomic,strong) UIButton *pic2;
@property(nonatomic,strong) UIButton *pic3;
@property(nonatomic,strong) UIButton *pic4;
@property(nonatomic,strong) UIButton *pic5;
@property(nonatomic,strong) Profiles *profile;
@property(nonatomic,strong) NSMutableArray *uploadImages;
@property(nonatomic,strong) NSMutableArray *buttons;
@property(nonatomic,strong) UIViewController *viewController;
@property(nonatomic,strong) UIButton *selectedButton;

-(instancetype)initWithFrame:(CGRect)frame profile:(Profiles *)prof viewController:(UIViewController *)vc;


@end

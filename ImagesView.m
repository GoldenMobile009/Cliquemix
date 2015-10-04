//
//  ImagesView.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 3/22/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ImagesView.h"

@implementation ImagesView
@synthesize profilePic;
@synthesize pic1;
@synthesize pic2;
@synthesize pic3;
@synthesize pic4;
@synthesize pic5;
@synthesize profile;
@synthesize uploadImages;
@synthesize buttons;

-(instancetype)initWithFrame:(CGRect)frame profile:(Profiles *)prof viewController:(UIViewController *)vc{
    self = [super initWithFrame:frame];
    if (self) {
        self.profile = prof;
        self.viewController = vc;

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self createButtons];
}

-(void)createButtons{
    profilePic = [UIButton buttonWithType:UIButtonTypeCustom];
    profilePic.frame = CGRectMake(0, 0, 150, 150);
    profilePic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    profilePic.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self addSubview:profilePic];
    
    pic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    pic1.frame = CGRectMake(160, 0, 70, 70);
//    pic1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    pic1.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self addSubview:pic1];

    pic2 = [UIButton buttonWithType:UIButtonTypeCustom];
    pic2.frame = CGRectMake(pic1.frame.origin.x, pic1.frame.origin.y+pic1.frame.size.height+10, 70, 70);
//    pic2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    pic2.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self addSubview:pic2];

    pic3 = [UIButton buttonWithType:UIButtonTypeCustom];
    pic3.frame = CGRectMake(pic2.frame.origin.x, pic2.frame.origin.y+pic2.frame.size.height+10, 70, 70);
//    pic3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    pic3.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self addSubview:pic3];

    pic4 = [UIButton buttonWithType:UIButtonTypeCustom];
    pic4.frame = CGRectMake(pic3.frame.origin.x - pic3.frame.size.width - 10, pic3.frame.origin.y, 70, 70);
//    pic4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    pic4.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    [self addSubview:pic4];

    pic5 = [UIButton buttonWithType:UIButtonTypeCustom];
    pic5.frame = CGRectMake(pic4.frame.origin.x - pic4.frame.size.width - 10, pic4.frame.origin.y, 70, 70);
//    pic5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//    pic5.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self addSubview:pic5];

    [self profileInfo];
}
-(void)profileInfo{
    if (!uploadImages) {
        uploadImages = [[NSMutableArray alloc]initWithObjects:profile.profilePic,profile.pic1,profile.pic2,profile.pic3,profile.pic4,profile.pic5, nil];
    }
    if (!buttons) {
    buttons = [[NSMutableArray alloc]initWithObjects:profilePic,pic1,pic2,pic3,pic4,pic5, nil];
    }
    
    if ([uploadImages count] > 0) {
        for (int i = 0; i<[uploadImages count]; i++) {
            UIButton *button = [buttons objectAtIndex:i];
            if ([[uploadImages objectAtIndex:i] length] != 0) {
                [button sd_setImageWithURL:[NSURL URLWithString:[uploadImages objectAtIndex:i]] forState:UIControlStateNormal];
                button.layer.cornerRadius = 6;
                button.layer.masksToBounds = YES;
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                button.layer.borderColor = [UIColor clearColor].CGColor;
                [button addTarget:self action:@selector(onPicButtons:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                if (![button.subviews containsObject:[self addDeleteButtonWithTag:i]]) {
                    [button addSubview:[self addDeleteButtonWithTag:i]];
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
    for (UIView *view in [self.selectedButton subviews]) {
        [view removeFromSuperview];
    }

    UIButton *btn = (UIButton *)sender;
    [btn setImage:nil forState:UIControlStateNormal];
    [uploadImages replaceObjectAtIndex:self.selectedButton.tag withObject:@""];
    UIButton *imageButton = [buttons objectAtIndex:btn.tag];
    [imageButton sd_cancelImageLoadForState:UIControlStateNormal];
    [imageButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    imageButton.layer.borderColor = [UIColor blackColor].CGColor;
    imageButton.layer.borderWidth = 2.0;
}
-(void)onPicButtons:(id)sender{
    self.selectedButton = (UIButton *)sender;
    FBImagePickerViewController *imagePickerView = [[FBImagePickerViewController alloc]init];
    imagePickerView.delegate = self;
    [self.viewController presentViewController:imagePickerView animated:YES completion:nil];
}
-(void)imagePickerWithImage:(NSString *)image{
    for (UIView *view in [self.selectedButton subviews]) {
        [view removeFromSuperview];
    }
    self.selectedButton.layer.borderWidth = 0.0;
    [self.selectedButton setImage:nil forState:UIControlStateNormal];

    UIImageView *selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.selectedButton.frame.size.width, self.selectedButton.frame.size.height)];
    selectedImageView.layer.cornerRadius = 6;
    selectedImageView.layer.masksToBounds = YES;
    selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    [selectedImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    [self.selectedButton addSubview:selectedImageView];
    [uploadImages replaceObjectAtIndex:self.selectedButton.tag withObject:image];
    [self.selectedButton addSubview:[self addDeleteButtonWithTag:self.selectedButton.tag]];

//    [self profileInfo];
}

@end

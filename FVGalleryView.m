//
//  FVGalleryView.m
//  Festyvent
//
//  Created by Dejan Atanasov on 12/17/14.
//  Copyright (c) 2014 CLARIFi Media. All rights reserved.
//

#import "FVGalleryView.h"

@implementation FVGalleryView

-(id)initWithFrame:(CGRect)frame profile:(Profiles *)profile{
    self = [super initWithFrame:frame];
    if (self) {
        self.profile = profile;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(260, 20, 60, 40);
    [backButton setImage:[UIImage imageNamed:@"icon_x_light"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [self loadImagesInScrollView];
    [self loadUserInfo];
}
-(void)loadImagesInScrollView{
    photosScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, 320, 400)];
    photosScrollView.pagingEnabled = YES;
    photosScrollView.delegate = self;
    [self addSubview:photosScrollView];
    
    int customX = 0;
    for (int i = 0; i<[[self userImages] count]; i++) {
        customX = i * photosScrollView.frame.size.width;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(customX, 0, photosScrollView.frame.size.width, photosScrollView.frame.size.height)];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[self userImages] objectAtIndex:i]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGSize imageContent = image.size;
            CGFloat imageWidth = imageContent.width;
            CGFloat imageHeight = imageContent.height;
            [self setFrameForImageView:imageView imageWidth:imageWidth imageHeight:imageHeight];
        }];

        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 4.0;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        [view addSubview:imageView];
        [photosScrollView addSubview:view];
    }
    
    [photosScrollView setContentSize:CGSizeMake(photosScrollView.frame.size.width *[[self userImages] count], photosScrollView.frame.size.height)];
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = [[self userImages] count];
    pageControl.currentPage = 0;
    
    [pageControl setFrame:CGRectMake(0,photosScrollView.frame.origin.y + photosScrollView.frame.size.height, 320, 37)];
    if (pageControl.numberOfPages == 1) {
        pageControl.hidden = YES;
    }
    else{
        pageControl.hidden = NO;
    }
    [self addSubview:pageControl];
}
-(void)loadUserInfo{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, 320, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 130, 30)];
    nameLabel.text = self.profile.firstName;
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    
    UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width - 80, nameLabel.frame.origin.y, 70, 30)];
    ageLabel.text = [NSString stringWithFormat:@"Age: %@",[NSString yearsBetweenBirthdate:self.profile.age]];
    ageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:ageLabel];
    
    [self addSubview:view];
}
-(void)setFrameForImageView:(UIImageView *)imageView imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight{
    if (imageWidth > imageHeight) {
        [imageView setFrame:CGRectMake(20, 80, 280, 240)];
        //   NSLog(@"Landscape Image");
    }
    else if (imageWidth < imageHeight){
        [imageView setFrame:CGRectMake(20, 0, 280,photosScrollView.frame.size.height)];
        //     NSLog(@"Portrait Image");
    }
    else{
        [imageView setFrame:CGRectMake(20, 80, 280, 240)];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = photosScrollView.frame.size.width;
    int page = floor((photosScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}
-(void)onBackButton:(id)sender{
    [self removeFromSuperview];
}
-(NSArray *)userImages{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0;i<[self.profile.images count] ; i++) {
        NSString *image = [self.profile.images objectAtIndex:i];
        if (image.length != 0 && i != 0) {
            [array addObject:image];
        }
    }
    return array;
}

@end

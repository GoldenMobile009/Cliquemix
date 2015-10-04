//
//  UserDetailsView.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/12/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "UserDetailsView.h"

@implementation UserDetailsView
@synthesize pageControl;

-(instancetype)initWithFrame:(CGRect)frame user:(Profiles *)user{
    self = [super initWithFrame:frame];
    if (self) {
        self.profile =  user;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.8];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 120, 280, 350)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    [self addSubview:view];
        
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, view.frame.size.width, 200)];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [view addSubview:scrollView];
    
    int customX = 0;
    for (int i = 0; i<[[self userImages]count]; i++) {
        customX = i * scrollView.frame.size.width;
        NSString *image = [[self userImages]objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + customX, 0, view.frame.size.width - 40, scrollView.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:image]];
        [scrollView addSubview:imageView];
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * [[self userImages] count], scrollView.frame.size.height)];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, scrollView.frame.origin.y + scrollView.frame.size.height + 10, 130, 30)];
    nameLabel.text = self.profile.firstName;
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];

    UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width - 80, nameLabel.frame.origin.y, 70, 30)];
    ageLabel.text = [NSString stringWithFormat:@"Age: %@",[NSString yearsBetweenBirthdate:self.profile.age]];
    ageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:ageLabel];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10,nameLabel.frame.origin.y + nameLabel.frame.size.height + 10 , view.frame.size.width - 20, 1.5)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.6];
    [view addSubview:line];

    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + nameLabel.frame.size.height + 20, view.frame.size.width, 20)];
    pageControl.numberOfPages = [[self userImages] count];
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0 green:157/255.0 blue:255/255.0 alpha:1.0];
    [view addSubview:pageControl];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(self.frame.size.width - 60, 20 , 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"icon_x_light"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, pageControl.frame.origin.y + pageControl.frame.size.height + 20)];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
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

-(void)onBackButton{
    [self removeFromSuperview];
}
@end

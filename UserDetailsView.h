//
//  UserDetailsView.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/12/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profiles.h"
#import <UIImageView+WebCache.h>
#import "NSString+Years.h"

@interface UserDetailsView : UIView <UIScrollViewDelegate>
@property(nonatomic,strong)Profiles *profile;
@property(nonatomic,strong)UIPageControl *pageControl;

-(instancetype)initWithFrame:(CGRect)frame user:(Profiles *)user;
@end

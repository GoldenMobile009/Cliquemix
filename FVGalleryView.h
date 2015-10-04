//
//  FVGalleryView.h
//  Festyvent
//
//  Created by Dejan Atanasov on 12/17/14.
//  Copyright (c) 2014 CLARIFi Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "Profiles.h"
#import "NSString+Years.h"

@interface FVGalleryView : UIView
<UIScrollViewDelegate>
{
    UIScrollView *photosScrollView;
    UIPageControl *pageControl;
}
@property(nonatomic)Profiles *profile;


-(id)initWithFrame:(CGRect)frame profile:(Profiles *)profile;


@end

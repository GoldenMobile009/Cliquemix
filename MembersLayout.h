//
//  MembersLayout.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/7/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembersLayout : UICollectionViewLayout
@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;

@end

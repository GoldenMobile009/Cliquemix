//
//  DiscoveryCell.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserEngine.h"
#import <UIImageView+WebCache.h>
@interface DiscoveryCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIView *overlayView;
@property(nonatomic,strong)IBOutlet UIView *imagesView;
@property(nonatomic,strong)IBOutlet UILabel *groupNameLabel;
@property(nonatomic,strong)IBOutlet UIImageView *muteImageView;

-(void)updateCellWithGroups:(Groups *)group color:(UIColor *)color;

@end
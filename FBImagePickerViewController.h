//
//  FBImagePickerViewController.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPhotoLayout.h"
#import <UIImageView+WebCache.h>
#import "ParserEngine.h"
#import <MBProgressHUD.h>
#import "ImagesCell.h"

@protocol imagePickerDelegate;
@interface FBImagePickerViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UICollectionView *imagesCollectionView;
    NSMutableArray *facebookImages;
    ParserEngine *myParser;
}
@property(nonatomic,weak)id<imagePickerDelegate>delegate;
@property(nonatomic)BOOL isButton;

-(IBAction)onBackButton:(id)sender;
-(instancetype)initWithButton:(BOOL)isButton;

@end
@protocol imagePickerDelegate <NSObject>

-(void)imagePickerWithImage:(NSString *)image isButton:(BOOL)isBtn;


@end
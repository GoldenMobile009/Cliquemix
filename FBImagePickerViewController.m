//
//  FBImagePickerViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "FBImagePickerViewController.h"

@interface FBImagePickerViewController ()

@end

@implementation FBImagePickerViewController
-(instancetype)initWithButton:(BOOL)isButton{
    self = [super init];
    if (self) {
        self.isButton = isButton;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myParser = [ParserEngine sharedInstance];
    UINib *nib = [UINib nibWithNibName:@"ImagesCell" bundle:nil];
    [imagesCollectionView registerNib:nib forCellWithReuseIdentifier:@"imagesCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"RefreshImages" object:nil];
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        [MBProgressHUD showHUDAddedTo:imagesCollectionView animated:YES];
        [myParser loadUserFacebookPhotosWithSuccessBlock:^{
            [imagesCollectionView reloadData];
            [MBProgressHUD hideHUDForView:imagesCollectionView animated:YES];
        } error:^(NSError *error) {
            [imagesCollectionView reloadData];
            [MBProgressHUD hideHUDForView:imagesCollectionView animated:YES];
        }];
    });
}
-(void)notification:(NSNotification *)notif{
    if ([notif.name isEqualToString:@"RefreshImages"]) {
        [imagesCollectionView reloadData];
        [MBProgressHUD hideHUDForView:imagesCollectionView animated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [myParser.facebookImages count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagesCell" forIndexPath:indexPath];
    [cell.imagesView sd_setImageWithURL:[NSURL URLWithString:[myParser.facebookImages objectAtIndex:indexPath.section]]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self delegate] respondsToSelector:@selector(imagePickerWithImage:isButton:)]) {
        [[self delegate] imagePickerWithImage:[myParser.facebookImages objectAtIndex:indexPath.section]isButton:self.isButton];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)onBackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

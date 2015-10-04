//
//  ViewController.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    myParser = [ParserEngine sharedInstance];
    
    FBLoginView *loginView = [[FBLoginView alloc]initWithReadPermissions:@[@"public_profile",@"user_birthday",@"email",@"user_photos",@"user_friends"]];
    [loginView setFrame:CGRectMake(50, (self.view.frame.size.height/2)+50, loginView.frame.size.width, loginView.frame.size.height)];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    
  //  iconView.layer.borderWidth = 1;
  //  iconView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [fbTextLabel setFrame:CGRectMake(0, loginView.frame.size.height+loginView.frame.origin.y+30, self.view.frame.size.width, fbTextLabel.frame.size.height)];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    [[ParserEngine sharedInstance] loadBasicUserInfoWithSuccessBlock:^{
        if ([myParser currentUser] == nil) {
            ProfileViewController *profile = [[ProfileViewController alloc]init];
            [self.navigationController pushViewController:profile animated:YES];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"createdProfile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate changeRootView];
        }
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

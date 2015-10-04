//
//  AppDelegate.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ProfileViewController.h"
#import <FacebookSDK.h>
#import "MenuViewController.h"
#import "MyGroupsViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UserLocation.h"
#import <Quickblox/Quickblox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;



-(void)changeRootView;
-(void)backToLoginScreen;


@end


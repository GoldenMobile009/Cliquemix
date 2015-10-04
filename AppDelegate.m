//
//  AppDelegate.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/4/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [FBSession openActiveSessionWithAllowLoginUI:NO];
    
//    [self checkInternetConnection];

    if ([[[FBSession activeSession] accessTokenData] accessToken].length == 0 || [[NSUserDefaults standardUserDefaults] valueForKey:@"createdProfile"] == nil) {
        [self backToLoginScreen];
    }
    else{
        [self changeRootView];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [UserLocation sharedInstance];
    
    [QBApplication sharedApplication].applicationId = 21565;
    [QBConnection registerServiceKey:@"GO37wMM6dprdOBE"];
    [QBConnection registerServiceSecret:@"j2KAdCzgbbJQx4F"];
    [QBSettings setAccountKey:@"tXDEyAzGMtDQ5qz4UKpA"];
    
    [self.window makeKeyAndVisible];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
        
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
#endif
    
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"Hex Token : %@", hexToken);
    
    [[User sharedInstance] setPushToken:hexToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self handleRemoteNotifications:userInfo];
}
-(void)handleRemoteNotifications:(NSDictionary *)userInfo {
    NSLog(@"UserInfo  : %@",userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshGroups" object:nil];
}

-(void)changeRootView{
    [[ParserEngine sharedInstance] loadBasicUserInfoWithSuccessBlock:nil error:nil];
    MyGroupsViewController *myGroupsView = [[MyGroupsViewController alloc]init];
    MenuViewController *menuView = [[MenuViewController alloc]init];
    [self changeRootView:myGroupsView leftView:menuView];
}
-(void)changeRootView:(UIViewController *)rootView leftView:(UIViewController *)leftView{
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:rootView
                                             leftDrawerViewController:leftView
                                             rightDrawerViewController:nil];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    
    UINavigationController *drawerNav = [[UINavigationController alloc]initWithRootViewController:drawerController];
    drawerNav.navigationBarHidden = YES;
    self.window.rootViewController = drawerNav;
}
-(void)backToLoginScreen{
    ViewController *rootView = [[ViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:rootView];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
}
//-(void)checkInternetConnection{
//    NSLog(@"Start Monitor: Reachability block called");
//    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        NSLog(@"Connection Monitor: Reachability block called");
//        
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"NetworkRefresh"
//         object:self];
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [[ParserEngine sharedInstance] getGroupActionsWithSuccessBlock:nil errorBlock:nil];
//                NSLog(@"Connection Monitor: We now got connected");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//            default:
//                NSLog(@"Connection Monitor: We now got disconnected");
//                break;
//        }
//    }];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[QBChat instance] logout];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[QBChat instance] logout];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  User.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "User.h"

@implementation User
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static User *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[User alloc] init];
    });
    return sharedUtilsInstance;
}
-(void)createProfileWithFBID:(NSString *)fbID images:(NSMutableArray *) images firstName:(NSString *)first_name age:(NSString *)age description:(NSString *)desc gender:(NSString *)gender email:(NSString *)email callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    UserLocation *myLocation = [UserLocation sharedInstance];
    Requests *myRequests = [Requests sharedInstance];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:fbID forKey:@"fb_id"];
//    [dict setValue:facebookToken forKey:@"device_token"];
    [dict setValue:[images objectAtIndex:0] forKey:@"profile_pic"];
    [dict setValue:[images objectAtIndex:1] forKey:@"pic1"];
    [dict setValue:[images objectAtIndex:2] forKey:@"pic2"];
    [dict setValue:[images objectAtIndex:3] forKey:@"pic3"];
    [dict setValue:[images objectAtIndex:4] forKey:@"pic4"];
    [dict setValue:[images objectAtIndex:5] forKey:@"pic5"];
    [dict setValue:desc forKey:@"description"];
    [dict setValue:gender forKey:@"gender"];
    [dict setValue:first_name forKey:@"first_name"];
    [dict setValue:age forKey:@"age"];
    [dict setValue:email forKey:@"email"];
    [dict setValue:myLocation.locatedAt forKey:@"location"];
    [dict setValue:[NSString stringWithFormat:@"%f",myLocation.current_latitude] forKey:@"latitude"];
    [dict setValue:[NSString stringWithFormat:@"%f",myLocation.current_longitude] forKey:@"longitude"];
    
    [myRequests requestWithEnd:@"user/createProfile" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        if(completionBlock != nil)
            completionBlock();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)
            errorBlock(error);
    }];
}
-(void)editProfileWithFBID:(NSString *)fbID images:(NSMutableArray *)images description:(NSString *)desc callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:fbID forKey:@"fb_id"];
    [dict setValue:[images objectAtIndex:0] forKey:@"profile_pic"];
    [dict setValue:[images objectAtIndex:1] forKey:@"pic1"];
    [dict setValue:[images objectAtIndex:2] forKey:@"pic2"];
    [dict setValue:[images objectAtIndex:3] forKey:@"pic3"];
    [dict setValue:[images objectAtIndex:4] forKey:@"pic4"];
    [dict setValue:[images objectAtIndex:5] forKey:@"pic5"];
    [dict setValue:desc forKey:@"description"];
    
    [myRequests requestWithEnd:@"edit_profile.php" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)errorBlock(error);
    }];
}
-(void)updateProfileWithChatID:(NSString *)chat_id fbID:(NSString *)fb_id callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:chat_id forKey:@"chat_id"];
    [dict setValue:fb_id forKey:@"fb_id"];

    [myRequests requestWithEnd:@"chat.php" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)errorBlock(error);
    }];
}

@end

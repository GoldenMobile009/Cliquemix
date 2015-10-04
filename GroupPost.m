//
//  GroupPost.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "GroupPost.h"

@implementation GroupPost
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static GroupPost *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[GroupPost alloc] init];
    });
    return sharedUtilsInstance;
}
-(void)createGroupWithName:(NSString *)name latitude:(NSString *)lat longitude:(NSString *)lon location:(NSString *)location description:(NSString *)desc users:(NSString *)users gender:(NSString *)gender callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setValue:name forKey:@"group_name"];
    [dict setValue:desc forKey:@"description"];
    [dict setValue:users forKey:@"users"];
    [dict setValue:location forKey:@"location"];
    [dict setValue:lat forKey:@"latitude"];
    [dict setValue:lon forKey:@"longitude"];
    [dict setValue:[NSString dateCreated] forKey:@"date_created"];
    [dict setValue:gender forKey:@"group_gender"];

    [myRequests requestWithEnd:@"group.php" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)errorBlock(error);
    }];
}
-(void)actionOnGroup:(NSString *)action userGroupID:(NSString *)ugid actionGroupID:(NSString *)agid callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:ugid forKey:@"source"];
    [dict setValue:agid forKey:@"target"];
    
    [myRequests requestWithEnd:action method:@"GET" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        NSLog(@"%@",responseObject);
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        if (errorBlock != nil)errorBlock(error);
    }];
}
-(void)sendMessage:(NSString *)message from:(NSString *)from users:(NSArray *)users groupID:(NSString *)gid callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:message forKey:@"message"];
    [dict setValue:[users componentsJoinedByString:@","] forKey:@"users"];
    [dict setValue:gid forKey:@"group_id"];
    [dict setValue:from forKey:@"from_id"];

    NSLog(@"Dict : %@",dict);

    [myRequests requestWithEnd:@"chatPush.php" method:@"GET" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        NSLog(@"%@",responseObject);
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        if (errorBlock != nil)errorBlock(error);
    }];
}

-(void)removeGroup:(NSString *)groupID withUserId:(NSString *)userID callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:groupID forKey:@"group_id"];
    [dict setValue:userID forKey:@"user_id"];

    [myRequests requestWithEnd:@"delete_group.php" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        NSLog(@"%@",responseObject);
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        if (errorBlock != nil)errorBlock(error);
    }];
}

-(void)muteGroup:(NSString *)groupID withUserId:(NSString *)userID callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:groupID forKey:@"group_id"];
    [dict setValue:userID forKey:@"user_id"];
    
    [myRequests requestWithEnd:@"mute.php" method:@"GET" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        NSLog(@"%@",responseObject);
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        if (errorBlock != nil)errorBlock(error);
    }];
}
#pragma mark Match Actions
-(void)blockMatch:(NSString *)matchID withUserId:(NSString *)userID reason:(NSString *)reason callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:matchID forKey:@"group_id"];
    [dict setValue:userID forKey:@"user_id"];
    if (reason) {
        [dict setValue:matchID forKey:@"reason"];
    }
    [myRequests requestWithEnd:@"block.php" method:@"POST" params:dict callWithSuccess:^(NSDictionary *responseObject, NSString *eTag) {
        NSLog(@"%@",responseObject);
        if(completionBlock != nil)completionBlock();
    } errorCallback:^(NSError *error) {
        NSLog(@"%@",error);
        if (errorBlock != nil)errorBlock(error);
    }];
}
@end

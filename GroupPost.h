//
//  GroupPost.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/8/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requests.h"
#import "NSString+CurrentDate.h"

@interface GroupPost : NSObject
+ (id)sharedInstance;
-(void)createGroupWithName:(NSString *)name latitude:(NSString *)lat longitude:(NSString *)lon location:(NSString *)location description:(NSString *)desc users:(NSString *)users gender:(NSString *)gender callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;
-(void)actionOnGroup:(NSString *)action userGroupID:(NSString *)ugid actionGroupID:(NSString *)agid callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;
-(void)sendMessage:(NSString *)message from:(NSString *)from users:(NSArray *)users groupID:(NSString *)gid callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;


-(void)removeGroup:(NSString *)groupID withUserId:(NSString *)userID callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;
-(void)muteGroup:(NSString *)groupID withUserId:(NSString *)userID callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;


-(void)blockMatch:(NSString *)matchID withUserId:(NSString *)userID reason:(NSString *)reason callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;


@end

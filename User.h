//
//  User.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requests.h"
#import "UserLocation.h"

@interface User : NSObject
@property(nonatomic,strong)NSString *pushToken;

+ (id)sharedInstance;
-(void)createProfileWithFBID:(NSString *)fbID images:(NSMutableArray *) images firstName:(NSString *)first_name age:(NSString *)age description:(NSString *)desc gender:(NSString *)gender email:(NSString *)email callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;
-(void)editProfileWithFBID:(NSString *)fbID images:(NSMutableArray *)images description:(NSString *)desc callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;
-(void)updateProfileWithChatID:(NSString *)chat_id fbID:(NSString *)fb_id callWithSuccess:(void (^)(void))completionBlock errorCallback:(void(^)(NSError*))errorBlock;


@end

//
//  ParserEngine.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>
#import "Cache.h"
#import "Profiles.h"
#import "Groups.h"
#import "User.h"

@interface ParserEngine : NSObject <FBFriendPickerDelegate>

@property(nonatomic,strong)NSMutableArray *facebookImages;
@property(nonatomic,strong)NSMutableDictionary *userInfo;
@property(nonatomic,strong)NSMutableArray *profiles;
@property(nonatomic,strong)NSMutableArray *mutualFriends;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSMutableArray *liked;
@property(nonatomic,strong)NSMutableArray *disliked;
@property(nonatomic)int counter;
@property(nonatomic,strong)NSDictionary *result;

@property(nonatomic,strong)FBFriendPickerViewController *friendsController;

+ (id)sharedInstance;

-(void)loadBasicUserInfoWithSuccessBlock:(void(^)(void))successBlock error:(void(^)(NSError *))errorBlock;
-(void)loadUserFacebookPhotosWithSuccessBlock:(void(^)(void))successBlock error:(void(^)(NSError *))errorBlock;
-(void)getProfiles:(NSString *)fbID WithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock;
-(void)getGroupsWithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock;
-(void)getGroupActionsWithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock;

-(Profiles *)currentUser;
-(Profiles *)getProfileWithID:(NSString *)fb_id;
-(NSArray *)groupsForCurrentUser;
-(NSArray *)sortedGroups;
-(NSDictionary *)interactionForGroup:(NSString *)grp_id;
-(Profiles *)getProfileForChatID:(NSString *)chat_id;

-(BOOL)isLoggedIn;


@end

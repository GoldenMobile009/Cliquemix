//
//  ParserEngine.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ParserEngine.h"

@implementation ParserEngine
@synthesize facebookImages;
@synthesize userInfo;

+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static ParserEngine *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[ParserEngine alloc] init];
    });
    return sharedUtilsInstance;
}

-(void)getProfiles:(NSString *)fbID WithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock{
    self.profiles = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setValue:[[User sharedInstance] pushToken] forKey:@"device_token"];
    if (fbID != nil) {
        [params setValue:fbID forKey:@"fb_id"];
    }
    Requests *request = [Requests sharedInstance];
    NSString *url = [NSString stringWithFormat:@"user/profileInfo"];
    //[request requestWithEnd: url method:@"GET" params:params callWithSuccess:^(id responseObject, NSString *tag) {
    [request requestWithEnd: url method:@"GET" params:params callWithSuccess:^(id responseObject, NSString *tag) {
        for (int i = 0;i<[responseObject count]; i++) {
            Profiles *profile = [[Profiles alloc]initWithDictionary:responseObject[i]];
            [self.profiles addObject:profile];
        }        
//        [self getGroupsWithSuccessBlock:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshProfiles" object:nil];
//            if (completed != nil)completed();
//        } errorBlock:nil];
        if (completed != nil)completed();
    } errorCallback:^(NSError *error) {
        
    }];
}
-(void)getGroupsWithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    self.groups = [[NSMutableArray alloc]init];
    [params setValue:self.currentUser.fbId forKey:@"user_id"];
    [params setValue:self.currentUser.gender forKey:@"gender"];
    Requests *myRequests = [Requests sharedInstance];
    [myRequests requestWithEnd:@"group_info.php" method:@"POST" params:params callWithSuccess:^(id responseObject, NSString *eTag) {
        for (int i = 0;i<[responseObject count]; i++) {
            Groups *group = [[Groups alloc]initWithDictionary:responseObject[i]];
            [self.groups addObject:group];
        }
        if (completed != nil) completed();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)errorBlock(error);
    }];
}
-(void)getGroupActionsWithSuccessBlock:(void(^)(void))completed errorBlock:(void(^)(NSError *))errorBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    self.liked = [[NSMutableArray alloc]init];
    self.disliked = [[NSMutableArray alloc]init];
    Requests *myRequests = [Requests sharedInstance];
    
    [myRequests requestWithEnd:@"interaction.php" method:@"GET" params:params callWithSuccess:^(id responseObject, NSString *eTag) {
        if (responseObject[@"disliked"] != [NSNull null]) {
            for (int i = 0; i<[responseObject[@"disliked"]count]; i++) {
                [self.disliked addObject:[responseObject[@"disliked"]objectAtIndex:i]];
            }
        }
        if (responseObject[@"likes"] != [NSNull null]) {
            for (int i = 0; i<[responseObject[@"likes"]count]; i++) {
                [self.liked addObject:[responseObject[@"likes"]objectAtIndex:i]];
            }
        }
        if (completed != nil) completed();
    } errorCallback:^(NSError *error) {
        if (errorBlock != nil)errorBlock(error);
    }];
}
-(NSDictionary *)interactionForGroup:(NSString *)grp_id{
    NSMutableArray *groupIds = [[NSMutableArray alloc]init];
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<[self.liked count]; i++){
        if ([[[self.liked objectAtIndex:i]valueForKey:@"group_id"]isEqualToString:grp_id] && ![groupIds containsObject:[[self.liked objectAtIndex:i] valueForKey:@"liked"]]) {
            [groupIds addObject:[[self.liked objectAtIndex:i] valueForKey:@"liked"]];
        }
    }
    if ([groupIds count] != 0) {
        [tmpDict setObject:groupIds forKey:@"liked"];
    }
    
    groupIds = nil;
    groupIds = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[self.disliked count]; i++) {
        
        if ([[[self.disliked objectAtIndex:i]valueForKey:@"group_id"]isEqualToString:grp_id] && ![groupIds containsObject:[[self.disliked objectAtIndex:i] valueForKey:@"disliked"]]) {
            [groupIds addObject:[[self.disliked objectAtIndex:i] valueForKey:@"disliked"]];
        }
    }
    if ([groupIds count] != 0) {
        [tmpDict setObject:groupIds forKey:@"disliked"];
    }
    return tmpDict;
}
-(NSArray *)groupsForCurrentUser{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Groups *groups in self.groups) {
        for (NSString *user in groups.users) {
            if ([user isEqualToString:[self.userInfo objectForKey:@"fbID"]]) {
                [array addObject:groups];
            }
        }
    }
    return array;
}
-(NSArray *)sortedGroups{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (Groups *grp in self.groups) {
        if (![grp.gender isEqualToString:[[self currentUser] gender]]) {
            if (![array containsObject:grp]) {
                [array addObject:grp];
            }
        }
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [array sortedArrayUsingDescriptors:sortDescriptors];
}

-(Profiles *)currentUser {
    for (Profiles *profile in self.profiles) {
         if ([profile.fbId isEqualToString:[self.userInfo valueForKey:@"fbID"]]){
            return profile;
        }
    }
    return nil;
}

-(Profiles *)getProfileWithID:(NSString *)fb_id{
    for (Profiles *profile in self.profiles) {
        //        NSLog(@"FBID %@ : %@",profile.fbId,fb_id);
        if ([profile.fbId isEqualToString:fb_id]) {
            return profile;
        }
    }
    return nil;
}
-(Profiles *)getProfileForChatID:(NSString *)chat_id{
    for (Profiles *profile in self.profiles) {
        if ([profile.chatID isEqualToString:chat_id]) {
            return profile;
        }
    }
    return nil;
}

#pragma mark Facebook
-(void)loadBasicUserInfoWithSuccessBlock:(void(^)(void))successBlock error:(void(^)(NSError *))errorBlock{
    userInfo = [[NSMutableDictionary alloc]init];
    if ([self isLoggedIn]) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *gender = [result objectForKey:@"gender"];
                NSString *firstName = [result objectForKey:@"first_name"];
                NSString *birthday = [result objectForKey:@"birthday"];
                NSString *fbID = [result objectForKey:@"id"];
                NSString *email = [result objectForKey:@"email"];
                
                //   NSLog(@"%@",result);
                
                if (gender.length != 0) {
                    [userInfo setValue:gender forKey:@"gender"];
                }
                if (firstName.length != 0) {
                    [userInfo setValue:firstName forKey:@"firstName"];
                }
                if (birthday.length != 0) {
                    [userInfo setValue:birthday forKey:@"age"];
                }
                if (fbID.length != 0) {
                    [userInfo setValue:fbID forKey:@"fbID"];
                }
                if (email.length != 0) {
                    [userInfo setValue:email forKey:@"email"];
                }
                
                NSString *facebookId = [result objectForKey:@"id"];
                if (facebookId.length != 0) {
                    NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                    [userInfo setValue:imageUrl forKey:@"profilePic"];
                }
                [self getProfiles:fbID WithSuccessBlock:^{
                    if (successBlock != nil)successBlock();
                } errorBlock:^(NSError *error) {
                    if (errorBlock != nil)errorBlock(error);
                }];
                
            }else{
                if (errorBlock != nil)errorBlock(error);
            }
        }];
    }
}

-(void)loadUserFacebookPhotosWithSuccessBlock:(void(^)(void))successBlock error:(void(^)(NSError *))errorBlock{
    facebookImages = [[NSMutableArray alloc]init];
    if ([[[FBSession activeSession] accessTokenData] accessToken].length != 0) {
        [FBRequestConnection startWithGraphPath:@"/me/albums"
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  if (!error) {
                                      if ([result[@"data"]count] != 0) {
                                          self.result = result;
                                          FBRequest *request = [[FBRequest alloc]initWithSession:[FBSession activeSession] graphPath:[NSString stringWithFormat:@"/%@/photos", result[@"data"][0][@"id"]] parameters:nil HTTPMethod:@"GET"];
                                          [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                              self.counter++;
                                              [self enterFacebookImages:result];
                                              [self imagesFromFacebookAlbum];
                                          }];
                                      }
                                      else{
                                          if (errorBlock != nil)errorBlock(error);
                                      }
                                  }
                                  else{
                                      if (errorBlock != nil)errorBlock(error);
                                  }
                              }];
    }
}

-(void)enterFacebookImages:(NSDictionary *)result{
    for (int i = 0; i<[result[@"data"] count]; i++) {
        NSString *source = result[@"data"][i][@"source"];
        if (source.length != 0) {
            [facebookImages addObject:source];
        }
    }
}

-(void)imagesFromFacebookAlbum{
    FBRequest *request = [[FBRequest alloc]initWithSession:[FBSession activeSession] graphPath:[NSString stringWithFormat:@"/%@/photos", self.result[@"data"][self.counter][@"id"]] parameters:nil HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (self.counter <= [self.result[@"data"] count]-1) {
            [self enterFacebookImages:result];
            [self imagesFromFacebookAlbum];
            self.counter++;
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshImages" object:nil];
        }
    }];
}

-(BOOL)isLoggedIn{
    if ([[[FBSession activeSession] accessTokenData] accessToken].length != 0) {
        return YES;
    }
    else{
        return NO;
    }
}

@end

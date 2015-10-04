//
//  ChatEngine.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/27/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "ChatEngine.h"

@implementation ChatEngine
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static ChatEngine *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[ChatEngine alloc] init];
    });
    return sharedUtilsInstance;
}
-(void)authenticateWithFirstName:(NSString *)firstName email:(NSString *)email successBlock:(void(^)(void))sucessBlock errorBlock:(void(^)(NSError *))errorBlock{
    // Create session request
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *user = [QBUUser user];
        User *myUser = [User sharedInstance];
        ParserEngine *myParser = [ParserEngine sharedInstance];
        Profiles *profile = [myParser currentUser];
        
        user.login = email;
        user.password = @"12345678";
        user.email = email;
        user.fullName = firstName;

        [QBRequest logInWithUserEmail:user.email password:user.password
                         successBlock:^(QBResponse *response, QBUUser *user) {
                             if (profile.chatID.length == 0) {
                                 [myUser updateProfileWithChatID:[NSString stringWithFormat:@"%i",(int)user.ID] fbID:profile.fbId callWithSuccess:nil errorCallback:nil];
                             }
                             [[LocalStorageService shared] setCurrentUser:user];
//                             NSLog(@"Logged in with USER : %@",user);
                             self.currentUser = user;
                             if (sucessBlock != nil)sucessBlock();
                                 } errorBlock:^(QBResponse *response) {
                             if ([[response.error.reasons valueForKey:@"errors"] count] != 0) {
                                 if ([[response.error.reasons valueForKey:@"errors"] count]!= 0) {
                                     if ([[[response.error.reasons valueForKey:@"errors"] firstObject]isEqualToString:@"Unauthorized"]) {
                                         [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
                                             [myUser updateProfileWithChatID:[NSString stringWithFormat:@"%i",(int)user.ID] fbID:profile.fbId callWithSuccess:nil errorCallback:nil];
                                             // Sign up was successful
//                                             NSLog(@"Create account with SUCCESS");
                                             if (sucessBlock != nil)sucessBlock();
                                         } errorBlock:^(QBResponse *response) {
                                             if (errorBlock != nil)errorBlock(response.error.error);
                                             //                                         NSLog(@"Failed Creating account %@",response.error);
                                         }];
                                     }
                                     else{
                                         [myUser updateProfileWithChatID:[NSString stringWithFormat:@"%i",(int)user.ID] fbID:profile.fbId callWithSuccess:^{
                                             if (sucessBlock != nil)sucessBlock();
                                         } errorCallback:^(NSError *error) {
                                             if (errorBlock != nil)errorBlock(error);
                                         }];
                                     }
                                 }
                             }
                         }];
        //Your Quickblox session was created successfully
    } errorBlock:^(QBResponse *response) {
        if (errorBlock != nil)errorBlock(response.error.error);
        //Handle error here
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
}
-(void)usersFromChatGroup:(Groups *)chat_grp myGroup:(Groups *)my_grp{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    ParserEngine *myParser = [ParserEngine sharedInstance];
    for (NSString *user in chat_grp.users) {
        if ([myParser getProfileWithID:user]) {
            [array addObject:[myParser getProfileWithID:user]];
        }
    }
    for (NSString *user in my_grp.users) {
        if ([myParser getProfileWithID:user]) {
            [array addObject:[myParser getProfileWithID:user]];
        }
    }
    [self getChatIDsFromArray:array];
}
-(void)getChatIDsFromArray:(NSArray *)array{
    self.chatIDs = [[NSMutableArray alloc]init];
    for (Profiles *profile in array) {
        if (![self.chatIDs containsObject:[NSNumber numberWithInteger:[profile.chatID integerValue]]]) {
            NSNumber *chatID = nil;
            if (profile.chatID.length == 0) {
                chatID = [NSNumber numberWithInteger:self.currentUser.ID];
            }
            else{
                chatID = [NSNumber numberWithInteger:[profile.chatID integerValue]];
            }
            [self.chatIDs addObject:chatID];
        }
    }
}

#pragma mark QBChatDelegate
-(void) chatDidLogin{
    if ([[self delegate]respondsToSelector:@selector(loggedInToChat)]) {
        [[self delegate] loggedInToChat];
    }
}
- (void)chatDidNotLogin{
    [self loginToChat];
    // Try to reauthenticate to QuickBlox Chat
}
-(void)loginToChat{
    QBUUser *user = [[QBUUser alloc]init];
    user.email = self.currentUser.email;
    user.password = @"12345678";
    user.ID = self.currentUser.ID;
    
    [[QBChat instance] loginWithUser:user];
    [QBChat instance].delegate = self;
}

@end

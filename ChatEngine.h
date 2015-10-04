//
//  ChatEngine.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/27/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>
#import "User.h"
#import "ParserEngine.h"
#import "LocalStorageService.h"

@protocol chatDelegate;
@interface ChatEngine : NSObject <QBChatDelegate,QBActionStatusDelegate>
@property(nonatomic,strong)QBUUser *currentUser;
@property(nonatomic,weak)id<chatDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *chatIDs;

+ (id)sharedInstance;
-(void)authenticateWithFirstName:(NSString *)firstName email:(NSString *)email successBlock:(void(^)(void))sucessBlock errorBlock:(void(^)(NSError *))errorBlock;
-(void)loginToChat;
-(void)usersFromChatGroup:(Groups *)chat_grp myGroup:(Groups *)my_grp;

@end
@protocol chatDelegate <NSObject>

-(void)loggedInToChat;


@end
//
//  FVRequest.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface Requests : NSObject

+ (id)sharedInstance;

-(void)requestWithEnd:(NSString *)endUrl method:(NSString *)method params:(NSMutableDictionary *)params callWithSuccess:(void (^)(NSDictionary*, NSString*))completionBlock errorCallback:(void(^)(NSError*))errorBlock;

@end

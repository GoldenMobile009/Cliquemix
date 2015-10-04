//
//  Cache.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requests.h"
#import <TMCache.h>
#import <AFNetworkReachabilityManager.h>

@interface Cache : NSObject
+ (id)sharedInstance;
-(void)getCacheForURL:(NSString *)url method:(NSString *)method params:(NSMutableDictionary *)params completition:(void (^)(id))completed error:(void(^)(NSError *))errorBlock;

@end

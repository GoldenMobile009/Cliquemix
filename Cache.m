//
//  Cache.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "Cache.h"

@implementation Cache
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static Cache *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[Cache alloc] init];
    });
    
    return sharedUtilsInstance;
}
-(void)getCacheForURL:(NSString *)url method:(NSString *)method params:(NSMutableDictionary *)params completition:(void (^)(id))completed error:(void(^)(NSError *))errorBlock{
    Requests *myRequests = [Requests sharedInstance];
    NSString *currentTag = @"";
    if ([[NSUserDefaults standardUserDefaults] valueForKey:url]) {
        currentTag = [[NSUserDefaults standardUserDefaults] valueForKey:url];
    }
    if ([self connectedToInternet]) {
        [[TMCache sharedCache] objectForKey:url block:^(TMCache *cache, NSString *key, id object) {
            [myRequests requestWithEnd:url method:method params:params callWithSuccess:^(id responseObject,NSString *eTag) {                
                if (![currentTag isEqualToString:eTag]) {
                    [[TMCache sharedCache] setObject:responseObject forKey:url];
                    [[NSUserDefaults standardUserDefaults]setObject:eTag forKey:url];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"%@ have been modified!",url);
                    if (completed != nil) completed(responseObject);
                }
                else {
                    if (object != nil) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                             NSLog(@"%@ have same objects!",url);
                            if (completed != nil) completed(object);
                            return;
                        }];
                    }
                }
            } errorCallback:^(NSError *error) {
                //                NSLog(@"Error :%@",error);
                if (errorBlock != nil) errorBlock(error);
            }];
        }];
    }
    else{
        id offlineResponse = [[TMCache sharedCache] objectForKey:url];
        if (completed != nil) completed(offlineResponse);
    }
}
-(BOOL)connectedToInternet{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
@end

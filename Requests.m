//
//  FVRequest.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/5/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "Requests.h"

@implementation Requests
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static Requests *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[Requests alloc] init];
    });
    return sharedUtilsInstance;
}
- (NSString*)getUrl:(NSString*)urlEnd {
    NSString *url = [NSString stringWithFormat:@"http://52.27.69.43:4000/%@",urlEnd];
    
    return url;
}

-(void)requestWithEnd:(NSString *)endUrl method:(NSString *)method params:(NSMutableDictionary *)params callWithSuccess:(void (^)(NSDictionary*response, NSString*eTag))completionBlock errorCallback:(void(^)(NSError*))errorBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json", nil]];
    
    NSString *url = [self getUrl:endUrl];
    
    if ([method isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {            
            if (completionBlock != nil) completionBlock(responseObject,[self getEtagFromResponse:operation]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorBlock != nil) errorBlock(error);
        }];
    }
    else{
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
            if (completionBlock != nil) completionBlock(responseObject,@"");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorBlock != nil) errorBlock(error);
        }];
    }
}
-(NSString *)getEtagFromResponse:(AFHTTPRequestOperation *)operation{
    if ([[[operation response] allHeaderFields] objectForKey:@"If-None-Match"] && [[[[operation response] allHeaderFields] objectForKey:@"If-None-Match"] length] > 2) {
        return [[[operation response] allHeaderFields] objectForKey:@"If-None-Match"];
    } else {
        return @"";
    }
}

@end

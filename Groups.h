//
//  Groups.h
//
//  Created by Dejan Atanasov on 2/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocation.h"

@interface Groups : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSNumber *mute;
@property (nonatomic) float distance;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

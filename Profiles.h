//
//  Profiles.h
//
//  Created by Dejan Atanasov on 2/6/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Profiles : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *pic5;
@property (nonatomic, strong) NSString *pic1;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *pic4;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *profilePic;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *pic3;
@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *pic2;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *chatID;

@property (nonatomic, strong) NSMutableArray *images;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end

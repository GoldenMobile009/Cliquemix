//
//  Profiles.m
//
//  Created by Dejan Atanasov on 2/6/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Profiles.h"


NSString *const kProfilesDescription = @"description";
NSString *const kProfilesPic5 = @"pic5";
NSString *const kProfilesPic1 = @"pic1";
NSString *const kProfilesAge = @"age";
NSString *const kProfilesLongitude = @"longitude";
NSString *const kProfilesPic4 = @"pic4";
NSString *const kProfilesLatitude = @"latitude";
NSString *const kProfilesProfilePic = @"profile_pic";
NSString *const kProfilesLocation = @"location";
NSString *const kProfilesFirstName = @"first_name";
NSString *const kProfilesPic3 = @"pic3";
NSString *const kProfilesFbId = @"fb_id";
NSString *const kProfilesPic2 = @"pic2";
NSString *const kProfilesGender = @"gender";
NSString *const kProfilesEmail = @"email";
NSString *const kProfilesChatID = @"chat_id";


@interface Profiles ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Profiles

@synthesize desc = _desc;
@synthesize pic5 = _pic5;
@synthesize pic1 = _pic1;
@synthesize age = _age;
@synthesize longitude = _longitude;
@synthesize pic4 = _pic4;
@synthesize latitude = _latitude;
@synthesize profilePic = _profilePic;
@synthesize location = _location;
@synthesize firstName = _firstName;
@synthesize pic3 = _pic3;
@synthesize fbId = _fbId;
@synthesize pic2 = _pic2;
@synthesize gender = _gender;
@synthesize email = _email;
@synthesize chatID = _chatID;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.desc = [self objectOrNilForKey:kProfilesDescription fromDictionary:dict];
            self.pic5 = [self objectOrNilForKey:kProfilesPic5 fromDictionary:dict];
            self.pic1 = [self objectOrNilForKey:kProfilesPic1 fromDictionary:dict];
            self.age = [self objectOrNilForKey:kProfilesAge fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kProfilesLongitude fromDictionary:dict];
            self.pic4 = [self objectOrNilForKey:kProfilesPic4 fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kProfilesLatitude fromDictionary:dict];
            self.profilePic = [self objectOrNilForKey:kProfilesProfilePic fromDictionary:dict];
            self.location = [self objectOrNilForKey:kProfilesLocation fromDictionary:dict];
            self.firstName = [self objectOrNilForKey:kProfilesFirstName fromDictionary:dict];
            self.pic3 = [self objectOrNilForKey:kProfilesPic3 fromDictionary:dict];
            self.fbId = [self objectOrNilForKey:kProfilesFbId fromDictionary:dict];
            self.pic2 = [self objectOrNilForKey:kProfilesPic2 fromDictionary:dict];
            self.gender = [self objectOrNilForKey:kProfilesGender fromDictionary:dict];
            self.email = [self objectOrNilForKey:kProfilesEmail fromDictionary:dict];
            self.chatID = [self objectOrNilForKey:kProfilesChatID fromDictionary:dict];

            self.images = [[NSMutableArray alloc]initWithObjects:self.profilePic,self.pic1,self.pic2,self.pic3,self.pic4,self.pic5, nil];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.desc forKey:kProfilesDescription];
    [mutableDict setValue:self.pic5 forKey:kProfilesPic5];
    [mutableDict setValue:self.pic1 forKey:kProfilesPic1];
    [mutableDict setValue:self.age forKey:kProfilesAge];
    [mutableDict setValue:self.longitude forKey:kProfilesLongitude];
    [mutableDict setValue:self.pic4 forKey:kProfilesPic4];
    [mutableDict setValue:self.latitude forKey:kProfilesLatitude];
    [mutableDict setValue:self.profilePic forKey:kProfilesProfilePic];
    [mutableDict setValue:self.location forKey:kProfilesLocation];
    [mutableDict setValue:self.firstName forKey:kProfilesFirstName];
    [mutableDict setValue:self.pic3 forKey:kProfilesPic3];
    [mutableDict setValue:self.fbId forKey:kProfilesFbId];
    [mutableDict setValue:self.pic2 forKey:kProfilesPic2];
    [mutableDict setValue:self.gender forKey:kProfilesGender];
    [mutableDict setValue:self.email forKey:kProfilesEmail];
    [mutableDict setValue:self.chatID forKey:kProfilesChatID];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.desc = [aDecoder decodeObjectForKey:kProfilesDescription];
    self.pic5 = [aDecoder decodeObjectForKey:kProfilesPic5];
    self.pic1 = [aDecoder decodeObjectForKey:kProfilesPic1];
    self.age = [aDecoder decodeObjectForKey:kProfilesAge];
    self.longitude = [aDecoder decodeObjectForKey:kProfilesLongitude];
    self.pic4 = [aDecoder decodeObjectForKey:kProfilesPic4];
    self.latitude = [aDecoder decodeObjectForKey:kProfilesLatitude];
    self.profilePic = [aDecoder decodeObjectForKey:kProfilesProfilePic];
    self.location = [aDecoder decodeObjectForKey:kProfilesLocation];
    self.firstName = [aDecoder decodeObjectForKey:kProfilesFirstName];
    self.pic3 = [aDecoder decodeObjectForKey:kProfilesPic3];
    self.fbId = [aDecoder decodeObjectForKey:kProfilesFbId];
    self.pic2 = [aDecoder decodeObjectForKey:kProfilesPic2];
    self.gender = [aDecoder decodeObjectForKey:kProfilesGender];
    self.email = [aDecoder decodeObjectForKey:kProfilesEmail];
    self.chatID = [aDecoder decodeObjectForKey:kProfilesChatID];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_desc forKey:kProfilesDescription];
    [aCoder encodeObject:_pic5 forKey:kProfilesPic5];
    [aCoder encodeObject:_pic1 forKey:kProfilesPic1];
    [aCoder encodeObject:_age forKey:kProfilesAge];
    [aCoder encodeObject:_longitude forKey:kProfilesLongitude];
    [aCoder encodeObject:_pic4 forKey:kProfilesPic4];
    [aCoder encodeObject:_latitude forKey:kProfilesLatitude];
    [aCoder encodeObject:_profilePic forKey:kProfilesProfilePic];
    [aCoder encodeObject:_location forKey:kProfilesLocation];
    [aCoder encodeObject:_firstName forKey:kProfilesFirstName];
    [aCoder encodeObject:_pic3 forKey:kProfilesPic3];
    [aCoder encodeObject:_fbId forKey:kProfilesFbId];
    [aCoder encodeObject:_pic2 forKey:kProfilesPic2];
    [aCoder encodeObject:_gender forKey:kProfilesGender];
    [aCoder encodeObject:_email forKey:kProfilesEmail];
    [aCoder encodeObject:_chatID forKey:kProfilesChatID];

}

- (id)copyWithZone:(NSZone *)zone
{
    Profiles *copy = [[Profiles alloc] init];
    
    if (copy) {
        copy.desc = [self.desc copyWithZone:zone];
        copy.pic5 = [self.pic5 copyWithZone:zone];
        copy.pic1 = [self.pic1 copyWithZone:zone];
        copy.age = [self.age copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.pic4 = [self.pic4 copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.profilePic = [self.profilePic copyWithZone:zone];
        copy.location = [self.location copyWithZone:zone];
        copy.firstName = [self.firstName copyWithZone:zone];
        copy.pic3 = [self.pic3 copyWithZone:zone];
        copy.fbId = [self.fbId copyWithZone:zone];
        copy.pic2 = [self.pic2 copyWithZone:zone];
        copy.gender = [self.gender copyWithZone:zone];
        copy.email = [self.email copyWithZone:zone];
        copy.chatID = [self.chatID copyWithZone:zone];

    }
    
    return copy;
}

-(NSArray *)userImages{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0;i<[self.images count] ; i++) {
        NSString *image = [self.images objectAtIndex:i];
        if (image.length != 0) {
            [array addObject:image];
        }
    }
    return array;
}


@end

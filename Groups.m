//
//  Groups.m
//
//  Created by Dejan Atanasov on 2/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Groups.h"


NSString *const kGroupsLocation = @"location";
NSString *const kGroupsLongitude = @"longitude";
NSString *const kGroupsId = @"id";
NSString *const kGroupsLatitude = @"latitude";
NSString *const kGroupsDescription = @"description";
NSString *const kGroupsUsers = @"users";
NSString *const kGroupsGroupName = @"group_name";
NSString *const kGroupsGroupGender = @"group_gender";
NSString *const kGroupsGroupMute = @"mute";


@interface Groups ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Groups

@synthesize location = _location;
@synthesize longitude = _longitude;
@synthesize gid = _gid;
@synthesize latitude = _latitude;
@synthesize desc = _desc;
@synthesize users = _users;
@synthesize groupName = _groupName;
@synthesize gender = _gender;
@synthesize mute = _mute;

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
            self.location = [self objectOrNilForKey:kGroupsLocation fromDictionary:dict];
            self.longitude = [self objectOrNilForKey:kGroupsLongitude fromDictionary:dict];
            self.gid = [self objectOrNilForKey:kGroupsId fromDictionary:dict];
            self.latitude = [self objectOrNilForKey:kGroupsLatitude fromDictionary:dict];
            self.desc = [self objectOrNilForKey:kGroupsDescription fromDictionary:dict];        
            self.users = [[self objectOrNilForKey:kGroupsUsers fromDictionary:dict] componentsSeparatedByString:@","];
            self.groupName = [self objectOrNilForKey:kGroupsGroupName fromDictionary:dict];
            self.gender = [self objectOrNilForKey:kGroupsGroupGender fromDictionary:dict];
            self.mute = [self objectOrNilForKey:kGroupsGroupMute fromDictionary:dict];

            self.distance = [self distanceBetweenLocations];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.location forKey:kGroupsLocation];
    [mutableDict setValue:self.longitude forKey:kGroupsLongitude];
    [mutableDict setValue:self.gid forKey:kGroupsId];
    [mutableDict setValue:self.latitude forKey:kGroupsLatitude];
    [mutableDict setValue:self.desc forKey:kGroupsDescription];
    [mutableDict setValue:self.users forKey:kGroupsUsers];
    [mutableDict setValue:self.groupName forKey:kGroupsGroupName];
    [mutableDict setValue:self.gender forKey:kGroupsGroupGender];
    [mutableDict setValue:self.mute forKey:kGroupsGroupMute];

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

    self.location = [aDecoder decodeObjectForKey:kGroupsLocation];
    self.longitude = [aDecoder decodeObjectForKey:kGroupsLongitude];
    self.gid = [aDecoder decodeObjectForKey:kGroupsId];
    self.latitude = [aDecoder decodeObjectForKey:kGroupsLatitude];
    self.desc = [aDecoder decodeObjectForKey:kGroupsDescription];
    self.users = [aDecoder decodeObjectForKey:kGroupsUsers];
    self.groupName = [aDecoder decodeObjectForKey:kGroupsGroupName];
    self.gender = [aDecoder decodeObjectForKey:kGroupsGroupGender];
    self.mute = [aDecoder decodeObjectForKey:kGroupsGroupMute];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_location forKey:kGroupsLocation];
    [aCoder encodeObject:_longitude forKey:kGroupsLongitude];
    [aCoder encodeObject:_gid forKey:kGroupsId];
    [aCoder encodeObject:_latitude forKey:kGroupsLatitude];
    [aCoder encodeObject:_desc forKey:kGroupsDescription];
    [aCoder encodeObject:_users forKey:kGroupsUsers];
    [aCoder encodeObject:_groupName forKey:kGroupsGroupName];
    [aCoder encodeObject:_gender forKey:kGroupsGroupGender];
    [aCoder encodeObject:_mute forKey:kGroupsGroupMute];

}

- (id)copyWithZone:(NSZone *)zone
{
    Groups *copy = [[Groups alloc] init];
    
    if (copy) {

        copy.location = [self.location copyWithZone:zone];
        copy.longitude = [self.longitude copyWithZone:zone];
        copy.gid = [self.gid copyWithZone:zone];
        copy.latitude = [self.latitude copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.users = [self.users copyWithZone:zone];
        copy.groupName = [self.groupName copyWithZone:zone];
        copy.gender = [self.gender copyWithZone:zone];
        copy.mute = [self.mute copyWithZone:zone];
    }
    
    return copy;
}
-(float)distanceBetweenLocations{
    UserLocation *location = [UserLocation sharedInstance];
    if (location.locationServices) {
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:location.current_latitude longitude:location.current_longitude];
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
        
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        float distanceKM = distance/1000;
        
        return distanceKM;
    }
    else{
        return 0.0;
    }
}

@end

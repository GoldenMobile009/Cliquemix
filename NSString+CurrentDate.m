//
//  NSString+CurrentDate.m
//  BANDin
//
//  Created by Dejan Atanasov on 10/30/14.
//  Copyright (c) 2014 Dejan Atanasov. All rights reserved.
//

#import "NSString+CurrentDate.h"

@implementation NSString (CurrentDate)
+(NSString *)dateCreated{
    NSDate* sourceDate = [NSDate date];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return [NSString stringWithFormat:@"%@",destinationDate];
}

@end

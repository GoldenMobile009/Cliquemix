//
//  NSString+Years.m
//  BANDin
//
//  Created by Dejan Atanasov on 11/2/14.
//  Copyright (c) 2014 Dejan Atanasov. All rights reserved.
//

#import "NSString+Years.h"

@implementation NSString (Years)
+(NSString *)yearsBetweenBirthdate:(NSString *)birthDate{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM/dd/yyyy"];
    NSDate *startDate = [f dateFromString:birthDate];
    NSDate *endDate = [f dateFromString:[f stringFromDate:[NSDate date]]];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitMonth fromDate:startDate toDate:endDate options:0];
    
    return [NSString stringWithFormat:@"%i",(int)[components year]];
}

@end

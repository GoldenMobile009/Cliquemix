//
//  UserLocation.m
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/6/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import "UserLocation.h"

@implementation UserLocation
+ (id)sharedInstance;
{
    static dispatch_once_t onceToken;
    static UserLocation *sharedUtilsInstance = nil;
    
    dispatch_once( &onceToken, ^{
        sharedUtilsInstance = [[UserLocation alloc] init];
        [sharedUtilsInstance updateCurrentLocation];
    });
    return sharedUtilsInstance;
}
-(void)updateCurrentLocation{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}
-(void)takeCurrentLocationWithCompletition:(void(^)(void))completed {
    geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.current_country = placemark.country;
            self.locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
            self.current_city = [placemark valueForKey:@"name"];
            
            self.current_latitude = locationManager.location.coordinate.latitude;
            self.current_longitude = locationManager.location.coordinate.longitude;
                        
            if (completed != nil) completed();
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationServices = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WaitingLocation" object:nil];
        [self takeCurrentLocationWithCompletition:^{
        }];
    }
    else if (status == kCLAuthorizationStatusDenied){
        NSString *locationOpened = @"";
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"locationView"]) {
            locationOpened = [[NSUserDefaults standardUserDefaults] valueForKey:@"locationView"];
        }
        if (locationOpened == nil || [locationOpened isEqualToString:@"0"]) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app, otherwise you will be given the last 50 posts worldwide." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Settings", nil];
            [av show];
            NSLog(@"Denied Location Services!");
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLocation" object:self];
            self.locationServices = NO;
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *settings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settings]){
            [[UIApplication sharedApplication] openURL:settings];
        }
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLocation" object:self];
    }
}
@end

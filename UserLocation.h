//
//  UserLocation.h
//  Cliquemix
//
//  Created by Dejan Atanasov on 2/6/15.
//  Copyright (c) 2015 Cliquemix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserLocation : NSObject
<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
}
+ (id)sharedInstance;

@property(nonatomic,strong)NSString *current_country;
@property(nonatomic,strong)NSString *current_city;
@property(nonatomic,strong)NSString *locatedAt;
@property(nonatomic)double current_latitude;
@property(nonatomic)double current_longitude;
@property(nonatomic)BOOL locationServices;

@end

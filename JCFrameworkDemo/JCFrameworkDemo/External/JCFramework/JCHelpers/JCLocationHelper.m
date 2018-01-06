//
//  JCLocationHelper.m
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//



#import "JCLocationHelper.h"

#import "JCUIAlertUtils.h"


static JCLocationHelper *sharedInstance;

@interface JCLocationHelper ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end





@implementation JCLocationHelper

+ (JCLocationHelper *)sharedHelper{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [JCLocationHelper new];
        [sharedInstance setup];
    });
    
    return sharedInstance;
}


- (void)setup{
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }
    else{
        [JCUIAlertUtils showYesNoDialog:@""
                                content:@"Location service is disabled.\nTap \"Settings\" to enable."
                            yesBtnTitle:@"Settings"
                             yesHandler:^(UIAlertAction *action) {
                                 
                             }
                             noBtnTitle:@"Cancel"
                              noHandler:nil];
    }
}

- (void)requestWhenInUseAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location service is off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        [JCUIAlertUtils showYesNoDialog:title
                                content:message
                            yesBtnTitle:@"Settings"
                             yesHandler:^(UIAlertAction *action) {
                                 
                             }
                             noBtnTitle:@"Cancel"
                              noHandler:nil];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

- (void)startUpdatingLocation{
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    [JCUIAlertUtils showConfirmDialog:@"" content:@"Failed to Get Your Location" okHandler:nil];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            break;
            
        default:
            [_locationManager startUpdatingLocation];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _lastKnownLocation = newLocation;
    if(_delegate){
        [_delegate onLocationFetch:_lastKnownLocation];
    }
}

@end

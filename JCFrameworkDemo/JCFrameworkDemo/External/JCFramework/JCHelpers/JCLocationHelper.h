//
//  JCLocationHelper.h
//
//  Created by Johnnie Cheng on 13/12/17.
//  Copyright © 2017 Johnnie Cheng. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


@protocol JCLocationHelperDelegate

@required
- (void)onLocationFetch:(CLLocation *)location;

@end





@interface JCLocationHelper : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *lastKnownLocation;
@property (weak, nonatomic) NSObject<JCLocationHelperDelegate> *delegate;

+ (JCLocationHelper *)sharedHelper;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end

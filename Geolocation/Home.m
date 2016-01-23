//
//  ViewController.m
//  Geolocation
//
//  Created by Galileo Guzman on 21/01/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import "Home.h"

#define METERS_PER_MILE 1609.344

@interface Home ()

@end

CLLocationManager *locationManager;
CLLocationCoordinate2D mapLocation;
CLGeocoder *geocoder;
CLPlacemark *placemark;
CLLocation *locationUAG;

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    
    geocoder = [[CLGeocoder alloc] init];
    
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
    }
    
    locationUAG = [[CLLocation alloc] initWithLatitude:20.6947053 longitude:-103.4203199];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)btnGetLocationPressed:(id)sender {
    
    NSLog(@"Button pressed");
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Delegate locationManager");
    
    CLLocation *newLocation = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
    
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSLog(@"Latitude %f", newLocation.coordinate.latitude);
            NSLog(@"Latitude %f", newLocation.coordinate.longitude);
            CLLocationDistance distance = [newLocation distanceFromLocation:locationUAG];
            NSLog(@"Distance %f", distance / 1000.0);
            
            
            // Map setup
            mapLocation.latitude = newLocation.coordinate.latitude;
            mapLocation.longitude = newLocation.coordinate.longitude;
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(mapLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            
            // 3
            [self.mapLocation setRegion:viewRegion animated:YES];
            
        }else{
            NSLog(@"%@", error.debugDescription);
        }
    
    }];
    
    
    
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Cannot find the location: ERROR : %@", error.debugDescription);
}
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    NSLog(@"Cannot find the location: ERROR : %@", error.debugDescription);
}
@end

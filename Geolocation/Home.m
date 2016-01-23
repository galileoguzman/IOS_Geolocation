//
//  ViewController.m
//  Geolocation
//
//  Created by Galileo Guzman on 21/01/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import "Home.h"

@interface Home ()

@end

CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

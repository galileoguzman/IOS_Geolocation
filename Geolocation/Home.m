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
MKAnnotationView *anLocation;
CLGeocoder *geocoder;
CLPlacemark *placemark;
CLLocation *locationUAG;
CLLocationCoordinate2D mapUAGLocation;

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapLocation.delegate = self;
    
    geocoder = [[CLGeocoder alloc] init];
    
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
    }
    
    locationUAG = [[CLLocation alloc] initWithLatitude:20.6947053 longitude:-103.4203199];
    mapUAGLocation = CLLocationCoordinate2DMake(20.6947053, -103.4203199);
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
            
            // circle
            self.mapLocation.userTrackingMode = MKUserTrackingModeFollow;
            
            // Annotation for user current location
            MKPointAnnotation *anLocation = [[MKPointAnnotation alloc] init];
            anLocation.coordinate = CLLocationCoordinate2DMake(mapLocation.latitude, mapLocation.longitude);
            anLocation.title = @"You are here";
            anLocation.subtitle = @"A world is locking you!";
            [self.mapLocation addAnnotation:anLocation];
            
            // Annotation for Universidad Autonoma de Guadalajara
            MKPointAnnotation *anLocationUAG = [[MKPointAnnotation alloc] init];
            anLocationUAG.coordinate = CLLocationCoordinate2DMake(locationUAG.coordinate.latitude, locationUAG.coordinate.longitude);
            anLocationUAG.title = @"Universidad Autonoma de Guadalajara";
            anLocationUAG.subtitle = @"AV. Patria 1201, Zapopan Jalisco";
            [self.mapLocation addAnnotation:anLocationUAG];
            
            // Get direction request
            
            // Make placemark and map item source
            MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:mapLocation addressDictionary:nil];
            MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
            
            // Make placemark and map item dest
            MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:mapUAGLocation addressDictionary:nil];
            MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];
            
            // Make Direction request with before placemark
            MKDirectionsRequest *dirRequest = [[MKDirectionsRequest alloc] init];
            [dirRequest setSource:mapItemSrc];
            [dirRequest setDestination:mapItemDest];
            
            [dirRequest setTransportType:MKDirectionsTransportTypeAutomobile];
            dirRequest.requestsAlternateRoutes = NO;
            
            // Get directions
            MKDirections *directions = [[MKDirections alloc] initWithRequest:dirRequest];
            
            // add to map directions
            [directions calculateDirectionsWithCompletionHandler:
             ^(MKDirectionsResponse *response, NSError *error) {
                 if (error) {
                     // Handle Error
                 } else {
                     [self.mapLocation removeOverlays:self.mapLocation.overlays];
                     [self showRoute:response];
                 }
             }];
            
            // print map on view
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

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapLocation addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor colorWithRed:35.0f/255.0f green:164.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
    renderer.lineWidth = 2.5;
    return renderer;
}

@end

//
//  ViewController.h
//  Geolocation
//
//  Created by Galileo Guzman on 21/01/16.
//  Copyright © 2016 Galileo Guzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"

@interface Home : UIViewController <CLLocationManagerDelegate>

- (IBAction)btnGetLocationPressed:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *mapLocation;
@end


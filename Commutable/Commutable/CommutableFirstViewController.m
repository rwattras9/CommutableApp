//
//  CommutableFirstViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommutableFirstViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CommutableFirstViewController ()

@end

@implementation CommutableFirstViewController{
    BOOL firstLocationUpdate_;
}
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:89.00
                                                            longitude:43.00
                                                                 zoom:1];
    
    // Create the GMSMapView with the camera position.
    //self.mapView.camera = camera;
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 28, 320, 491) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.compassButton = YES;
    mapView.trafficEnabled = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    self.view = mapView;
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    
}



- (void)dealloc {
  [mapView removeObserver:self
               forKeyPath:@"myLocation"
                  context:NULL];
}


    
#pragma mark - KVO updates
    
- (void)observeValueForKeyPath:(NSString *)keyPath
                        ofObject:(id)object
                          change:(NSDictionary *)change
                         context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

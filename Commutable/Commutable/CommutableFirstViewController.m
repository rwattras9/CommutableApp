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
    
    // New build with HTML
    NSError *error = nil;
    // create NSString from local HTML file and add it to the webView
    NSString *html = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    [self.mapView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [self.view sendSubviewToBack:self.mapView];
    
    
    
    /* Original build with UIView
     
	// Do any additional setup after loading the view, typically from a nib.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:89.00
                                                            longitude:43.00
                                                                 zoom:1];
    mapView.myLocationEnabled = YES;
    mapView.settings.compassButton = YES;
    mapView.trafficEnabled = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    // Add the map to the custom View
    [mapView setCamera:camera];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
     
     */
}

- (IBAction)routeButton:(id)sender {
    
    [self.mapView stringByEvaluatingJavaScriptFromString:@"calculateRoute(50.777682, 6.077163, 50.779347, 6.059429)"];  
    
}

/* Original build with UIView
- (void)dealloc {
  [mapView removeObserver:self
               forKeyPath:@"myLocation"
                  context:NULL];
}
*/

    
#pragma mark - KVO updates
    
/* Original build with UIView
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
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

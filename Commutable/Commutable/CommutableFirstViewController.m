//
//  CommutableFirstViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommutableFirstViewController.h"
#import "MDDirectionService.h"

@interface CommutableFirstViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;
@end

@implementation CommutableFirstViewController{
    BOOL firstLocationUpdate_;
    
}
@synthesize mapView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.0667
                                                            longitude:-89.4000
                                                                 zoom:1];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(23, 27, 275, 350) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.scrollGestures = YES;
    mapView.settings.zoomGestures = YES;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.trafficEnabled = YES;
    
    [mapView addObserver:self
              forKeyPath:@"myLocation"
                 options:NSKeyValueObservingOptionNew
                 context:NULL];
    
    [self.view addSubview:mapView];
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = 43.0667;
    coordinate1.longitude = -89.4000;
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude = 40.4417;
    coordinate2.longitude = -80.00;
    [self drawCoordinates:coordinate1 :coordinate2];
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:5];
    }
}

- (void)dealloc {
    [mapView removeObserver:self
                 forKeyPath:@"myLocation"
                    context:NULL];
}


//-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
-(void)drawCoordinates:(CLLocationCoordinate2D)coordinate1
                      :(CLLocationCoordinate2D)coordinate2
{
    //NSLog(@"you tapped at %f, %f", coordinate.longitude, coordinate.latitude);
    
    //CLLocationCoordinate2D tapPosition = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    
    GMSMarker *startMarker = [GMSMarker markerWithPosition:coordinate1];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:coordinate2];
    startMarker.map = mapView;
    endMarker.map = mapView;
    //tapMarker.map = self.mapView;
    [self.waypoints addObject:startMarker];
    [self.waypoints addObject:endMarker];
    
    NSString *position1String = [NSString stringWithFormat:@"%f,%f", coordinate1.latitude,coordinate1.longitude];
    NSString *position2String = [NSString stringWithFormat:@"%f,%f", coordinate2.latitude,coordinate2.longitude];
    [self.waypointStrings addObject:position1String];
    [self.waypointStrings addObject:position2String];
    
    if (self.waypoints.count > 1) {
        NSDictionary *query = @{ @"sensor" : @"false",
                                 @"waypoints" : self.waypointStrings };
        MDDirectionService *mds = [[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

-(void)addDirections:(NSDictionary *)json
{
    NSDictionary *routes = json[@"routes"][0];
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 10;
    polyline.map = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

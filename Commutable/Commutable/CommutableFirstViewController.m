//
//  CommutableFirstViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommutableFirstViewController.h"
#import "MDDirectionService.h"
#import <QuartzCore/QuartzCore.h>

@interface CommutableFirstViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;
@end

@implementation CommutableFirstViewController{
    BOOL firstLocationUpdate_;
    
}
@synthesize mapView;
@synthesize directionsText;

- (void)loadView
{
    [super loadView];
    
    // create the label view with rounded edges
    //self.directionsText.layer.cornerRadius = 4;
    NSLog(@"test");
    
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"test3");
    [self fetch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"test2");
	
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.0667
                                                            longitude:-89.4000
                                                                 zoom:1];
    
    
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 27, 320, 370) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.scrollGestures = YES;
    mapView.settings.zoomGestures = YES;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.trafficEnabled = YES;
    
    // might not need this, just experimenting with shaping the map
    //mapView.layer.cornerRadius = 4;
    
    [self.view addSubview:mapView];
    
    
    
    [self fetch];
    
    
    
}

-(void)fetch
{
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Commute"];
    self.commuteArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    if (self.commuteArray.count == 0) {
        [mapView addObserver:self
                  forKeyPath:@"myLocation"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
        
        self.directionsText.text = @"Showing current location\nSet a route!";
    }
    else if (self.commuteArray.count > 0){
        
        NSManagedObject *commute = [self.commuteArray objectAtIndex:0];
        
        NSString *origin = [commute valueForKey:@"startingAddress"];
        NSString *originZip = [commute valueForKey:@"startingZip"];
        NSString *destination = [commute valueForKey:@"destinationAddress"];
        NSString *destZip = [commute valueForKey:@"destinationZip"];
        
        [self setOrigin:origin setOriginZip:originZip setDestination:destination setDestZip:destZip];
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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


- (void) setOrigin:(NSString*)origin setOriginZip:(NSString*)originZip setDestination:(NSString*)destination setDestZip:(NSString*)destZip
{
    NSDictionary *query = @{ @"sensor" : @"false",
                             @"origin" : origin,
                             @"originZip" : originZip,
                             @"destination" : destination,
                             @"destZip" : destZip};
    MDDirectionService *mds = [[MDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
}


// method that reads the route info from the JSON output of the directions API query, then draws the polyline info on the map
// we should be able to just add more dictionary calls here to grab the rest of the data methinks!
-(void)addDirections:(NSDictionary *)json
{
    
    NSDictionary *routes = json[@"routes"][0];
    
    NSDictionary *legs = routes[@"legs"][0];
    
    // get the distance in text form
    NSDictionary *distance = legs[@"distance"];
    NSString *distanceText = distance[@"text"];
    
    // get the duration in text form
    NSDictionary *duration = legs[@"duration"];
    NSString *durationText = duration[@"text"];
    
    // get and save the starting coords
    NSDictionary *start_location = legs[@"start_location"];
    NSString *start_lat = start_location[@"lat"];
    double startLatDouble = [start_lat doubleValue];
    NSString *start_lng = start_location[@"lng"];
    double startLngDouble = [start_lng doubleValue];
    CLLocationCoordinate2D origin;
    origin.latitude = startLatDouble;
    origin.longitude = startLngDouble;
    
    
    // get and save the ending coords
    NSDictionary *end_location = legs[@"end_location"];
    NSString *end_lat = end_location[@"lat"];
    double endLatDouble = [end_lat doubleValue];
    NSString *end_lng = end_location[@"lng"];
    double endLngDouble = [end_lng doubleValue];
    CLLocationCoordinate2D destination;
    destination.latitude = endLatDouble;
    destination.longitude = endLngDouble;
    
    // add markers to the map for the origin and destination
    GMSMarker *startMarker = [GMSMarker markerWithPosition:origin];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:destination];
    startMarker.map = mapView;
    endMarker.map = mapView;
    
    // draw the direction line
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 8;
    polyline.map = mapView;
    
    // focus camera on route (still working on this..). It's being overruled by the method that's focusing on your location I believe
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [mapView moveCamera:update];
    
    NSString *dirText = [NSString stringWithFormat:@"Take %@. Distance = %@, Duration = %@", routes[@"summary"], distanceText, durationText];
    self.directionsText.text = dirText;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

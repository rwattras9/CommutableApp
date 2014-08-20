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
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *waypoints;
@property (strong, nonatomic) NSMutableArray *waypointStrings;
@property (strong, nonatomic) NSMutableArray *commuteNameArray;
@property (strong, nonatomic) NSMutableArray *labelArray;
@property (strong, nonatomic) NSMutableArray *textArray;
@property (strong, nonatomic) NSMutableArray *originArray;
@property (strong, nonatomic) NSMutableArray *destinationArray;
@property (strong, nonatomic) NSMutableArray *originZipArray;
@property (strong, nonatomic) NSMutableArray *destinationZipArray;
@property (strong, nonatomic) UILabel *noCommuteLabel;
@end

@implementation CommutableFirstViewController{
    BOOL firstLocationUpdate_;
    bool needToClearLabel;
    int currentPage;
}
@synthesize mapView;
@synthesize scrollView;
@synthesize pageControl;



// called before the view finishes loading, both on start and after tab is in focus
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // testing a way to clear things before the view is presented, especially to refresh after the tab has been switched back to
    for (int i=0; i < self.labelArray.count; i++)
    {
        [[self.labelArray objectAtIndex:i] removeFromSuperview];
    }
    [self.mapView clear];
    
    // while the view is loading, make the call to grab the data from the datastore
    [self fetchData];
}




/*
// called after the view appears (after it loads, or after the tab is clicked)
- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"test3");
    //[self fetchData];
}
 */




// called when the view loads, called once at first app load (not everytime tab is opened)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize waypoint arrays for storing multiple routes
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];
 
    // initialize map camera and enable some settings
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.0667
                                                            longitude:-89.4000
                                                                 zoom:1];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 397) camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.scrollGestures = YES;
    mapView.settings.zoomGestures = YES;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.trafficEnabled = YES;
    
    // add the map subview to the main view
    [self.view addSubview:mapView];
}





// get the commute info from the data store
-(void)fetchData
{
    // not sure what this does, but basically says the scrollview delegate is the main view
    self.scrollView.delegate = self;
    
    // initialize some arrays for storing the route info in memory once we get it from the store
    self.commuteNameArray = [NSMutableArray array];
    self.originArray = [NSMutableArray array];
    self.destinationArray = [NSMutableArray array];
    self.originZipArray = [NSMutableArray array];
    self.destinationZipArray = [NSMutableArray array];
    
    // Fetch the commute info from persistent data store, store it in commuteArray
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Commute"];
    self.commuteArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
   
    //if there are no commutes
    if (self.commuteArray.count == 0) {
        
        // if the label is currently there
        if (needToClearLabel)
        {
            // remove it
            [self.noCommuteLabel removeFromSuperview];
            needToClearLabel = false;
        }
        
        // still need one scroll page to put the 'no commute' message on
        self.pageControl.numberOfPages = 1;
        
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        // create 'no commute' UILabel and customize label text
        self.noCommuteLabel = [[UILabel alloc] initWithFrame:frame];
        self.noCommuteLabel.textColor = [UIColor whiteColor];
        self.noCommuteLabel.textAlignment = NSTextAlignmentCenter;
        self.noCommuteLabel.lineBreakMode = YES;
        self.noCommuteLabel.numberOfLines = 4;
        self.noCommuteLabel.adjustsFontSizeToFitWidth = YES;
        self.noCommuteLabel.minimumScaleFactor = 0;
        self.noCommuteLabel.userInteractionEnabled = YES;
        self.noCommuteLabel.text = @"No commutes set!\nSet a commute in the 'Commutes' tab.";
        
        // add the 'no commute' label to the scroll view
        [self.scrollView addSubview:self.noCommuteLabel];
        
        // label has been added, so need to remove it later
        needToClearLabel = true;
        
        // test value and call for showing the user's current location
        firstLocationUpdate_ = NO;
        [mapView addObserver:self
                  forKeyPath:@"myLocation"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
        
        // Show current location if there's no commutes set
        //[self showCurrentLocation];
    }
    else if (self.commuteArray.count > 0){
        
        // if the 'no commute' label needs to be removed
        if (needToClearLabel)
        {
            // remove it and mark it as renewed
            [self.noCommuteLabel removeFromSuperview];
            needToClearLabel = false;
        }
        
        // number of pages in the scroll view = number of commutes
        self.pageControl.numberOfPages = self.commuteArray.count;
        
        // for each commute, add the info into memory in each array
        for (int i=0; i < self.commuteArray.count; i++)
        {
            NSManagedObject *commute = [self.commuteArray objectAtIndex:i];
            
            [self.commuteNameArray addObject:[commute valueForKey:@"name"]];
            [self.originArray addObject:[commute valueForKey:@"startingAddress"]];
            [self.originZipArray addObject:[commute valueForKey:@"startingZip"]];
            [self.destinationArray addObject:[commute valueForKey:@"destinationAddress"]];
            [self.destinationZipArray addObject:[commute valueForKey:@"destinationZip"]];
        }
        
        // make the call to create the labels for each commute
        [self createUILabels];
    }
}




// create the uilabels for the commutes to go within the scroll view
- (void)createUILabels
{
    // initialize the label array
    self.labelArray = [NSMutableArray array];
 
    // for each commute, create the label and add it to the scroll view and the label array
    for (int i=0; i < self.commuteArray.count; i++){
            
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        // create UILabel and customize label text
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = YES;
        label.numberOfLines = 4;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0;
        label.userInteractionEnabled = YES;
        
        [self.labelArray addObject:label];
        
        [self.scrollView addSubview:label];
        
    }
    
    // make sure the content fits on the scroll view
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.commuteArray count], scrollView.frame.size.height);
    
    // when the scroll view is done loading, send the query for the first commute
    [self setOrigin:[self.originArray objectAtIndex:0]
       setOriginZip:[self.originZipArray objectAtIndex:0]
     setDestination:[self.destinationArray objectAtIndex:0]
         setDestZip:[self.destinationZipArray objectAtIndex:0]];
    
}





// page control/scrolling funcitonality
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat offset = self.scrollView.contentOffset.x;
    currentPage = floor((offset - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentPage;
    
    if ((int)floor(offset) % (int)floor(pageWidth) == 0)
    {
        // clear the routes currently drawn on the map
        [self.mapView clear];
        
        // when the page is finished being selected, send the query
        [self setOrigin:[self.originArray objectAtIndex:currentPage]
           setOriginZip:[self.originZipArray objectAtIndex:currentPage]
         setDestination:[self.destinationArray objectAtIndex:currentPage]
             setDestZip:[self.destinationZipArray objectAtIndex:currentPage]];
    }
    
}





// creates context for accessing data store
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}





/*
// Get current location
- (void)showCurrentLocation {
    mapView.myLocationEnabled = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:17.0];
    [mapView animateToCameraPosition:camera];
}

*/






// something to do with setting the camera to the user's location..?
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







// method for creating the query from the data store info
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
    
    
    // update the text of the current UIlabel page showing
    NSString *dirText = [NSString stringWithFormat:@"Commute Name: %@\nDirections: Take %@.\nDistance = %@, Duration = %@", [self.commuteNameArray objectAtIndex:currentPage],routes[@"summary"], distanceText, durationText];
    [[self.labelArray objectAtIndex:currentPage] setText:dirText];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CommutableFirstViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommutableFirstViewController.h"
#import "DirectionService.h"
#import <QuartzCore/QuartzCore.h>
#import "CommutesTableViewController.h"
#import "UIBorderLabel.h"

@interface CommutableFirstViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
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
    BOOL cameFromLocalNotification;
    bool needToClearLabel;
    int currentPage;
    BOOL authorizedLocation;
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
    
    [self updateMap];
    
}



// clear the map of any commutes and update the user's location if possible
- (void)updateMap
{
    [mapView clear];
    
    // add an observer for the user's current location
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: nil];
    
    //[self setupScrollViewBlur];
    
    // make the call to grab the data from the datastore
    [self fetchData];
}





// called when the view loads, called once at first app load (not everytime tab is opened)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // run the method to get user authorization to use their location
    [self loadMapView];
    
    // initialize waypoint arrays for storing multiple routes
    self.waypoints = [NSMutableArray array];
    self.waypointStrings = [NSMutableArray array];

}






// load the map view
- (void)loadMapView
{
    // get size of screen to dynamically size map
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenHeight = screenHeight - self.scrollView.frame.size.height - self.pageControl.frame.size.height;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:43.0667
                                                            longitude:-89.4000
                                                                 zoom:3];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) camera:camera];
    
    // call the method to ask the user for permission, enable location through there
    [self enableMyLocation];
    
    mapView.settings.scrollGestures = YES;
    mapView.settings.zoomGestures = YES;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.trafficEnabled = YES;
    
    [self.view addSubview:mapView];
    
    //[self updateMap];
}






-(void) setupScrollViewBlur {
    //commented out, because this would turn the color white until the map is a subview beneath it. 
    //self.scrollView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurredBackgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurredBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    blurredBackgroundView.frame = self.scrollView.bounds;
    [self.scrollView addSubview:blurredBackgroundView];
}





// get the commute info from the data store
-(void)fetchData
{
    // not sure what this does, but basically says the scrollview delegate is the main view
    self.scrollView.delegate = self;
    self.scrollView.autoresizesSubviews = YES;
    
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
        
        
        // possible 'fix' for the weird scroll view text auto-layout issue
        // use the mapview frame since apparently the scrollview frame doesn't update fast enough
        CGRect frame = CGRectMake(0, 0, self.mapView.frame.size.width, self.scrollView.frame.size.height);
        
        // create 'no commute' UILabel and customize label text
        self.noCommuteLabel = [[UILabel alloc] initWithFrame:frame];
        self.noCommuteLabel.textColor = [UIColor whiteColor];
        self.noCommuteLabel.textAlignment = NSTextAlignmentCenter;
        self.noCommuteLabel.lineBreakMode = YES;
        self.noCommuteLabel.numberOfLines = 4;
        self.noCommuteLabel.adjustsFontSizeToFitWidth = YES;
        self.noCommuteLabel.minimumScaleFactor = 0;
        self.noCommuteLabel.userInteractionEnabled = YES;
        self.noCommuteLabel.text = @"No commutes set!\nSet a commute with the 'Commutes'\nbutton below.";
        self.noCommuteLabel.layer.borderWidth = 0.5;
        self.noCommuteLabel.layer.borderColor = [UIColor blackColor].CGColor;
        
        // add the 'no commute' label to the scroll view
        [self.scrollView addSubview:self.noCommuteLabel];
        
        // label has been added, so need to remove it later
        needToClearLabel = true;
        
        
        // move the camera back to the user's location
        if (authorizedLocation)
        {
        //[mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude
          //                                                           longitude:mapView.myLocation.coordinate.longitude
            //                                                              zoom:5.0]];
            mapView.settings.myLocationButton = YES;
        }
        if (!authorizedLocation)
        {
            // if the user didn't authorize use of location, just center map on US geographic center
            [mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:39.0
                                                                         longitude:-98.0
                                                                              zoom:3.0]];
            mapView.settings.myLocationButton = NO;
        }
        
        
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








//display the commute based on the commute name passed in. This method may still change a lot.
- (NSInteger) displayCommute:(NSString *)commuteName {
    NSInteger commuteIndex=[self.commuteNameArray indexOfObject:commuteName];
    if(NSNotFound == commuteIndex) {
        NSLog(@"Commute not found");
        //there's probably a better way to do this.
        commuteIndex = 255;
        return commuteIndex;
    }
    else {
        cameFromLocalNotification = YES;
        currentPage = (int)commuteIndex;
        return commuteIndex;
    }
}







// create the uilabels for the commutes to go within the scroll view
- (void)createUILabels
{
    // initialize the label array
    self.labelArray = [NSMutableArray array];
 
    // for each commute, create the label and add it to the scroll view and the label array
    for (int i=0; i < self.commuteArray.count; i++){
            
        // possible 'fix' for the weird scroll view text auto-layout issue
        // use the mapview frame since apparently the scrollview frame doesn't update fast enough
        CGRect frame = CGRectMake(self.mapView.frame.size.width * i, 0, self.mapView.frame.size.width, self.scrollView.frame.size.height);
        
        // create UIBorderLabel (custom subclass of UIlabel) with padding and customize label text
        UIBorderLabel *label = [[UIBorderLabel alloc] initWithFrame:frame];
        
        // playing around with padding
        label.topInset = 5;
        label.bottomInset = 5;
        label.leftInset = 5;
        label.rightInset = 5;
        
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        //label.lineBreakMode = YES;
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        
        label.numberOfLines = 0;
        //label.adjustsFontSizeToFitWidth = YES;
        //label.minimumScaleFactor = 0;
        label.userInteractionEnabled = YES;
        
        // playing around with borders on the labels
        CALayer *rightBorder = [CALayer layer];
        rightBorder.borderColor = [UIColor blackColor].CGColor;
        rightBorder.borderWidth = 1;
        rightBorder.frame = CGRectMake(0, -1, CGRectGetWidth(label.frame), CGRectGetHeight(label.frame)+2);
        
        [label.layer addSublayer:rightBorder];
        
        
        [self.labelArray addObject:label];
        
        [self.scrollView addSubview:label];
        
    }
    
    // make sure the content fits on the scroll view
    //self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.commuteArray count], scrollView.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.mapView.frame.size.width * [self.commuteArray count], scrollView.frame.size.height);
    
    // when the scroll view is done loading, send the query for the first commute
    if (cameFromLocalNotification)
    {
        self.pageControl.currentPage = currentPage;
        
        [self setOrigin:[self.originArray objectAtIndex:currentPage]
           setOriginZip:[self.originZipArray objectAtIndex:currentPage]
         setDestination:[self.destinationArray objectAtIndex:currentPage]
             setDestZip:[self.destinationZipArray objectAtIndex:currentPage]];
        
        cameFromLocalNotification = NO;
    }
    else if (!cameFromLocalNotification)
    {
        [self setOrigin:[self.originArray objectAtIndex:0]
           setOriginZip:[self.originZipArray objectAtIndex:0]
         setDestination:[self.destinationArray objectAtIndex:0]
             setDestZip:[self.destinationZipArray objectAtIndex:0]];
    }
    
}





// page control/scrolling functionality
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





// for moving the map camera to the user's location
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"myLocation"] && [object isKindOfClass:[GMSMapView class]] && self.labelArray.count == 0)
    {
            [mapView animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView.myLocation.coordinate.latitude
                                                                                 longitude:mapView.myLocation.coordinate.longitude
                                                                                      zoom:5.0]];
    }
}





// before the view finishes, cleanup the myLocation observer
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Implement here if the view has registered KVO
    
    [mapView removeObserver:self forKeyPath:@"myLocation"];
}





/*
- (void)dealloc {
    [mapView removeObserver:self
                 forKeyPath:@"myLocation"
                    context:NULL];
}
*/






// iOS 8 location stuff
// Rather than setting -myLocationEnabled to YES directly,
// call this method:
- (void)enableMyLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [self requestLocationAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted)
    {
        authorizedLocation = NO; // we weren't allowed to show the user's location so don't enable
        mapView.myLocationEnabled = NO;
        [self updateMap];
    }
    else
    {
        authorizedLocation = YES; // allow the map to get the user's location!
        mapView.myLocationEnabled = YES;
        [self updateMap];
    }
    
    
}

// Ask the CLLocationManager for location authorization,
// and be sure to retain the manager somewhere on the class
- (void)requestLocationAuthorization
{
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // testing a threshold/accuracy setting as fix for zoom issue
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //self.locationManager.distanceFilter = 500; // meters..?
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

// Handle the authorization callback. This is usually
// called on a background thread so go back to main.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [self performSelectorOnMainThread:@selector(enableMyLocation) withObject:nil waitUntilDone:[NSThread isMainThread]];
        
        _locationManager.delegate = nil;
        _locationManager = nil;
    }
}






// method for creating the query from the data store info
- (void) setOrigin:(NSString*)origin setOriginZip:(NSString*)originZip setDestination:(NSString*)destination setDestZip:(NSString*)destZip
{
    NSDictionary *query = @{ @"sensor" : @"false",
                             @"origin" : origin,
                             @"originZip" : originZip,
                             @"destination" : destination,
                             @"destZip" : destZip};
    DirectionService *mds = [[DirectionService alloc] init];
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
    //NSDictionary *distance = legs[@"distance"];
    //NSString *distanceText = distance[@"text"];
    
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
    
    // add markers to the map for the origin and destination, include address in marker title
    GMSMarker *startMarker = [GMSMarker markerWithPosition:origin];
    startMarker.title = [self.originArray objectAtIndex:currentPage];
    GMSMarker *endMarker = [GMSMarker markerWithPosition:destination];
    endMarker.title = [self.destinationArray objectAtIndex:currentPage];
    startMarker.map = mapView;
    endMarker.map = mapView;
    
    // draw the direction line
    NSDictionary *route = routes[@"overview_polyline"];
    NSString *overview_route = route[@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 5;
    polyline.zIndex = 1;
    polyline.map = mapView;
    
    // focus camera on route (still working on this..). It's being overruled by the method that's focusing on your location I believe
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [mapView moveCamera:update];
    
    // update the text of the current UIlabel page showing
    NSString *dirText = [NSString stringWithFormat:@"Current Commute: %@\nIf you take %@ today, it should only take you %@.\nDrive safe!", [self.commuteNameArray objectAtIndex:currentPage],routes[@"summary"], durationText];
    [[self.labelArray objectAtIndex:currentPage] setText:dirText];
}






//for passing current location info to next screen
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //NSLog(@"preparing for segue");
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    CommutesTableViewController *controller = (CommutesTableViewController *)navController.topViewController;
    controller.currentLocationDictionary = [self getCurrentLocationAddress];
    controller.authorizedLocation = authorizedLocation;
}




// get the current location by calling the reverse geocoding api with the current coordinates; returns a dictionary of the json query result
-(NSDictionary*)getCurrentLocationAddress
{
    static NSString *coordToAddressString = @"https://maps.googleapis.com/maps/api/geocode/json?latlng"; // begin reverse geocoding api URL query string
    NSString *currentLat = [NSString stringWithFormat:@"%g", mapView.myLocation.coordinate.latitude];
    NSString *currentLong = [NSString stringWithFormat:@"%g", mapView.myLocation.coordinate.longitude];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@=%@,%@", coordToAddressString, currentLat, currentLong];
    
    url = [[url
            stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding] mutableCopy]; // turn the query into a viable URL with %20 escapes for spaces, etc
    
    //NSLog(@"URL: %@", url);
    
    NSURL* coordToAddressURL = [NSURL URLWithString:url]; // turn the finshed URL query into the global variable of type NSURL
    
    NSData* data = [NSData dataWithContentsOfURL:coordToAddressURL]; // create a data variable to store the return, make the call
    
    NSError* error;
    NSDictionary *tempDict = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error]; // read the JSON return into a dictionary
    
    
    
    return tempDict;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

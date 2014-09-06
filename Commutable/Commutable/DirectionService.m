//
//  DirectionService.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "DirectionService.h"

@interface DirectionService()
@property (assign, nonatomic) BOOL sensor;
@property (assign, nonatomic) BOOL alternatives;
@property (strong, nonatomic) NSURL *directionsURL;
@property (strong, nonatomic) NSArray *waypoints;
@end

@implementation DirectionService

static NSString *directionsURL = @"http://maps.googleapis.com/maps/api/directions/json?"; // directions api URL query string

// method to set the directions query
// accepts arguments: dictionary query, selector, and delegate
// no return value
- (void)setDirectionsQuery:(NSDictionary *)query
              withSelector:(SEL)selector
              withDelegate:(id)delegate
{
    //NSArray *waypoints = query[@"waypoints"]; // grab the waypoint coords from the query argument (called from CommutableFirstViewController.m
    NSString *origin = query[@"origin"]; // get the route origin from the parameters
    NSString *originZip = query[@"originZip"];
    NSString *destination = query[@"destination"]; // grab the destination from the parameters
    NSString *destZip = query[@"destZip"];
    NSString *sensor = query[@"sensor"]; // get sensor info from the query. sensor is used to tell Google Maps you're using a 'sensor' to locate the user. fine to be false.
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&origin=%@, %@&destination=%@, %@&sensor=%@",
            directionsURL, origin, originZip, destination, destZip, sensor]; // start building the url with the origin, destination, and sensor info extracted from the query
    

    url = [[url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding] mutableCopy]; // turn the query into a viable URL with %20 escapes for spaces, etc
    
    _directionsURL = [NSURL URLWithString:url]; // turn the finshed URL query into the global variable of type NSURL
    
    
    // call the retrieveDirections method with the selector and delegate arguments
    // selector is of type SEL that points to the addDirections method during the call. It must be somthing like it points to what gets called when data is returned..?
    // delegate is the google maps View itself (I think..? it's set to SELF in the call). Still trying to understand this one..
    [self retrieveDirections:selector
                withDelegate:delegate];
}



// retrieve directions method that grabs the JSON output that the URL query call returns
// takes arguments: selector (the addDirections method), delegate (the maps View[?])
- (void)retrieveDirections:(SEL)selector
              withDelegate:(id)delegate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL:_directionsURL]; // create a data variable to store the return, make the call
        [self fetchedData:data withSelector:selector withDelegate:delegate]; // call fetched data to read in the JSON output
    });
}


// method that fetches the JSON output and stores it to a dictionary object
- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate
{
   
  NSError* error;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:data
                                   options:kNilOptions
                                     error:&error]; // read the JSON return into a dictionary
    
    // call the method the selector is pointing to (addDirections) and pass in the JSON return dictionary as a parameter
    // the pragmas silence a warning about a possible memory leak, which i don't think is possible so hopefully this is a fine solution
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate performSelector:selector withObject:json];
    #pragma clang diagnostic pop
}

@end

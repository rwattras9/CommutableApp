//
//  DirectionService.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectionService : NSObject

// method that takes the inputted info and creates a directions query
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;

// method that retrieves directions by running the query as a URL calling the Google Maps Directions API
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;

// method that fetches the info from the API call and saves it to a JSON dictionary
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;

@end

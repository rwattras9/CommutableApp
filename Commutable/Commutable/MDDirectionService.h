//
//  MDDirectionService.h
//  MapsDirections
//
//  Created by Mano Marks on 4/8/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDirectionService : NSObject

// method that takes the inputted info and creates a directions query
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;

// method that retrieves directions by running the query as a URL calling the Google Maps Directions API
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;

// 
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;

@end

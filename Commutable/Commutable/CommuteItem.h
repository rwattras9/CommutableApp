//
//  CommuteItem.h
//  Commutable
//
//  Created by Edward Damisch on 5/10/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommuteItem : NSObject

@property NSString *commuteName;
//Rather than passing LocationItem properties to these variables, we could just reference the location objects in the locations Array. It would probably be cleaner and better code.
@property NSString *commuteStartingAddress;
@property NSString *commuteStartingZipCode;
@property NSString *commuteDestinationAddress;
@property NSString *commuteDestinationZipCode;
@property NSDate *alertTime;
//Need to add a property for the alert schedule and alert time.




@end

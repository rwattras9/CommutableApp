//
//  LocationCreatorViewController.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationItem.h"


@interface LocationCreatorViewController : UIViewController

@property LocationItem *locationItem;
@property (strong) NSManagedObject *location;

@end

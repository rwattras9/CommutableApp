//
//  CommutesTableViewController.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommutesTableViewController : UITableViewController

// added by Rick for passing current location info
@property (strong) NSDictionary *currentLocationDictionary;
@property (assign) BOOL authorizedLocation;


-(IBAction)unwindToCommutesTable:(UIStoryboardSegue *)segue;

//declare an array that will contain the name of the commutes
@property (nonatomic, strong) NSMutableArray *commuteArray;

@end

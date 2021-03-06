//
//  CommuteCreatorTableViewController.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommuteItem.h"

@interface CommuteCreatorTableViewController : UITableViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *existingStartingLocation;
@property (strong, nonatomic) IBOutlet UIPickerView *existingStartingLocationsPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *existingDestinationLocationsPicker;
@property (strong, nonatomic) IBOutlet UILabel *recurrenceLabel;
@property (strong, nonatomic) IBOutlet UILabel *commuteNameLabel;

@property CommuteItem *commuteItem;
@property (strong) NSManagedObject *commute;

// added by Rick for passing current location info
@property (strong) NSDictionary *currentLocationDictionary;
@property (assign) BOOL authorizedLocation;

//Unwind Transition to go back to CommuteCreatorTableViewController
- (IBAction)unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue;

- (IBAction)unwindFromRecurrenceToCommuteCreatorTable:(UIStoryboardSegue *)segue;

- (IBAction)unwindFromCommuteNameToCommuteCreatorTable:(UIStoryboardSegue *)segue;

@end

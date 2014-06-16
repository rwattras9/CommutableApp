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

@property CommuteItem *commuteItem;
@property (strong) NSManagedObject *commute;

//Unwind Transition to go back to CommuteCreatorTableViewController
- (IBAction)unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue;

- (IBAction)unwindFromRecurrenceToCommuteCreatorTable:(UIStoryboardSegue *)segue;

@end

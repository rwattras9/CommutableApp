//
//  CommuteCreatorTableViewController.h
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommuteCreatorTableViewController : UITableViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *existingStartingLocation;
@property (strong, nonatomic) IBOutlet UIPickerView *existingStartingLocationsPicker;

//Unwind Transition to go back to CommuteCreatorTableViewController
- (IBAction)unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue;
<<<<<<< HEAD

//Unwind Transition to go back to CommuteCreatorTableViewController
- (IBAction)unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue;
=======
>>>>>>> FETCH_HEAD

@end

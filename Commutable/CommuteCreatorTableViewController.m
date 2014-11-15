//
//  CommuteCreatorTableViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommuteCreatorTableViewController.h"
#import "LocationItem.h"
#import "LocationCreatorViewController.h"
#import "RepeatScheduleTableViewController.h"
#import "CommuteNameViewController.h"

#define kDatePickerIndex 1
#define kDatePickerCellHeight 216

@interface CommuteCreatorTableViewController ()

@property (strong, nonatomic) IBOutlet UITextField *commuteNameTextField;
@property NSMutableArray *locationsArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commuteCreatorDoneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commuteCreatorCancelButton;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *alertTime;
@property (strong, nonatomic) IBOutlet UILabel *alertTimeLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *alertTimeDatePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *alertTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *startingLocationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *destinationLocationCell;
@property (strong, nonatomic) IBOutlet UILabel *startingLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinationLocationLabel;
@property (strong, nonatomic) NSMutableArray *recurrenceScheduleArray;

@property (nonatomic) BOOL sendAlert;
@property (strong, nonatomic) IBOutlet UISwitch *sendAlertSwitch;

@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL startingLocationPickerIsShowing;
@property (assign) BOOL destinationLocationPickerIsShowing;
@property (strong, nonatomic) IBOutlet UIButton *editStartingLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *editDestinationLocationButton;
@property (strong, nonatomic) IBOutlet UILabel *startingTapToChooseLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinationTapToChooseLabel;
@property (assign) BOOL startingLocationPickerWasUsed;
@property (assign) BOOL destinationLocationPickerWasUsed;
@property (assign) BOOL alertTimeDatePickerWasUsed;

- (NSString *)convertToWeekDayNames:(NSMutableArray*)recurrenceScheduleArray;
- (void)cancelLocalNotification:(NSString*)notificationID;


@end

@implementation CommuteCreatorTableViewController
@synthesize commute;
@synthesize currentLocationDictionary;
@synthesize authorizedLocation;

- (IBAction)sendAlert:(id)sender {
    
    
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [sender resignFirstResponder];
}

/*Need to subclass UITableView to make this work
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"The keyboard should be going away now");
    if ([_commuteNameTextField isFirstResponder] && [touch view] != _commuteNameTextField ) {
        
        [_commuteNameTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}*/

//Only works for tap gestures. Except it doesn't, because it makes all other taps fail
/*- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    // your code goes here...
    [_commuteNameTextField resignFirstResponder];

}*/

//Get the time selected from the UIDatePicker

- (IBAction)alertTimeDatePicker:(UIDatePicker *)sender {
    self.alertTime = sender.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *prettyVersion = [dateFormatter stringFromDate:self.alertTime];
    //NSLog(@"The selected time is %@", prettyVersion);
    self.alertTimeLabel.text = [NSString stringWithFormat:@"%@", prettyVersion];
    self.alertTimeLabel.textColor = [UIColor blackColor];
    
}
//Sets the default value of Alert Date Picker
- (void)setupAlertTimeLabel {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *defaultDate = [NSDate date];
    
    self.alertTimeLabel.text = [self.dateFormatter stringFromDate:defaultDate];
    self.alertTimeLabel.textColor = [self.tableView tintColor];
    
    self.alertTime = defaultDate;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.tableView.rowHeight;
    //NSLog(@"The height is %f", height);
    //modification
    if (indexPath.section == 3) {
        
        if (indexPath.row == kDatePickerIndex){
            
            height = self.datePickerIsShowing ? kDatePickerCellHeight : 0.0f;
            
        }
        return height;
    }
    else {
        if (indexPath.section == 0) {
            return height;
        }
        else if (indexPath.section == 1){
            if (indexPath.row == kDatePickerIndex){
                
                height = self.startingLocationPickerIsShowing ? kDatePickerCellHeight : 0.0f;
                
                /*if (indexPath.row == 0){
                 
                 height = 216;
                 return height;*/
                
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == kDatePickerIndex){
                
                height = self.destinationLocationPickerIsShowing ? kDatePickerCellHeight : 0.0f;
                
                /*if (indexPath.row == 0){
                 
                 height = 216;
                 return height;*/
                
            }
        }
        return height;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //modification
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0){
            
            if (self.datePickerIsShowing){
                
                [self hideDatePickerCell];
                
            }else {
                
                [self showDatePickerCell];
            }
        }}
    else if (indexPath.section == 1){
        if (indexPath.row == 0){
            if (self.startingLocationPickerIsShowing){
                
                [self hideStartingLocationPickerCell];
                
            }else {
                
                [self showStartingLocationPickerCell];
            }
        }
        
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0){
            if (self.destinationLocationPickerIsShowing){
                
                [self hideDestinationLocationPickerCell];
                
            }else {
                
                [self showDestinationLocationPickerCell];
            }
        }
        
    }
    
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.alertTimeDatePicker.hidden = NO;
    self.alertTimeDatePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alertTimeDatePicker.alpha = 1.0f;
        
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alertTimeDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.alertTimeDatePicker.hidden = YES;
                     }];
}

- (void)showStartingLocationPickerCell {
    
    self.startingLocationPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.existingStartingLocationsPicker.hidden = NO;
    self.existingStartingLocationsPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.existingStartingLocationsPicker.alpha = 1.0f;
        
    }];
}

- (void)hideStartingLocationPickerCell {
    
    self.startingLocationPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.existingStartingLocationsPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.existingStartingLocationsPicker.hidden = YES;
                     }];
}

- (void)showDestinationLocationPickerCell {
    
    self.DestinationLocationPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.existingDestinationLocationsPicker.hidden = NO;
    self.existingDestinationLocationsPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.existingDestinationLocationsPicker.alpha = 1.0f;
        
    }];
}

- (void)hideDestinationLocationPickerCell {
    
    self.DestinationLocationPickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.existingDestinationLocationsPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.existingDestinationLocationsPicker.hidden = YES;
                     }];
}


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//get location data from Core Data
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    self.locationsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    //if the locationsArray is empty (no locations exist), hide the Edit Location button, set text to Please Add a Location
    if (!self.locationsArray || !self.locationsArray.count){
        //moved the below to ViewDidLoad
        self.editStartingLocationButton.hidden = YES;
        self.editDestinationLocationButton.hidden = YES;
        self.startingTapToChooseLabel.hidden = YES;
        self.destinationTapToChooseLabel.hidden = YES;
        self.startingLocationLabel.text = @"Add a Location";
        self.destinationLocationLabel.text = @"Add a Location";
        //need to disable expansion
        self.startingLocationCell.userInteractionEnabled = NO;
        self.destinationLocationCell.userInteractionEnabled = NO;
        [self hideStartingLocationPickerCell];
        [self hideDestinationLocationPickerCell];
    }
    else {
        self.startingTapToChooseLabel.hidden = NO;
        self.destinationTapToChooseLabel.hidden = NO;
        self.destinationLocationCell.userInteractionEnabled = YES;
        self.startingLocationCell.userInteractionEnabled = YES;
    }
    
    [self.existingStartingLocationsPicker reloadAllComponents];
    [self.existingDestinationLocationsPicker reloadAllComponents];
}

/*I want to use this to find the index of a certain object
 for (id locationObject in self.locationsArray){
 
 if ([locationObject valueForKey:@"name"] == locationName) {
 NSInteger selectedLocationIndex=[self.locationsArray indexOfObject:locationObject];
 }
 }*/


//old method to pass data to List of Locations
- (IBAction) unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue
{
    
}


//Method to convert array of numbers into a string of weekdays for label
- (NSString *)convertToWeekDayNames:(NSMutableArray*)recurrenceScheduleArray {
    
    //By default, the commute will never reccur, and the label should say that
    NSString *weekdayString = @"Never";
    
    NSMutableArray *weekdayArray = [[NSMutableArray alloc] init];
    
    for (id dayOfTheWeek in _recurrenceScheduleArray) {
        NSLog(@"The day is %@", dayOfTheWeek);
        if ([dayOfTheWeek integerValue] == 0){
            [weekdayArray addObject:@"Sun"];
        }
        else if ([dayOfTheWeek integerValue] == 1) {
            [weekdayArray addObject:@"Mon"];
        }
        else if ([dayOfTheWeek integerValue] == 2) {
            [weekdayArray addObject:@"Tues"];
        }
        
        else if ([dayOfTheWeek integerValue] == 3) {
            [weekdayArray addObject:@"Wed"];
        }
        else if ([dayOfTheWeek integerValue] == 4) {
            [weekdayArray addObject:@"Thurs"];
        }
        else if ([dayOfTheWeek integerValue] == 5) {
            [weekdayArray addObject:@"Fri"];
        }
        else if ([dayOfTheWeek integerValue] == 6) {
            [weekdayArray addObject:@"Sat"];
        }
 
        NSLog(@"The weekdays are %@", weekdayArray);
        
        
        //if array is empty, set weekdayString to "Never"
        if (!weekdayArray || !weekdayArray.count){
            weekdayString = @"Never";}
        else {
            weekdayString = [[weekdayArray valueForKey:@"description"] componentsJoinedByString:@" "];
            
        }
        
    }
    return weekdayString;
}
- (void)cancelLocalNotification:(NSString*)notificationID {
    NSLog(@"The method was called");
    //loop through all scheduled notifications and cancel the one we're looking for
    UILocalNotification *cancelThisNotification = nil;
    //BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"The value of someNotification's userinfo is %@", someNotification.userInfo);
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID]) {
            NSLog(@"The conditions are true");
            cancelThisNotification = someNotification;
            NSLog(@"The firedate of the notification being canceled is %@",cancelThisNotification.fireDate);
            //hasNotification = YES;
            //break;
            //if (hasNotification == YES) {
                NSLog(@"%@ ",cancelThisNotification);
                [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
                //hasNotification = NO;
            //}
        }
    }
    /*if (hasNotification == YES) {
        NSLog(@"%@ ",cancelThisNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
    }*/
}

- (IBAction)unwindFromRecurrenceToCommuteCreatorTable:(UIStoryboardSegue *)segue {
    RepeatScheduleTableViewController *source = [segue sourceViewController];
    self.recurrenceScheduleArray = source.recurranceDays;
    if (_recurrenceScheduleArray != nil) {
        
        /*NSMutableArray *weekdayArray = [[NSMutableArray alloc] init];
        //TO DO: update recurrence label
        for (id dayOfTheWeek in _recurrenceScheduleArray) {
        NSLog(@"The day is %@", dayOfTheWeek);
            if (dayOfTheWeek == 0){
                [weekdayArray addObject:@"Sun"];
            }
            else if ([dayOfTheWeek integerValue] == 1) {
                [weekdayArray addObject:@"Mon"];
            }
            else if ([dayOfTheWeek integerValue] == 2) {
                [weekdayArray addObject:@"Tues"];
            }
            
            else if ([dayOfTheWeek integerValue] == 3) {
                [weekdayArray addObject:@"Wed"];
            }
            else if ([dayOfTheWeek integerValue] == 4) {
                [weekdayArray addObject:@"Thurs"];
            }
            else if ([dayOfTheWeek integerValue] == 5) {
                [weekdayArray addObject:@"Fri"];
            }
            else if ([dayOfTheWeek integerValue] == 6) {
                [weekdayArray addObject:@"Sat"];
            }
            
        }
        //TO DO: Add recurrence schedule array to Commute Properties somehow or something
        NSLog(@"The weekdays are %@", weekdayArray);
        NSString *weekdayString = [[weekdayArray valueForKey:@"description"] componentsJoinedByString:@" "];
        */
        NSString *weekdayString = [self convertToWeekDayNames:self.recurrenceScheduleArray];
        self.recurrenceLabel.text = weekdayString;
    }
    
}
- (IBAction)unwindFromCommuteNameToCommuteCreatorTable:(UIStoryboardSegue *)segue {
    CommuteNameViewController *source = [segue sourceViewController];
    // if value isn't nil...
    if ([source.commuteNameTextField.text isEqual: @""]) {
        //do nothing
    }
    else {
        self.commuteNameLabel.text = source.commuteNameTextField.text;
        self.commuteNameLabel.textColor = [UIColor blackColor];
    }
}


- (void) loadInitialData {
    
}

//States whether the segue should be performed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //Do nothing if it isn't the save button that triggers the segue
    if (sender != self.commuteCreatorDoneButton) return YES;
    else{
        
        BOOL performSegue = YES;
        
        if ([self.commuteNameLabel.text  isEqual: @"Name"]) {
            self.commuteNameLabel.textColor = [UIColor redColor];
            performSegue = NO;
        }
        
        //if we are creating a new commute, check to see if the UI pickers have been used
        if (!self.commute) {
            //if the starting location picker wasn't used for a new commute, don't perform the segue and tell user to select a starting point
            if (self.startingLocationPickerWasUsed == NO) {
                self.startingLocationLabel.textColor = [UIColor redColor];
                performSegue = NO;
            }
            if (self.destinationLocationPickerWasUsed == NO) {
                self.destinationLocationLabel.textColor = [UIColor redColor];
                performSegue = NO;
            }
            if ([self.alertTimeLabel.text isEqual: @"Alert Time"]) {
                self.alertTimeLabel.textColor = [UIColor redColor];
                performSegue = NO;
            }
        }
        return performSegue;
        
        //check to see if notifications are being allowed. 
        UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        NSLog(@"The current notification settings are: %@", currentSettings);
        
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check to see if it was the Done or Cancel button that was tapped
    if (sender == self.commuteCreatorCancelButton) return;
    
    //if sender is cancel, return (don't save, update, do anything
    //done
    //if sender is done button, update or create
    //done
    //if sender is edit button, pass location information
    //done
    //if sender is add button, load location creator
    //done
    //if sender is recurrence schedule cell, pass recurrence array
    //done
    
    //if the segue is EditCommuteName, pass the commute name to the CommuteNameViewController
    if ([[segue identifier] isEqualToString:@"editCommuteName"]){
        CommuteNameViewController *destViewController =segue.destinationViewController;
        //NSString *commuteName = [[NSString alloc] init];
        //commuteName = self.commuteNameLabel.text;
        destViewController.commuteName = self.commuteNameLabel.text;
        NSLog(@"the source text field is %@", self.commuteNameLabel.text);
        NSLog(@"text field is %@", destViewController.commuteName);
    }
    
    //if the segue is recurrenceEditor, pass the recurrence schedule to the recurrence schedule view controller
    if ([[segue identifier] isEqualToString:@"recurrenceEditor"]) {
        RepeatScheduleTableViewController *destViewController = segue.destinationViewController;
        destViewController.recurranceDays = self.recurrenceScheduleArray;
    }
    
    
    //if sender is  starting location edit button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"EditStartingLocation"]) {
        NSManagedObject *selectedLocation = [self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]];
        NSLog(@"The selected Location is %@", selectedLocation);
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        destViewController.location = selectedLocation;
        
        // added by Rick for passing current location
        destViewController.currentLocationDictionary = currentLocationDictionary;
        destViewController.authorizedLocation = authorizedLocation;
        
    }
    
    //if sender is destination location edit button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"EditDestinationLocation"]) {
        NSManagedObject *selectedLocation = [self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]];
        NSLog(@"The selected Location is %@", selectedLocation);
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        destViewController.location = selectedLocation;
        
        // added by Rick for passing current location
        destViewController.currentLocationDictionary = currentLocationDictionary;
        destViewController.authorizedLocation = authorizedLocation;
    }
    
    //if sender is  starting location add button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"StartingLocationEditor"]) {
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        
        // added by Rick for passing current location
        destViewController.currentLocationDictionary = currentLocationDictionary;
        destViewController.authorizedLocation = authorizedLocation;
        
    }
    
    //if sender is  destination location add button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"DestinationLocationEditor"]) {
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        
        // added by Rick for passing current location
        destViewController.currentLocationDictionary = currentLocationDictionary;
        destViewController.authorizedLocation = authorizedLocation;
        
    }
    
    if (sender == self.commuteCreatorDoneButton) {
        //The single condition is a placeholder until I get full error handling in.
        //THIS CONDITION NEEDS TO BE FIXED
        if (self.commuteNameLabel.text.length > 0) {
            
            NSManagedObjectContext *context = [self managedObjectContext];
            //update a Commute if the commute exists
            if (self.commute){
                
                //update name
                [self.commute setValue:self.commuteNameLabel.text forKey:@"name"];
                
                //update recurrence schedule
                [self.commute setValue:self.recurrenceScheduleArray forKey:@"recurrenceDays"];
                
                //if the starting location has been updated, then update in Core Data.
                if (self.startingLocationPickerWasUsed == YES){
                    
                    //update starting location name
                    [self.commute setValue:self.startingLocationLabel.text forKey:@"startingLocationName"];
                    
                    //update starting address
                    [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"startingAddress"];
                    
                    //update starting zip
                    [self.commute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"startingZip"];
                    
                }
                
                //if the destination location has been updated, then update in Core Data.
                if (self.destinationLocationPickerWasUsed == YES) {
                    //update the destination location name
                    [self.commute setValue:self.destinationLocationLabel.text forKey:@"destinationLocationName"];
                    
                    //update destination address
                    [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"destinationAddress"];
                    //update destination zip
                    [self.commute setValue:self.commuteItem.commuteDestinationZipCode = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"destinationZip"];
                    
                }
                
                [self.commute setValue:self.alertTime forKey:@"alertTime"];
                
                //create Local Notification for this commute.
                //only if Send Alert Switch is on
                if (_sendAlertSwitch.on == YES) {
                    
                    //cancel previous notifications
                    [self cancelLocalNotification:[self.commute valueForKey:@"name"]];
                    
                    [self.commute setValue:@YES forKey:@"sendAlert"];
                    
                    NSMutableArray *repeatIntervalDays = [[NSMutableArray alloc] init];
                    //convert items in recurrenceScheduleArray to ints, add 1
                    for (id dayOfTheWeek in _recurrenceScheduleArray) {
                        int intValue = (int)[dayOfTheWeek integerValue];
                        intValue = intValue + 1;
                        NSNumber *repeatDay = [NSNumber numberWithInt:intValue];
                        [repeatIntervalDays addObject:repeatDay];
                    }
                    
                    NSDate *fireTime = [commute valueForKey:@"alertTime"];
                    NSLog(@"The fireTime is %@", fireTime);
                    
                    //interate through the repeatIntervalDays and schedule a local notification for each
                    for (id dayOfTheWeek in repeatIntervalDays) {
                        UILocalNotification *commuteNotification = [[UILocalNotification alloc] init];
                        NSCalendar *gregCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponent = [gregCalendar components:NSCalendarUnitYear  | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
                        
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSDateComponents *fireTimeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:fireTime];
                        NSInteger hour = [fireTimeComponents hour];
                        NSInteger minute = [fireTimeComponents minute];
                        
                        int weekDay = (int)dayOfTheWeek;
                        
                        [dateComponent setWeekday:weekDay];
                        [dateComponent setHour:hour];
                        [dateComponent setMinute:minute];
                        
                        NSDate *fireDate = [gregCalendar dateFromComponents:dateComponent];
                        
                        commuteNotification.fireDate = fireDate;
                        
                        //notification should repeat weekly
                        commuteNotification.repeatInterval = NSCalendarUnitWeekOfYear;
                        
                        //calculate time of day
                        NSString *timeOfDay = [[NSString alloc] init];
                        if(hour >= 0 && hour < 12) {
                            timeOfDay = @"morning";
                        }
                        else if(hour >= 12 && hour < 17) {
                            timeOfDay = @"afternoon";
                        }
                        else if(hour >= 17){
                            timeOfDay = @"evening";
                        }
                        
                        //Change variable one depending on time of day.
                        commuteNotification.alertBody = [NSString stringWithFormat:@"Good %@, your commute information is ready!", timeOfDay];
                        commuteNotification.soundName = UILocalNotificationDefaultSoundName;
                        
                        //store the name of the commute along with the local notification so that deleting and rescheduling will be easier later
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[self.commute valueForKey:@"name"] forKey:@"notificationID"];
                        
                        commuteNotification.userInfo = infoDict;
                        
                        [[UIApplication sharedApplication] scheduleLocalNotification:commuteNotification];
                        
                    }
                    
                }
                else {
                    [self.commute setValue:@NO forKey:@"sendAlert"];
                    //Use this method to cancel Specific Notification with that Notification Id
                [self cancelLocalNotification:[self.commute valueForKey:@"name"]];

                }
                
            } else {
                
                //create a new Commute
                
                // Create a new managed object
                NSManagedObject *newCommute = [NSEntityDescription insertNewObjectForEntityForName:@"Commute" inManagedObjectContext:context];
                
                //Set Commute Name
                [newCommute setValue:self.self.commuteNameLabel.text forKey:@"name"];
                
                //Set the Starting Location Name
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"name"] forKey:@"startingLocationName"];
                
                //Set Starting Address
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"startingAddress"];
                NSLog(@"The value of commuteStartingAddress is %@", [newCommute valueForKey:@"startingAddress"]);
                
                //Set Starting Zip
                [newCommute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"startingZip"];
                
                //Set Destination Location Name
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"name"] forKey:@"destinationLocationName"];
                
                //Set Destination Address
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"destinationAddress"];
                NSLog(@"The value of commuteDestinationAddress is %@", [newCommute valueForKey:@"destinationAddress"]);
                
                //Set Destination Zip
                [newCommute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"destinationZip"];
                
                //Set Alert Time
                [newCommute setValue:self.alertTime forKey:@"alertTime"];
                NSLog(@"The value of alertTime is %@", [newCommute valueForKey:@"alertTime"]);
                
                //Set recurrence days
                [newCommute setValue:self.recurrenceScheduleArray forKey:@"recurrenceDays"];
                
                //If the sendAlert switch is on, create a local notification and store switch status in Core Data
                if (_sendAlertSwitch.on == YES){
                    
                    //cancel all previous notifications. Just kidding. This isn't necessary.
                    [self cancelLocalNotification:[newCommute valueForKey:@"name"]];
                    
                    [newCommute setValue:@YES forKey:@"sendAlert"];
                    
                    NSMutableArray *repeatIntervalDays = [[NSMutableArray alloc] init];
                    //convert items in recurrenceScheduleArray to ints, add 1
                    for (id dayOfTheWeek in _recurrenceScheduleArray) {
                        int intValue = (int)[dayOfTheWeek integerValue];
                        intValue = intValue + 1;
                        NSNumber *repeatDay = [NSNumber numberWithInt:intValue];
                        [repeatIntervalDays addObject:repeatDay];
                    }
                    
                    NSDate *fireTime = [newCommute valueForKey:@"alertTime"];
                    NSLog(@"The fireTime is %@", fireTime);
                    
                    //interate through the repeatIntervalDays and schedule a local notification for each
                    for (id dayOfTheWeek in repeatIntervalDays) {
                        UILocalNotification *commuteNotification = [[UILocalNotification alloc] init];
                        NSCalendar *gregCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *dateComponent = [gregCalendar components:NSCalendarUnitYear  | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
                    
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSDateComponents *fireTimeComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:fireTime];
                        NSInteger hour = [fireTimeComponents hour];
                        NSInteger minute = [fireTimeComponents minute];
                     
                        int weekDay = (int)dayOfTheWeek;
                     
                        [dateComponent setWeekday:weekDay];
                        [dateComponent setHour:hour];
                        [dateComponent setMinute:minute];
                     
                        NSDate *fireDate = [gregCalendar dateFromComponents:dateComponent];
                    
                        commuteNotification.fireDate = fireDate;
                    
                        //notification should repeat weekly
                        commuteNotification.repeatInterval = NSCalendarUnitWeekOfYear;
                        
                        //calculate time of day
                        NSString *timeOfDay = [[NSString alloc] init];
                        if(hour >= 0 && hour < 12) {
                            timeOfDay = @"morning";
                        }
                        else if(hour >= 12 && hour < 17) {
                            timeOfDay = @"afternoon";
                        }
                        else if(hour >= 17){
                            timeOfDay = @"evening";
                        }
                        
                        //Change variable one depending on time of day.
                        commuteNotification.alertBody = [NSString stringWithFormat:@"Good %@, your commute information is ready!", timeOfDay];
                        commuteNotification.soundName = UILocalNotificationDefaultSoundName;
                        
                        //store the name of the commute along with the local notification so that deleting and rescheduling will be easier later
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:_commuteNameLabel.text forKey:@"notificationID"];
                        NSLog(@"The new commute's infoDict is %@", infoDict);
                        commuteNotification.userInfo = infoDict;
                        [[UIApplication sharedApplication] scheduleLocalNotification:commuteNotification];
                        
                        
                    
                    }
                    
                    
                    
                    //UILocalNotification *commuteNotification = [[UILocalNotification alloc] init];
                    
                    
                    
                    
                    
                    //commuteNotification.fireDate = [commute valueForKey:@"alertTime"];
                    
                    /*
                    
                    //notification should repeat weekly
                    commuteNotification.repeatInterval = NSWeekCalendarUnit;
                    
                    //calculate time of day
                    NSString *timeOfDay = [[NSString alloc] init];
                    if(hour >= 0 && hour < 12) {
                        timeOfDay = @"morning";
                    }
                    else if(hour >= 12 && hour < 17) {
                        timeOfDay = @"afternoon";
                    }
                    else if(hour >= 17){
                        timeOfDay = @"evening";
                    }
                    
                    //Change variable one depending on time of day.
                    commuteNotification.alertBody = [NSString stringWithFormat:@"Good %@, your commute information is ready!", timeOfDay];
                    commuteNotification.soundName = UILocalNotificationDefaultSoundName;
                    [[UIApplication sharedApplication] scheduleLocalNotification:commuteNotification];*/
                }
                //Otherwise, set switch status to off in Core Data
                else {
                    [newCommute setValue:@NO forKey:@"sendAlert"];
                    //and because it's new, we don't need to cancel
                }
                
            }
            
            
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
        }}
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[[UITableView appearance] setBackgroundColor:[self colorWithHexString:@"FFCC96"]];
    
    self.locationsArray = [[NSMutableArray alloc] init];
    
    self.startingLocationPickerWasUsed = NO;
    self.destinationLocationPickerWasUsed = NO;
    self.alertTimeDatePickerWasUsed = NO;
    
    self.editStartingLocationButton.hidden = YES;
    self.editDestinationLocationButton.hidden = YES;
    
    //populate fields with commute properties from the prepareForSegue in CommutesTableViewController
    if (self.commute){
        //populate commuteNameTextField with value of selected commute from Commutes Table
        [self.commuteNameLabel setText:[self.commute valueForKey:@"name"]];
        //Set the locations
        [self.startingLocationLabel setText:[self.commute valueForKey:@"startingLocationName"]];
        [self.destinationLocationLabel setText:[self.commute valueForKey:@"destinationLocationName"]];
        
        //Set sendAlertSwitch to correct status
        self.sendAlert = [[self.commute valueForKey:@"sendAlert"] boolValue];
        
        if (self.sendAlert == NO) {
            _sendAlertSwitch.on = NO;
        }
        
        else {
        
        _sendAlertSwitch.on = YES;
        }
        
        //set the recurrence schedule
        self.recurrenceScheduleArray = [self.commute valueForKey:@"recurrenceDays"];
        
        if (_recurrenceScheduleArray != nil) {
            NSString *weekdayString = [self convertToWeekDayNames:self.recurrenceScheduleArray];
            self.recurrenceLabel.text = weekdayString;
        }
    }
    
    /*UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];*/
    
    //[self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _locationsArray.count;
}

//
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //this returns the objects, not the locationName property
    return [[self.locationsArray objectAtIndex:row] valueForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.existingStartingLocationsPicker){
        _startingLocationLabel.text = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"name"];
        //a value was selected
        self.startingLocationPickerWasUsed = YES;
        self.startingLocationLabel.textColor = [UIColor blackColor];
        //if an item is selected, show the edit button
        self.editStartingLocationButton.hidden = NO;
    }
    else if (pickerView == self.existingDestinationLocationsPicker){
        NSLog(@"The destination location row is %ld", (long)row);
        _destinationLocationLabel.text = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"name"];
        //a value was selected
        self.destinationLocationPickerWasUsed = YES;
        self.destinationLocationLabel.textColor = [UIColor blackColor];
        //if an item is selected, show the edit button
        self.editDestinationLocationButton.hidden = NO;
    }
    
}

@end

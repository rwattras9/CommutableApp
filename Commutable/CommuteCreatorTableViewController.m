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


@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL startingLocationPickerIsShowing;
@property (assign) BOOL destinationLocationPickerIsShowing;


@end

@implementation CommuteCreatorTableViewController
@synthesize commute;

- (IBAction)dismissKeyboard:(id)sender {
    
    [sender resignFirstResponder];
}

//Get the time selected from the UIDatePicker

- (IBAction)alertTimeDatePicker:(UIDatePicker *)sender {
    self.alertTime = sender.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *prettyVersion = [dateFormatter stringFromDate:self.alertTime];
    //NSLog(@"The selected time is %@", prettyVersion);
    self.alertTimeLabel.text = [NSString stringWithFormat:@"%@", prettyVersion];
    //To do: Set the alert time to a commute property.
    
    
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
    
    [self.existingStartingLocationsPicker reloadAllComponents];
    [self.existingDestinationLocationsPicker reloadAllComponents];
}


//old method to pass data to List of Locations
- (IBAction) unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)unwindFromRecurrenceToCommuteCreatorTable:(UIStoryboardSegue *)segue {
    RepeatScheduleTableViewController *source = [segue sourceViewController];
    self.recurrenceScheduleArray = source.recurranceDays;
    if (_recurrenceScheduleArray != nil) {
        //TO DO: update recurrence label
        //for (NSInteger *intDayOfWeek in _recurrenceScheduleArray) {
        //NSLog(@"The commute items are", intDayOfWeek);
        //}
        //TO DO: Add recurrence schedule array to Commute Properties somehow or something
    }
    
}

- (void) loadInitialData {
    
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
    
    
    //if sender is  starting location edit button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"EditStartingLocation"]) {
        NSManagedObject *selectedLocation = [self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]];
        NSLog(@"The selected Location is %@", selectedLocation);
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        destViewController.location = selectedLocation;
    }
    
    //if sender is destination location edit button, prepare to edit a location by passing location information
    if ([[segue identifier] isEqualToString:@"EditDestinationLocation"]) {
        NSManagedObject *selectedLocation = [self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]];
        NSLog(@"The selected Location is %@", selectedLocation);
        LocationCreatorViewController *destViewController = segue.destinationViewController;
        destViewController.location = selectedLocation;
    }
    
    if (sender == self.commuteCreatorDoneButton) {
        //The single condition is a placeholder until I get full error handling in.
        if (self.commuteNameTextField.text.length > 0) {
            
            NSManagedObjectContext *context = [self managedObjectContext];
            //update a Commute if the commute exists
            if (self.commute){
                //update name
                [self.commute setValue:self.commuteNameTextField.text forKey:@"name"];
                //update starting address
                [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"startingAddress"];
                //update starting zip
                [self.commute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"startingZip"];
                //update destination address
                [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"destinationAddress"];
                //update destination zip
                [self.commute setValue:self.commuteItem.commuteDestinationZipCode = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"destinationZip"];
                //To do: Update Schedule
                [self.commute setValue:self.alertTime forKey:@"alertTime"];
                
                //create Local Notification for this commute. This should probably be in core data
                UILocalNotification *commuteNotification = [[UILocalNotification alloc] init];
                
                commuteNotification.fireDate = [commute valueForKey:@"alertTime"];
                
                //TO DO: Change variable one depending on time of day.
                commuteNotification.alertBody = [NSString stringWithFormat:@"Good variable1, the best route to work is varible2"];
                commuteNotification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:commuteNotification];
                
            } else {
                
                //create a new Commute
                
                // Create a new managed object
                NSManagedObject *newCommute = [NSEntityDescription insertNewObjectForEntityForName:@"Commute" inManagedObjectContext:context];
                
                //Set Commute Name
                [newCommute setValue:self.self.commuteNameTextField.text forKey:@"name"];
                
                //Set Starting Address
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"startingAddress"];
                NSLog(@"The value of commuteStartingAddress is %@", [newCommute valueForKey:@"startingAddress"]);
                
                //Set Starting Zip
                [newCommute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"startingZip"];
                
                //Set Destination Address
                [newCommute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"destinationAddress"];
                NSLog(@"The value of commuteDestinationAddress is %@", [newCommute valueForKey:@"destinationAddress"]);
                
                //Set Destination Zip
                [newCommute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"destinationZip"];
                
                //Set Alert Time
                [newCommute setValue:self.alertTime forKey:@"alertTime"];
                NSLog(@"The value of alertTime is %@", [newCommute valueForKey:@"alertTime"]);
                
                //create Local Notification for this commute. This should probably be in Core Data.
                UILocalNotification *commuteNotification = [[UILocalNotification alloc] init];
                
                commuteNotification.fireDate = [newCommute valueForKey:@"alertTime"];
                
                //TO DO: Change variable one depending on time of day.
                commuteNotification.alertBody = [NSString stringWithFormat:@"Good variable1, the best route to work is varible2"];
                commuteNotification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:commuteNotification];
                
                
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationsArray = [[NSMutableArray alloc] init];
    
    //populate fields with commute properties from the prepareForSegue in CommutesTableViewController
    if (self.commute){
        //populate commuteNameTextField with value of selected commute from Commutes Table
        [self.commuteNameTextField setText:[self.commute valueForKey:@"name"]];
        //To do: set the location
        
    }
    
    
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
    }
    else if (pickerView == self.existingDestinationLocationsPicker){
        NSLog(@"The destination location row is %ld", (long)row);
        _destinationLocationLabel.text = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"name"];
    }
    
}

@end

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
@interface CommuteCreatorTableViewController ()

@property (strong, nonatomic) IBOutlet UITextField *commuteNameTextField;
@property NSMutableArray *locationsArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commuteCreatorDoneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *commuteCreatorCancelButton;



@end

@implementation CommuteCreatorTableViewController
@synthesize commute;

- (IBAction)dismissKeyboard:(id)sender {
    
    [sender resignFirstResponder];
}

//Get the time selected from the UIDatePicker
NSDate *alertTime;

- (IBAction)alertTimeDatePicker:(UIDatePicker *)sender {
    alertTime = sender.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *prettyVersion = [dateFormatter stringFromDate:alertTime];
    NSLog(@"The selected time is %@", prettyVersion);
    
    //To do: Set the alert time to a commute property.
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
            
        }
        //To do: set the Commute Item's Schedule
        
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
    
    //old implementation
    //this returns the objects, not the locationName property
    return [[self.locationsArray objectAtIndex:row] valueForKey:@"Name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"The selected row is %d", row);
    
}

@end

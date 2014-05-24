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


@end

@implementation CommuteCreatorTableViewController
@synthesize commute;

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
{/*
    LocationCreatorViewController *source = [segue sourceViewController];
    LocationItem *location = source.locationItem;
    if (location != nil){
        [self.locationsArray addObject:location];
        [self.existingStartingLocationsPicker reloadAllComponents];
        [self.existingDestinationLocationsPicker reloadAllComponents];
    }
    */
}

- (void) loadInitialData {
    /*LocationItem *location1 = [[LocationItem alloc] init];
    location1.locationName = @"Home";
    location1.locationAddress = @"13N467 Chisholm Trail";
    location1.locationZipCode = @"60124";
    [self.locationsArray addObject:location1];
    LocationItem *location2 = [[LocationItem alloc] init];
    location2.locationName = @"Work";
    location2.locationAddress = @"835 North Michigan Ave";
    location2.locationZipCode = @"60611";
    [self.locationsArray addObject:location2];*/

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check to see if it was the Done or Cancel button that was tapped
    if (sender != self.commuteCreatorDoneButton) return;
    
    //The single condition is a placeholder until I get full error handling in.
    if (self.commuteNameTextField.text.length > 0) {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        //update a Commute if the commute exists
        if (self.commute){
            [self.commute setValue:self.commuteNameTextField.text forKey:@"name"];
            [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"startingAddress"];
            [self.commute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"startingZip"];
            [self.commute setValue:[[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"] forKey:@"destinationAddress"];
            [self.commute setValue:self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"] forKey:@"destinationZip"];
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
        
        
        
        /*
        //old method
        self.commuteItem = [[CommuteItem alloc] init];
        self.commuteItem.commuteName = self.commuteNameTextField.text;
        //set the Commute Item's starting address
        self.commuteItem.commuteStartingAddress = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"];
        NSLog(@"The value of commuteStartingAddress is %@", self.commuteItem.commuteStartingAddress);
        
        //set the Commute Item's starting zip
        self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"];
        
        //set the Commute Item's Destination Address
        self.commuteItem.commuteDestinationAddress = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"address"];
        
        //set the Commute Item's Destination Zip Code
        self.commuteItem.commuteDestinationZipCode = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] valueForKey:@"zipCode"];
        
        //To do: set the Commute Item's Schedule
         */
        
    }
    
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
        [self.commuteNameTextField setText:[self.commute valueForKey:@"name"]];
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

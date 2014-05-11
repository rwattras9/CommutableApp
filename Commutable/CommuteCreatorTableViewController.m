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

- (IBAction) unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue
{
    LocationCreatorViewController *source = [segue sourceViewController];
    LocationItem *location = source.locationItem;
    if (location != nil){
        [self.locationsArray addObject:location];
        [self.existingStartingLocationsPicker reloadAllComponents];
        [self.existingDestinationLocationsPicker reloadAllComponents];
    }
    
}

- (void) loadInitialData {
    LocationItem *location1 = [[LocationItem alloc] init];
    location1.locationName = @"Home";
    location1.locationAddress = @"13N467 Chisholm Trail";
    location1.locationZipCode = @"60124";
    [self.locationsArray addObject:location1];
    LocationItem *location2 = [[LocationItem alloc] init];
    location2.locationName = @"Work";
    location2.locationAddress = @"835 North Michigan Ave";
    location2.locationZipCode = @"60611";
    [self.locationsArray addObject:location2];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check to see if it was the Done or Cancel button that was tapped
    if (sender != self.commuteCreatorDoneButton) return;
    
    //The single condition is a placeholder until I get full error handling in.
    if (self.commuteNameTextField.text.length > 0) {
        self.commuteItem = [[CommuteItem alloc] init];
        self.commuteItem.commuteName = self.commuteNameTextField.text;
        //set the Commute Item's starting address
        self.commuteItem.commuteStartingAddress = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] locationAddress];
        //NSLog(@"The value of commuteStartingAddress is %@", self.commuteItem.commuteStartingAddress);
        
        //set the Commute Item's starting zip
        self.commuteItem.commuteStartingZipCode = [[self.locationsArray objectAtIndex:[_existingStartingLocationsPicker selectedRowInComponent:0]] locationZipCode];
        
        //set the Commute Item's Destination Address
        self.commuteItem.commuteDestinationAddress = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] locationAddress];
        
        //set the Commute Item's Destination Zip Code
        self.commuteItem.commuteDestinationZipCode = [[self.locationsArray objectAtIndex:[_existingDestinationLocationsPicker selectedRowInComponent:0]] locationZipCode];
        
        //To do: set the Commute Item's Schedule
        
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
    
    self.locationsArray = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    
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
    return [[self.locationsArray objectAtIndex:row] locationName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"The selected row is %d", row);
    
}

@end

//
//  CommuteCreatorTableViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommuteCreatorTableViewController.h"
#import "LocationItem.h"
@interface CommuteCreatorTableViewController ()

@property NSMutableArray *locationsArray;

@end

@implementation CommuteCreatorTableViewController

- (IBAction) unwindToCommuteCreatorTable:(UIStoryboardSegue *)segue
{

    
    
}

- (void) loadInitialData {
    LocationItem *location1 = [[LocationItem alloc] init];
    location1.locationName = @"Home";
    [self.locationsArray addObject:location1];
    LocationItem *location2 = [[LocationItem alloc] init];
    location2.locationName = @"Work";
    [self.locationsArray addObject:location2];

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

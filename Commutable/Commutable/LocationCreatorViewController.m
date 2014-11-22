//
//  LocationCreatorViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/13/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "LocationCreatorViewController.h"

@interface LocationCreatorViewController ()
@property (strong, nonatomic) IBOutlet UITextField *locationNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveNewLocationButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteLocationButton;
@property (strong, nonatomic) IBOutlet UILabel *locationNameErrorLabel;
@property (strong, nonatomic) IBOutlet UILabel *streetAddressErrorLabel;
@property (strong, nonatomic) IBOutlet UILabel *zipCodeErrorLabel;
@property (strong, nonatomic) IBOutlet UIButton *useCurrentLocationButton;

@end

@implementation LocationCreatorViewController
@synthesize location;
@synthesize currentLocationDictionary;
@synthesize authorizedLocation;


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)dismissKeyboard:(id)sender;
{
    [_locationNameTextField resignFirstResponder];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)deleteLocation:(id)sender {
    
    //To Do: Are you sure you want to delete the location?
    
    //Delete the location
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [context deleteObject:self.location];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;}
    
        
}

// when Use Current Location Button is clicked, grab location dictionary from segue and place info in correct text boxes
- (IBAction)useCurrentLocation:(id)sender {
    
    // if the API call had no results in getting the location, popup an error message. otherwise, go ahead and fill it in
    if ([currentLocationDictionary[@"status"]  isEqual: @"ZERO_RESULTS"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to get current location."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // get the query results in dictionary form
        NSDictionary *results = currentLocationDictionary[@"results"][0];
        NSDictionary *address_componentsSTRNUM;
        NSDictionary *address_componentsSTRADD;
        NSDictionary *address_componentsZIP;
        
        // have to make sure we grab the right info since the query results are dynamic
        // ie. some places don't have street numbers
        int comp = 0;
        while (true)
        {
            NSDictionary *check = results[@"address_components"][comp]; // grab the address components
            // iterate through the components, setting the right ones
            if ([check[@"types"][0] isEqual: @"street_number"])
            {
                address_componentsSTRNUM = check;
            }
            else if ([check[@"types"][0] isEqual: @"route"])
            {
                address_componentsSTRADD = check;
            }
            else if ([check[@"types"][0] isEqual: @"postal_code"])
            {
                address_componentsZIP = check;
                break; // once we get the zip, we can hop out of the iterating loop
            }
            
            comp++; // our counter for the iteration
            
            if (comp > 7)
            {
                break; // make sure this isn't an infinite loop
            }
        }
    
        // if there's no street number, don't put it into the text field
        if (address_componentsSTRNUM == NULL)
        {
            [self.streetAddressTextField setText:[NSString stringWithFormat:@"%@", address_componentsSTRADD[@"short_name"]]];
        }
        else
        {
            [self.streetAddressTextField setText:[NSString stringWithFormat:@"%@ %@", address_componentsSTRNUM[@"short_name"], address_componentsSTRADD[@"short_name"]]];
        }
        
        [self.zipCodeTextField setText:[NSString stringWithFormat:@"%@", address_componentsZIP[@"short_name"]]]; // put the zip into the zip field
    }
    
}




// before the view loads, if the user did not allow location tracking, don't give the option to use current location
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!authorizedLocation)
    {
        NSLog(@"hide button");
        [self.useCurrentLocationButton setHidden:YES];
    }
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.deleteLocationButton setHidden:YES];
    if (self.location) {
        
        [self.locationNameTextField setText:[self.location valueForKey:@"name"]];
        [self.streetAddressTextField setText:[self.location valueForKey:@"address"]];
        [self.zipCodeTextField setText:[self.location valueForKey:@"zipCode"]];
        
        //delete button show
        [self.deleteLocationButton setHidden:NO];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//States whether the segue should be performed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{//Do nothing if it isn't the save button that triggers the segue
    if (sender != self.saveNewLocationButton) return YES;
    else{
    /*
    //check to see if Location Name text field is populated
    if (self.locationNameTextField.text.length > 0){
        self.locationNameErrorLabel.hidden = YES;
        //check to see if Address text field is populated,
        if (self.streetAddressTextField.text.length > 0){
            self.streetAddressErrorLabel.hidden = YES;
            //check to see if Zip Code text field is populated
            if (self.zipCodeTextField.text.length == 5){
                self.zipCodeErrorLabel.hidden = YES;
                return YES;
            }
            else {NSLog(@"Please enter a valid zip code");
                self.locationNameErrorLabel.hidden = NO;
                return NO;
            }}
        else {
            NSLog(@"Please enter a valid street address");
            self.streetAddressErrorLabel.hidden = NO;
            return NO;
        }}
    else {
        NSLog(@"Please enter a valid location name");
        self.zipCodeErrorLabel.hidden = NO;
        return NO;
    }*/
        BOOL performSegue = YES;
        
        if (self.locationNameTextField.text && self.locationNameTextField.text.length > 0){
            NSLog(@"The error should be hidden");
            self.locationNameErrorLabel.hidden = YES;}
        else {
            NSLog(@"Please enter a valid location name");
            self.locationNameErrorLabel.hidden = NO;
            performSegue = NO;}
        if (self.streetAddressTextField.text.length > 0){
            self.streetAddressErrorLabel.hidden = YES;}
        else {
            NSLog(@"Please enter a valid street address");
            self.streetAddressErrorLabel.hidden = NO;
            performSegue = NO;}
        if (self.zipCodeTextField.text.length == 5){
            self.zipCodeErrorLabel.hidden = YES;}
        else {NSLog(@"Please enter a valid zip code");
            self.zipCodeErrorLabel.hidden = NO;
            performSegue = NO;}
        return performSegue;
        
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //if sender is cancel button, do nothing.
    //if sender is save button, create or update
    
    //Do nothing if it isn't the save button that triggers the segue
    if (sender != self.saveNewLocationButton) return;
    else{
        //using Core Data
        NSManagedObjectContext *context = [self managedObjectContext];
        
        //update the location
        if (self.location){
            [self.location setValue:self.locationNameTextField.text forKey:@"name"];
            [self.location setValue:self.streetAddressTextField.text forKey:@"address"];
            [self.location setValue:self.zipCodeTextField.text forKey:@"zipCode"];
        }
        else {
        //create a new a new Location Item object with the location Zip Code, location Name, and the location Name populated
        
        NSManagedObject *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        [newLocation setValue:self.locationNameTextField.text forKey:@"name"];
        [newLocation setValue:self.streetAddressTextField.text forKey:@"address"];
        [newLocation setValue:self.zipCodeTextField.text forKey:@"zipCode"];
        }
        NSError *error = nil;
        //save object to a persistant store
        if (![context save:&error]) {
            NSLog(@"Can't save, %@ %@", error, [error localizedDescription]);
            
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

@end
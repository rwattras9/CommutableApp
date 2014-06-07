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

@end

@implementation LocationCreatorViewController
@synthesize location;


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
    
    //check to see if Location Name text field is populated
    if (self.locationNameTextField.text.length > 0){
        
        //check to see if Address text field is populated,
        if (self.streetAddressTextField.text.length > 0){
            
            //check to see if Zip Code text field is populated
            if (self.zipCodeTextField.text.length == 5){
                
                return YES;
            }
            else {NSLog(@"Please enter a valid zip code");
                return NO;
            }}
        else {
            NSLog(@"Please enter a valid street address");
            return NO;
        }}
    else {
        NSLog(@"Please enter a valid location name");
        return NO;
    }
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
        
        //create a new a new Location Item object with the location Zip Code, location Name, and the location Name populated
        
        NSManagedObject *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        [newLocation setValue:self.locationNameTextField.text forKey:@"name"];
        [newLocation setValue:self.streetAddressTextField.text forKey:@"address"];
        [newLocation setValue:self.zipCodeTextField.text forKey:@"zipCode"];
        
        NSError *error = nil;
        //save object to a persistant store
        if (![context save:&error]) {
            NSLog(@"Can't save, %@ %@", error, [error localizedDescription]);
            
        }
        //[self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

@end
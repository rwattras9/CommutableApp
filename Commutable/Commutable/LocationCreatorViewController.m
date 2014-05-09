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

@end

@implementation LocationCreatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

//States whether the segue should be performed
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{//check to see if Location Name text field is populated
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //Do nothing if it isn't the save button that triggers the segue
    if (sender != self.saveNewLocationButton) return;
    else{
        //create a new a new Location Item object with the location Zip Code, location Name, and the location Name populated
        self.locationItem = [[LocationItem alloc] init];
        self.locationItem.locationName = self.locationNameTextField.text;
        self.locationItem.locationAddress = self.streetAddressTextField.text;
        self.locationItem.locationZipCode = self.zipCodeTextField.text;}
    
}


@end

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (sender != self.saveNewLocationButton) return;
    //check to see if Location Name text field is populated, then create a new Location Item object with the location Name populated.
    if (self.locationNameTextField.text.length > 0){
        self.locationItem = [[LocationItem alloc] init];
        self.locationItem.locationName = self.locationNameTextField.text;
    }
}


@end

//
//  CommuteNameViewController.m
//  Commutable
//
//  Created by Edward Damisch on 7/26/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommuteNameViewController.h"

@interface CommuteNameViewController ()

@end

@implementation CommuteNameViewController

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
    if (self.commuteName) {
        self.commuteNameTextField.text = self.commuteName;
    }

    self.commuteNameTextField.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [_commuteNameTextField becomeFirstResponder];
}

/*- (void)textFieldDidEndEditing:(UITextField *)textField {
    //perform segue with identifier
    [self performSegueWithIdentifier:@"unwindToCommuteCreator" sender:self];
}*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"unwindToCommuteCreator" sender:self];
    return YES;
}

/*-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"The statement is true");
        
        
    }
    [super viewWillDisappear:animated];
}*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}


@end

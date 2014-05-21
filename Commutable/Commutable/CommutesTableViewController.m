//
//  CommutesTableViewController.m
//  Commutable
//
//  Created by Edward Damisch and Rick Wattras on 4/12/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "CommutesTableViewController.h"
//import CommutesTableViewCell, since we'll be modifying the contents
#import "CommutesTableViewCell.h"
//#import "CommuteItem.h"
#import "CommuteCreatorTableViewController.h"

@interface CommutesTableViewController ()



@end

@implementation CommutesTableViewController

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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Commute"];
    self.commuteArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}


/*- (void) loadInitialData {
    
    
    //Placeholder data
    CommuteItem *commute1 = [[CommuteItem alloc] init];
    commute1.commuteName = @"Morning Commute";
    [self.commuteArray addObject:commute1];
    CommuteItem *commute2 = [[CommuteItem alloc] init];
    commute2.commuteName = @"Evening Commute";
    [self.commuteArray addObject:commute2];
    CommuteItem *commute3 = [[CommuteItem alloc] init];
    commute3.commuteName = @"Saturday Commute";
    [self.commuteArray addObject:commute3];
 
    
}*/

- (IBAction)unwindToCommutesTable:(UIStoryboardSegue *)segue
{/*
    CommuteCreatorTableViewController *source = [segue sourceViewController];
    CommuteItem *commute = source.commuteItem;
    if (commute != nil) {
        [self.commuteArray addObject:commute];
        [self.tableView reloadData];
    }*/
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
    
    //old method
    //initalize array of commutes
    //self.commuteArray = [[NSMutableArray alloc] init];
    
    //old method
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.commuteArray count];
}

//This returns the correct Commute information from the arrays
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commuteTableCell";
    CommutesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
        forIndexPath:indexPath];

    // Configure the cell...
    
    NSManagedObject *commute = [self.commuteArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [commute valueForKey:@"name"]]];
    
    //old method
    /*CommuteItem *commuteItem = [self.commuteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = commuteItem.commuteName;*/
    
    //old from other tutorial. Probably can delete.
    //long row = [indexPath row];
    
    //cell.commuteName.text = _commuteArray[row];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.commuteArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        //remove the device from table view
        [self.commuteArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];}
        /*
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   */
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editCommute"]) {
        NSManagedObject *selectedCommute = [self.commuteArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        CommuteCreatorTableViewController *destViewController = segue.destinationViewController; 
        NSLog(@"The destination view controller is %@", destViewController);
        NSLog(@"The selected commute is %@", selectedCommute);
        destViewController.commute = selectedCommute;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

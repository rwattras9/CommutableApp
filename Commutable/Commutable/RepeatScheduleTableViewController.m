//
//  RepeatScheduleTableViewController.m
//  Commutable
//
//  Created by Edward Damisch on 6/2/14.
//  Copyright (c) 2014 Commutable. All rights reserved.
//

#import "RepeatScheduleTableViewController.h"

@interface RepeatScheduleTableViewController ()


@property NSInteger selectedRow;
@property (strong, nonatomic) IBOutlet UITableView *recurranceTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation RepeatScheduleTableViewController

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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    //recurrenceEditor
    //backBarButtonItem
    //check to see if it was the Done or Cancel button that was tapped
    if (sender == self.cancelButton) return;
    
    if (sender == self.doneButton) {
        //iterate through the cells. If a cell in UITableView has a checkmark, add row number to recurrance days array
        if (self.isMovingFromParentViewController) {
            // Do your stuff here
            NSMutableArray *cellsWithCheckMarks = [[NSMutableArray alloc] init];
            for (int section = 0; section < [_recurranceTableView numberOfSections]; section++) {
                for (int row = 0; row < [_recurranceTableView numberOfRowsInSection:section]; row++) {
                    NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                    //NSLog(@"The cellPath is %@", cellPath);
                    UITableViewCell* cell = [_recurranceTableView cellForRowAtIndexPath:cellPath];
                    //NSInteger *rowOfCell = [cellPath row];
                    //do stuff with 'cell'
                    NSLog(@"The cell is %@", cell);
                    //NSLog(@"The cell accessory type is %ld", cell.accessoryType);
                    //if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
                    if (cell.accessoryType != UITableViewCellAccessoryNone)
                    {   NSLog(@"the statement is true");
                        [cellsWithCheckMarks addObject:cellPath];
                        
                    }
                }_recurranceDays = cellsWithCheckMarks;
                NSLog(@"The recurranceDays are %@", _recurranceDays);
            }
        }
    }
    
  

    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*
    if (self.isMovingFromParentViewController) {
        // Do your stuff here
        NSMutableArray *cellsWithCheckMarks = [[NSMutableArray alloc] init];
        for (int section = 0; section < [_recurranceTableView numberOfSections]; section++) {
            for (int row = 0; row < [_recurranceTableView numberOfRowsInSection:section]; row++) {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                //NSLog(@"The cellPath is %@", cellPath);
                UITableViewCell* cell = [_recurranceTableView cellForRowAtIndexPath:cellPath];
                //NSInteger *rowOfCell = [cellPath row];
                //do stuff with 'cell'
                NSLog(@"The cell is %@", cell);
                //NSLog(@"The cell accessory type is %ld", cell.accessoryType);
                //if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
                if (cell.accessoryType != UITableViewCellAccessoryNone)
                {   NSLog(@"the statement is true");
                    [cellsWithCheckMarks addObject:cellPath];
                    
                }
            }_recurranceDays = cellsWithCheckMarks;
            NSLog(@"The recurranceDays are %@", _recurranceDays);
        }
    }*/
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //The cell should immediately deselect after being tapped (not stay highlighted)
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //get index of selected cell
    self.selectedRow = indexPath.row;
    
    //Add or remove a checkmark
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        //[_recurranceDays addObject:indexPath];
        //NSLog(@"The recurranceDays are %@", _recurranceDays);
        
    }else{
        selectedCell.accessoryType = UITableViewCellAccessoryNone;}
   
}

@end

//
//  RootViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "RootViewController.h"
#import "AddFeinduraViewController.h"
#import "feinduraDetailStatsViewController.h"
#import "syncFeinduraAccounts.h"

@implementation RootViewController

@synthesize tableList;
@synthesize feinduraAccounts;
@synthesize uiTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // LOAD feindura Accounts
    syncFeinduraAccounts *tmp = [[syncFeinduraAccounts alloc] init];
    self.feinduraAccounts = tmp;
    [tmp release];
    
    // ADD feindura Accounts to the tableList
    self.tableList = [[NSMutableArray alloc] init];
    for (id key in self.feinduraAccounts.dataBase) {
        if([[self.feinduraAccounts.dataBase objectForKey:key] objectForKey:@"title"] != nil)
            [self.tableList addObject:[[self.feinduraAccounts.dataBase objectForKey:key] objectForKey:@"title"]];
        else
            [self.tableList addObject:key];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return true;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *cellText;
    cellText = [[UILabel alloc] initWithFrame:CGRectMake( 45, 12, 165, 20 )];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        [cellText setBackgroundColor:[UIColor clearColor]];
        [cellText setTextColor:[UIColor darkGrayColor]];
        [cellText setShadowColor:[UIColor clearColor]];
        [cellText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [cellText setText:[self.tableList objectAtIndex:indexPath.row]];
        [cellText setAdjustsFontSizeToFitWidth:true];
        [cell.contentView addSubview: cellText];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }    
    
    //NSDictionary *item = (NSDictionary *)[self.tableList objectAtIndex:indexPath.row];
    //[self.feinduraAccounts.dataBase objectForKey:]
    //cell.textLabel = cellText;//[item objectForKey:@"title"];
    
    NSArray *keys = [self.feinduraAccounts.dataBase allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id tableRow = [self.feinduraAccounts.dataBase objectForKey:aKey];
    
    // set tableRow text
    if([tableRow objectForKey:@"title"] != nil)
        cellText.text = [tableRow objectForKey:@"title"];
    else
        cellText.text = aKey;    
    [cellText release];
    
    // set tableRow userStatistics
    if([[tableRow objectForKey:@"statistics"] objectForKey:@"userVisitCount"] != nil)
        cell.detailTextLabel.text = [[tableRow objectForKey:@"statistics"] objectForKey:@"userVisitCount"];
    else
        cell.detailTextLabel.text = @"-";  
    
    // ADD a image
    NSString *path = [[NSBundle mainBundle] pathForResource:@"favicon" ofType:@"ico"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *altCellColor = [UIColor colorWithWhite:0.95 alpha:0.1];
    if (indexPath.row == 0 || indexPath.row%2 == 0)
        altCellColor = [UIColor colorWithWhite:0.99 alpha:0.1];
    cell.backgroundColor = altCellColor;
}

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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    feinduraDetailStatsViewController *detailViewController = [[feinduraDetailStatsViewController alloc] initWithNibName:@"feinduraDetailStatsViewController" bundle:nil];
    
    [detailViewController setTitle:[tableList objectAtIndex:indexPath.row]];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.feinduraAccounts = nil;
    self.tableList = nil;
}

- (void)dealloc {
    [feinduraAccounts release];
    [tableList release];
    [super dealloc];
}


#pragma mark Methods

-(IBAction)showAddFeinduraView:(id)sender {
	AddFeinduraViewController *modalView = [[AddFeinduraViewController alloc] init];
	modalView.delegate = self;
    modalView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
	[self presentModalViewController:modalView animated:YES];
	[modalView release];
}


#pragma mark Delegates

-(void)DismissAddFeinduraView {
	[self dismissModalViewControllerAnimated:YES];
    
    // reload tableView
    [feinduraAccounts updateAccounts];
    [uiTableView reloadData];
    [uiTableView setEditing:true animated:true];
}

@end

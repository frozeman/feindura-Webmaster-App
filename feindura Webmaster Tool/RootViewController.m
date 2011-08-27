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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];               
        
        UILabel *cellText;
        cellText = [[UILabel alloc] initWithFrame:CGRectMake( 45, 11, 165, 20 )];
        [cellText setBackgroundColor:[UIColor clearColor]];
        [cellText setTextColor:[UIColor darkGrayColor]];
        //[cellText setShadowColor:[UIColor clearColor]];
        [cellText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [cellText setAdjustsFontSizeToFitWidth:true];
        [cellText setMinimumFontSize: 12.0];
        [cellText setTag:1];
        [cell.contentView addSubview: cellText];
        [cellText release];
        
        UILabel *cellStats;
        cellStats = [[UILabel alloc] initWithFrame:CGRectMake( 220, 11, 65, 20 )];
        [cellStats setText:@"-"];
        [cellStats setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cellStats setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [cellStats setAdjustsFontSizeToFitWidth:true];
        [cellStats setMinimumFontSize: 8.0];
        [cellStats setTextAlignment:UITextAlignmentRight];
        [cellStats setTag:2];
        [cell.contentView addSubview: cellStats];
        [cellStats release];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }    
    
    // get feindura account keys from indexPath.row
    NSArray *keys = [self.feinduraAccounts.dataBase allKeys];
    id aKey = [keys objectAtIndex:indexPath.row];
    id feinduraAccount = [self.feinduraAccounts.dataBase objectForKey:aKey];
    
    // add the text to the cells
    for (UILabel *view in [cell.contentView subviews]) {        
        // set tableRow text
        if(view.tag == 1) {            
            if([feinduraAccount objectForKey:@"title"] != nil)
                [view setText:[feinduraAccount objectForKey:@"title"]];
            else
                [view setText:aKey];
        }
        
        // set tableRow userStatistics
        if(view.tag == 2 && [[feinduraAccount objectForKey:@"statistics"] objectForKey:@"userVisitCount"] != nil) {            
            [view setText:[[feinduraAccount objectForKey:@"statistics"] objectForKey:@"userVisitCount"]];
        }
    }
    
    // ADD a image
    NSString *path = [[NSBundle mainBundle] pathForResource:@"favicon" ofType:@"ico"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    

    return cell;
}

// Make Table rows changing color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *altCellColor;
    if (indexPath.row == 0 || indexPath.row%2 == 0)
        altCellColor = [UIColor colorWithWhite:0.995 alpha:1];
    else
        altCellColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    cell.backgroundColor = altCellColor;
    for (UIView *view in [cell.contentView subviews]) {
        [view setBackgroundColor:altCellColor];
    }
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

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView setHidden:true];
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

-(IBAction)editFeinduraAccounts:(id)sender {
    if(uiTableView.editing == false)
        [uiTableView setEditing:true animated:true];
    else
        [uiTableView setEditing:false animated:true];
}


#pragma mark Delegates

-(void)DismissAddFeinduraView {
	[self dismissModalViewControllerAnimated:YES];
    
    // reload tableView
    [feinduraAccounts updateAccounts];
    [uiTableView reloadData];
}

@end

//
//  RootViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "RootViewController.h"
#import "feinduraDetailStatsViewController.h"
#import "feindura_Webmaster_ToolAppDelegate.h"
#import "NSString+MD5.h"
#import "SFHFKeychainUtils.h"

@implementation RootViewController

@synthesize appDelegate;
@synthesize feinduraAccounts;
@synthesize uiTableView;
@synthesize titleBar;

/*
- (id)init {
    if(self = [super init]) {
  
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // -> SET transport this instance of the rootViewController to the AppDelegate
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.appDelegate.rootViewController = self;
    
    // -> add a title which fits in the navbar
    UILabel *title = [[UILabel alloc] init];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor whiteColor]];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [title setText:NSLocalizedString(@"OVERVIEW_TITLE", nil)];
    [title sizeToFit];
    [title setAdjustsFontSizeToFitWidth:true];
    [titleBar setTitle:NSLocalizedString(@"OVERVIEW_TITLE", nil)];
    [titleBar setTitleView:title];
    [title release];
    
    
    // LOAD feindura Accounts
    syncFeinduraAccounts *tmp = [[syncFeinduraAccounts alloc] init];
    self.feinduraAccounts = tmp;
    self.feinduraAccounts.delegate = self;
    [tmp release];
    
    // --------------------------------------------------------------------------------------------
    // STORE DEFAULT account password (http:/demo.feindura.org)
    // -> STORE user data
    NSError *keychainError;
    
    // ->> STORE password in keychain
    [SFHFKeychainUtils storeUsername:@"demo" andPassword:[@"demo" MD5] forServiceName:@"http://demo.feindura.org/cms" updateExisting:true error:&keychainError];
    // --------------------------------------------------------------------------------------------
    
    // -> basic table setup
    self.uiTableView.allowsSelectionDuringEditing = true;    

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
    return [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];         
        
        UILabel *cellText;
        cellText = [[UILabel alloc] initWithFrame:CGRectMake( 45, 5, 165, 20 )];
        [cellText setBackgroundColor:[UIColor clearColor]];
        [cellText setTextColor:[UIColor darkGrayColor]];
        [cellText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cellText setAdjustsFontSizeToFitWidth:true];
        [cellText setMinimumFontSize: 12.0];
        [cellText setTag:1];
        
        UILabel *cellSubText;
        cellSubText = [[UILabel alloc] initWithFrame:CGRectMake( 45, 22, 165, 20 )];
        [cellSubText setBackgroundColor:[UIColor clearColor]];
        [cellSubText setTextColor:[UIColor grayColor]];
        [cellSubText setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [cellSubText setAdjustsFontSizeToFitWidth:true];
        [cellSubText setMinimumFontSize: 8.0];
        [cellSubText setTag:2];
        
        UILabel *cellStats;
        cellStats = [[UILabel alloc] initWithFrame:CGRectMake( 220, 11, 65, 20 )];
        [cellStats setText:@"-"];
        [cellStats setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cellStats setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cellStats setAdjustsFontSizeToFitWidth:true];
        [cellStats setMinimumFontSize: 8.0];
        [cellStats setTextAlignment:UITextAlignmentRight];
        [cellStats setTag:3];
        
        // add the subviews in the right order
        [cell.contentView addSubview: cellSubText];
        [cell.contentView addSubview: cellText];
        [cell.contentView addSubview: cellStats];
        [cellSubText release];
        [cellText release];
        [cellStats release];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        //[cell setSelected:false];
    }
    
    // get feindura account keys from indexPath.row
    id feinduraAccount = [self.feinduraAccounts.dataBase objectForKey:[[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row]];
    
    // add the text to the cells
    for (UILabel *view in [cell.contentView subviews]) {        
        // set tableRow text
        if(view.tag == 1) {  
            if([feinduraAccount objectForKey:@"title"] != nil && ![[feinduraAccount valueForKey:@"title"] isEqualToString:@""])
                [view setText:[feinduraAccount valueForKey:@"title"]];
            else
                [view setText:[feinduraAccount valueForKey:@"url"]];
        }
        
        // set tableRow subtext
        if(view.tag == 2) {            
            [view setText:[feinduraAccount valueForKey:@"url"]];
        }
        
        // set tableRow userStatistics
        if(view.tag == 3 && [feinduraAccount objectForKey:@"statistics"] != nil && [[feinduraAccount objectForKey:@"statistics"] valueForKey:@"userVisitCount"] != nil) {            
            [view setText:[[[feinduraAccount objectForKey:@"statistics"] valueForKey:@"userVisitCount"] stringValue]];
        }
    }
    
    // ADD a image
    if([[feinduraAccount valueForKey:@"status"] isEqualToString:@"FAILED"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"failed.icon" ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:path];
        cell.imageView.image = theImage;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default.icon" ofType:@"png"];
        UIImage *theImage = [UIImage imageWithContentsOfFile:path];
        cell.imageView.image = theImage;
    }    

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

// DELETE ROW
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        // get current account id
        id accountKey = [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        
        // delete account from the database
        [self.feinduraAccounts.dataBase removeObjectForKey:accountKey]; // delete from the database
        [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] removeObjectAtIndex:indexPath.row]; // delete from the sortorder array
        [self.feinduraAccounts saveAccounts];
        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
    }
    /*
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    } 
    */
}


// REARRANGE ROWS
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray* newOrder = [NSMutableArray arrayWithArray:[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"]]; 
    
    //NSLog(@"BEFORE %@",tempArray);
    
    // rearrange array
    NSString *key = [newOrder objectAtIndex: fromIndexPath.row];
    [key retain];  // Let it survive being removed from the array.
    [newOrder removeObjectAtIndex: fromIndexPath.row];
    [newOrder insertObject: key  atIndex: toIndexPath.row];
    [key release];
    
    //NSLog(@"AFTER %@",tempArray);
    
    [self.feinduraAccounts.dataBase setObject:newOrder forKey:@"sortOrder"];
    [self.feinduraAccounts saveAccounts];
    [self.uiTableView reloadData];
}

// SELECT ROW
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // EDIT account
    if([tableView cellForRowAtIndexPath:indexPath].editing) {
        
        // get selected account dictionary
        NSString *accountKey = [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        NSMutableDictionary *feinduraAccount = [self.feinduraAccounts.dataBase objectForKey:accountKey];
        [feinduraAccount setValue:accountKey forKey:@"accountId"];
        
        [self showEditFeinduraAccountView:feinduraAccount];
     
    // SHOW detail
    } else {
        /*
        feinduraDetailStatsViewController *detailViewController = [[feinduraDetailStatsViewController alloc] initWithNibName:@"feinduraDetailStatsViewController" bundle:nil];
        
        // get feindura account keys from indexPath.row
        NSString *accountKey = [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        NSDictionary feinduraAccount = [self.feinduraAccounts.dataBase objectForKey:accountKey];
        
        if([feinduraAccount objectForKey:@"title"] != nil)
            [detailViewController setTitle:[feinduraAccount objectForKey:@"title"]];
        else
            [detailViewController setTitle:aKey];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
         */
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.feinduraAccounts = nil;
    self.uiTableView = nil;
    self.titleBar = nil;
}

- (void)dealloc {
    [feinduraAccounts release];
    [uiTableView release];
    [titleBar release];
    [super dealloc];
}


#pragma mark Methods

-(IBAction)showAddFeinduraAccountView:(id)sender {
    
    // deactivate editing mode before
    for (UITableViewCell *cell in self.uiTableView.visibleCells) {
        for (UILabel *view in [cell.contentView subviews]) {        
            [view setHidden:false];
        }
    }
    [self.uiTableView setEditing:false animated:true];
    
    // instanciate modal view
    FeinduraAccountViewController *modalView = [[FeinduraAccountViewController alloc] init];
    modalView.delegate = self;
    modalView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

	[self presentModalViewController:modalView animated:YES];
    [modalView release];
    
}

-(void)showEditFeinduraAccountView:(NSDictionary *)account {
    
    // instanciate modal view
    FeinduraAccountViewController *modalView = [[FeinduraAccountViewController alloc] init];
    modalView.delegate = self;
    modalView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // transport accunt data
    modalView.editAccount = account;
    
	[self presentModalViewController:modalView animated:YES];
    [modalView release];
}

-(IBAction)editFeinduraAccounts:(id)sender {
    // START editing mode
    if(uiTableView.editing == false) {
        
        // hide the statistics
        for (UITableViewCell *cell in self.uiTableView.visibleCells) {
            for (UILabel *view in [cell.contentView subviews]) {
                if(view.tag == 3) {            
                    [view setHidden:true];
                }
            }
        }
        
        [uiTableView setEditing:true animated:true];
        
    // END editing mode
    } else {
        
        for (UITableViewCell *cell in self.uiTableView.visibleCells) {
            for (UILabel *view in [cell.contentView subviews]) {        
                [view setHidden:false];
            }
        }
        
        [uiTableView setEditing:false animated:true];
    }
}

-(IBAction)refreshFeinduraAccounts:(id)sender {
    [self.feinduraAccounts updateAccounts];
}


#pragma mark Delegates

-(void)DismissAddFeinduraView {
	[self dismissModalViewControllerAnimated:YES];

    // reload tableView
    [self.feinduraAccounts updateAccounts];
    [uiTableView reloadData];
}

@end

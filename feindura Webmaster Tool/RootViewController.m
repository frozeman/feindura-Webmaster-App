//
//  RootViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "RootViewController.h"
#import "DetailStatsViewController.h"
#import "feindura_Webmaster_ToolAppDelegate.h"
#import "NSString+MD5.h"
#import "SFHFKeychainUtils.h"


@implementation RootViewController

@synthesize appDelegate;
@synthesize feinduraAccounts;
@synthesize titleBar, editButton;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
 
    }
    return self;
}


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
    SyncFeinduraAccounts *tmpFa = [[SyncFeinduraAccounts alloc] init];
    self.feinduraAccounts = tmpFa;
    [tmpFa release];
    RootViewController *tmpRootView = self;
    [feinduraAccounts setDelegate:tmpRootView];
    [tmpRootView release];
    
    
    // --------------------------------------------------------------------------------------------
    // STORE DEFAULT account password (http:/demo.feindura.org)
    // -> STORE user data
    NSError *keychainError;
    
    // ->> STORE password in keychain
    [SFHFKeychainUtils storeUsername:@"demo" andPassword:[@"demo" MD5] forServiceName:@"http://demo.feindura.org/cms" updateExisting:true error:&keychainError];
    // --------------------------------------------------------------------------------------------
    
    // -> basic table setup
    self.tableView.allowsSelectionDuringEditing = true;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [TableHelperClass changeCellOrientation:cell toOrientation:self.interfaceOrientation inTable:self];
    }
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // releases the images in the cells
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        cell.imageView.image = nil;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.feinduraAccounts = nil;
    self.titleBar = nil;
    self.appDelegate = nil;
}

- (void)dealloc {
    [feinduraAccounts release];
    [titleBar release];
    [appDelegate release];
    [super dealloc];
}

#pragma mark - Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[feinduraAccounts.dataBase objectForKey:@"sortOrder"] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];         
        
        UILabel *cellText = [[UILabel alloc] init];
        [cellText setBackgroundColor:[UIColor clearColor]];
        [cellText setTextColor:[UIColor darkGrayColor]];
        [cellText setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [cellText setAdjustsFontSizeToFitWidth:true];
        [cellText setMinimumFontSize: 12.0];
        [cellText setTag:1];
        
        UILabel *cellSubText = [[UILabel alloc] init];
        [cellSubText setBackgroundColor:[UIColor clearColor]];
        [cellSubText setTextColor:[UIColor grayColor]];
        [cellSubText setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [cellSubText setAdjustsFontSizeToFitWidth:true];
        [cellSubText setMinimumFontSize: 8.0];
        [cellSubText setTag:2];
        
        UILabel *cellStats = [[UILabel alloc] init];
        [cellStats setText:@"-"];
        [cellStats setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cellStats setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [cellStats setAdjustsFontSizeToFitWidth:true];
        [cellStats setMinimumFontSize: 8.0];
        [cellStats setTextAlignment:UITextAlignmentRight];
        [cellStats setTag:3];
        
        UILabel *cellSubStats = [[UILabel alloc] init];
        [cellSubStats setText:@"-"];
        [cellSubStats setTextColor:[UIColor grayColor]];
        [cellSubStats setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [cellSubStats setAdjustsFontSizeToFitWidth:true];
        [cellSubStats setMinimumFontSize: 8.0];
        [cellSubStats setTextAlignment:UITextAlignmentRight];
        [cellSubStats setTag:4];
        
        // add the subviews in the right order
        [cell.contentView addSubview: cellSubText];
        [cell.contentView addSubview: cellText];
        [cell.contentView addSubview: cellSubStats];
        [cell.contentView addSubview: cellStats];        
        [cellSubText release];
        [cellText release];
        [cellStats release];
        [cellSubStats release];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    } else {
        // clean up the reused cell
        [(UILabel *)[cell viewWithTag:1] setText:nil];
        [(UILabel *)[cell viewWithTag:2] setText:nil];
        [(UILabel *)[cell viewWithTag:3] setText:nil];
        [(UILabel *)[cell viewWithTag:4] setText:nil];
    }
    
    // number formatter
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setAlwaysShowsDecimalSeparator:false];
    [numberFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    // GET current feindura account
    id feinduraAccount = [feinduraAccounts.dataBase objectForKey:[[feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row]];
    
    // title
    if([feinduraAccount objectForKey:@"title"] != nil && ![[feinduraAccount objectForKey:@"title"] isEqualToString:@""])
        [(UILabel *)[cell viewWithTag:1] setText:[feinduraAccount objectForKey:@"title"]];
    else
        [(UILabel *)[cell viewWithTag:1] setText:[feinduraAccount objectForKey:@"url"]];
        
    // url           
    [(UILabel *)[cell viewWithTag:2] setText:[feinduraAccount objectForKey:@"url"]];
        
    // userStatistics
    if([feinduraAccount objectForKey:@"statistics"] != nil && [[feinduraAccount objectForKey:@"statistics"] objectForKey:@"userVisitCount"] != nil) {
        // show the number, when hidden and not shown again after removing and adding (hack)
        if(tableView.editing == false)
            [(UILabel *)[cell viewWithTag:3] setHidden:false];
        
        // add number
        [(UILabel *)[cell viewWithTag:3] setText:[numberFormatter stringForObjectValue:[[feinduraAccount objectForKey:@"statistics"] objectForKey:@"userVisitCount"]]];
        
    }
        
    // statistics subtext
    [(UILabel *)[cell viewWithTag:4] setText:[NSLocalizedString(@"STATSSUBTEXT_LASTVISIT", nil) stringByAppendingString:[NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[feinduraAccount objectForKey:@"statistics"] objectForKey:@"lastVisit"] intValue]] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle]]];
    
    
    // ADD a image
    NSString *imagePath;
    if([[feinduraAccount objectForKey:@"status"] isEqualToString:@"FAILED"])
        imagePath = [[NSBundle mainBundle] pathForResource:@"failed.icon" ofType:@"png"];
    else if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", feinduraAccounts.imagesPath,[feinduraAccount objectForKey:@"id"]]])
        imagePath = [NSString stringWithFormat:@"%@/%@.png", feinduraAccounts.imagesPath,[feinduraAccount objectForKey:@"id"]];
    else
        imagePath = [[NSBundle mainBundle] pathForResource:@"default.icon" ofType:@"png"];
        
    UIImage *iconImage = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = iconImage;
    
    [numberFormatter release];
    [TableHelperClass changeCellOrientation:cell toOrientation:self.interfaceOrientation inTable:self];
    return cell;
}

#pragma mark - Table view delegate

// Make Table rows changing color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *altCellColor;
    if (indexPath.row == 0 || indexPath.row%2 == 0)
        altCellColor = [UIColor colorWithWhite:0.995 alpha:1];
    else
        altCellColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    [cell setBackgroundColor:altCellColor];
    for (UIView *view in [cell.contentView subviews]) {
        [view setBackgroundColor:altCellColor];
    }
}

// DELETE ROW
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // vars
        NSError *error;
        
        // get current account id
        id accountKey = [[feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        
        // delete images
        if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", feinduraAccounts.imagesPath,accountKey]]) {
            if (![[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@.png", feinduraAccounts.imagesPath,accountKey] error:&error]) {	//Delete it
                NSLog(@"Delete file error: %@", error);
            }
            
        }
        
        // delete account from the database
        [feinduraAccounts.dataBase removeObjectForKey:accountKey]; // delete from the database
        [[feinduraAccounts.dataBase objectForKey:@"sortOrder"] removeObjectAtIndex:indexPath.row]; // delete from the sortorder array
        [feinduraAccounts saveAccounts];
        
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
    NSMutableArray* newOrder = [NSMutableArray arrayWithArray:[feinduraAccounts.dataBase objectForKey:@"sortOrder"]]; 
    
    //NSLog(@"BEFORE %@",tempArray);
    
    // rearrange array
    NSString *key = [newOrder objectAtIndex: fromIndexPath.row];
    [key retain];
    [newOrder removeObjectAtIndex: fromIndexPath.row];
    [newOrder insertObject: key  atIndex: toIndexPath.row];
    [key release];

    //NSLog(@"AFTER %@",tempArray);
    
    [feinduraAccounts.dataBase setObject:newOrder forKey:@"sortOrder"];
    [feinduraAccounts saveAccounts];
    [self.tableView reloadData];
}

// SELECT ROW
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // EDIT account
    if([tableView cellForRowAtIndexPath:indexPath].editing) {
        
        // get selected account dictionary
        NSString *accountKey = [[feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        NSDictionary *feinduraAccount = [feinduraAccounts.dataBase objectForKey:accountKey];
        
        [self showEditFeinduraAccountView:feinduraAccount];
     
    // SHOW DETAIL
    } else {
        
        // get feindura account keys from indexPath.row
        NSString *accountKey = [[self.feinduraAccounts.dataBase objectForKey:@"sortOrder"] objectAtIndex:indexPath.row];
        NSDictionary *feinduraAccount = [self.feinduraAccounts.dataBase objectForKey:accountKey];
        
        if([feinduraAccount objectForKey:@"statistics"] == nil) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell setSelected:false];
            return;
        }
        
        
        DetailStatsViewController *detailViewController = [[DetailStatsViewController alloc] initWithNibName:@"DetailStatsViewController" bundle:nil];
        
        [detailViewController setData: feinduraAccount];
        [detailViewController setLevel: [NSString stringWithString:@"MAIN"]];
        
        if([feinduraAccount objectForKey:@"title"] != nil)
            [detailViewController setTitle:[feinduraAccount objectForKey:@"title"]];
        else
            [detailViewController setTitle:accountKey];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return true;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [TableHelperClass changeCellOrientation:cell toOrientation:toInterfaceOrientation inTable:self];
    }
}


#pragma mark Methods

-(IBAction)showAddFeinduraAccountView:(id)sender {
    
    if(self.tableView.editing == true)
        [self editFeinduraAccounts:nil];
    
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
    if(self.tableView.editing == false) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editFeinduraAccounts:)];
        self.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
        
        // hide the statistics
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            [[cell viewWithTag:3] setHidden:true];
            [[cell viewWithTag:4] setHidden:true];
        }
        
        [self.tableView setEditing:true animated:true];
        
    // END editing mode
    } else {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editFeinduraAccounts:)];
        self.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
        
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            for (UILabel *view in [cell.contentView subviews]) {
                if(view.tag != 4 || (view.tag == 4 && !UIInterfaceOrientationIsPortrait(self.interfaceOrientation))) // prevent stats subtext to become visible in portrait mode
                    [view setHidden:false];
                
            }
        }
        [self.tableView setEditing:false animated:true];
    }
}

-(IBAction)refreshFeinduraAccounts:(id)sender {
    [feinduraAccounts updateAccounts];
}

#pragma mark Delegates

-(void)DismissAddFeinduraView {
	[self dismissModalViewControllerAnimated:YES];

    // reload database
    [feinduraAccounts updateAccounts];
}

@end

//
//  feinduraDetailStatsViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 18.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "FeinduraDetailStatsViewController.h"

@implementation FeinduraDetailStatsViewController

@synthesize level;
@synthesize data, sortedData;
@synthesize uiTableView;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.toolbarHidden = false;
    
    UIBarButtonItem            *buttonItem;
    
    buttonItem = [[ UIBarButtonItem alloc ] initWithTitle: @"Back"
                                                    style: UIBarButtonItemStyleBordered
                                                   target: self
                                                   action: @selector( goBack: ) ];
    self.navigationController.toolbarItems = [ NSArray arrayWithObject: buttonItem ];
    [ buttonItem release ];

    if(![level isEqualToString:@"MAIN"]) {

        // SORT ARRAY
        if(self.sortedData != nil && [sortedData isKindOfClass:[NSArray class]]) {
            self.sortedData = [sortedData sortedArrayUsingComparator:^(id item1, id item2) {
                NSNumber *value1 = [item1 objectForKey:@"number"];
                NSNumber *value2 = [item2 objectForKey:@"number"];
                //NSLog(@"item 1: %@, item 2:%@",value1,value2);
                return [value1 compare:value2];
            }];
            
            // REVERSE ARRAY
            self.sortedData = [[sortedData reverseObjectEnumerator] allObjects];
            //NSLog(@"%@",sortedData);
        }
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.level = nil;
    self.data = nil;
    self.sortedData = nil;
    self.uiTableView = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return true;
}

- (void)dealloc {
    [level release];
    [data release];
    [sortedData release];
    [uiTableView release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([level isEqualToString:@"MAIN"])
        return 2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([level isEqualToString:@"MAIN"]) {
        if(section == 0)
            return NSLocalizedString(@"DETAILVIEWS_HEADER_STATS", nil);
        else
            return NSLocalizedString(@"DETAILVIEWS_HEADER_DETAILS", nil);
    } else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // LEVEL MAIN
    if([level isEqualToString:@"MAIN"]) {
        if(section == 0)
            return 4;
        else
            return 3;
    } else
        return [sortedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    // number style
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setAlwaysShowsDecimalSeparator:false];
    [numberFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // date style
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    
    // LEVEL MAIN
    if([level isEqualToString:@"MAIN"]) {
        
        if(indexPath.section == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide seletion style
            [cell.detailTextLabel setText:@"-"];
            
            // VISITORS
            if(indexPath.row == 0) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_VISITORS", nil)];
                [cell.detailTextLabel setText:[numberFormatter
                                               stringForObjectValue:[[data objectForKey:@"statistics"] objectForKey:@"userVisitCount"]]];
            }
            // WEBCRAWLER
            if(indexPath.row == 1) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_WEBCRAWLER", nil)];
                [cell.detailTextLabel setText:[numberFormatter
                                               stringForObjectValue:[[data objectForKey:@"statistics"] objectForKey:@"robotVisitCount"]]];
            }
            
            // FIRST VISIT
            if(indexPath.row == 2) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_FIRSTVISIT", nil)];
                [cell.detailTextLabel setText:[dateFormatter
                                               stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[data objectForKey:@"statistics"] objectForKey:@"firstVisit"] intValue]]]];
            }
            // LAST VISIT
            if(indexPath.row == 3) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_LASTVISIT", nil)];
                [cell.detailTextLabel setText:[dateFormatter
                                               stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[data objectForKey:@"statistics"] objectForKey:@"lastVisit"] intValue]]]];
            }
            
        } else if(indexPath.section == 1) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; // show selection arrow
            
            // SEARCHWORDS
            if(indexPath.row == 0) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_SEARCHWORDS", nil)];
            }
            // BROWSER STATISTICS
            if(indexPath.row == 1) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_BROWSERSTATS", nil)];
            }
            // PAGE STATISTICS
            if(indexPath.row == 2) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_PAGESTATS", nil)];
            }
        }
        
    // SHOW SORTED DATA
    } else if(self.sortedData != nil) {
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide seletion style
        [cell.detailTextLabel setText:@"-"];
        
        if([level isEqualToString:@"PAGES"]) {
            [cell.textLabel setText:[[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"]];
        } else {
            [cell.textLabel setText:[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"]];
        }
       
        [cell.detailTextLabel setText:[numberFormatter stringForObjectValue:[[sortedData objectAtIndex:indexPath.row] objectForKey:@"number"]]];
    }
    
    [numberFormatter release];
    [dateFormatter release];
    return cell;
}

#pragma mark - Table view delegate

// SELECT ROW
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    
    if([level isEqualToString:@"MAIN"]) {
        FeinduraDetailStatsViewController *detailViewController = [[FeinduraDetailStatsViewController alloc] initWithNibName:@"FeinduraDetailStatsViewController" bundle:nil];
        
        // SEARCHWORDS
        if(indexPath.row == 0) {
            [detailViewController setSortedData: [[data objectForKey:@"statistics"] objectForKey:@"searchWords"]];
            [detailViewController setLevel: [NSString stringWithString:@"SEARCHWORDS"]];
            [detailViewController setTitle:NSLocalizedString(@"DETAILVIEWS_SEARCHWORDS", nil)];
            
        }
        
        // BROWSER STATS
        if(indexPath.row == 1) {
            [detailViewController setSortedData: [[data objectForKey:@"statistics"] objectForKey:@"browser"]];
            [detailViewController setLevel: [NSString stringWithString:@"BROWSER"]];
            [detailViewController setTitle:NSLocalizedString(@"DETAILVIEWS_BROWSERSTATS", nil)];
            
        }
        
        // PAGE STATS
        if(indexPath.row == 2) {
            [detailViewController setSortedData: [[data objectForKey:@"statistics"] objectForKey:@"pages"]];
            [detailViewController setLevel: [NSString stringWithString:@"PAGES"]];
            [detailViewController setTitle:NSLocalizedString(@"DETAILVIEWS_PAGESTATS", nil)];
            
        }
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

@end

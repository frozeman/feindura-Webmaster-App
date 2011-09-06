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

    if(![level isEqualToString:@"MAIN"]) {
        
        // CREATE ARRAY
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *key in data) {
            [tempArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [data objectForKey:key],@"number",
                                   key,@"data",
                                   nil]];
        }
        
        // SORT ARRAY
        self.sortedData = [tempArray sortedArrayUsingComparator:^(id item1, id item2) {
            NSNumber *value1 = [item1 objectForKey:@"number"];
            NSNumber *value2 = [item2 objectForKey:@"number"];
            //NSLog(@"item 1: %@, item 2:%@",value1,value2);
            return [value1 compare:value2];
        }];
        [tempArray release];
        
        // REVERSE ARRAY
        self.sortedData = [[sortedData reverseObjectEnumerator] allObjects];
        
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            return @"Details";
        else
            return @"Menu";
    } else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // LEVEL MAIN
    if([level isEqualToString:@"MAIN"]) {
        if(section == 0)
            return 2;
        else
            return 3;
    } else
        return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setTextColor:[UIColor darkGrayColor]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    
    // LEVEL MAIN
    if([level isEqualToString:@"MAIN"]) {
        
        if(indexPath.section == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide seletion style
            [cell.detailTextLabel setText:@"-"];
            
            // VISITORS
            if(indexPath.row == 0) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_VISITORS", nil)];
                [cell.detailTextLabel setText:[[[data objectForKey:@"statistics"] objectForKey:@"userVisitCount"] stringValue]];
            }
            // WEBCRAWLER
            if(indexPath.row == 1) {
                [cell.textLabel setText:NSLocalizedString(@"DETAILVIEWS_WEBCRAWLER", nil)];
                [cell.detailTextLabel setText:[[[data objectForKey:@"statistics"] objectForKey:@"robotVisitCount"] stringValue]];
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
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide seletion style
        [cell.detailTextLabel setText:@"-"];
        
        NSDictionary *cellData = [sortedData objectAtIndex:indexPath.row];
        
        [cell.textLabel setText:[cellData objectForKey:@"data"]];
        [cell.detailTextLabel setText:[[cellData objectForKey:@"number"] stringValue]];
    }
    
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
        
        // BROWSER STATS
        if(indexPath.row == 1) {
            
            [detailViewController setData: [[data objectForKey:@"statistics"] objectForKey:@"browser"]];
            [detailViewController setLevel: [NSString stringWithString:@"BROWSER"]];
            [detailViewController setTitle:NSLocalizedString(@"DETAILVIEWS_BROWSERSTATS", nil)];
            
        }
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

@end

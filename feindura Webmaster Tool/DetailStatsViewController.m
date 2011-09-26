//
//  feinduraDetailStatsViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 18.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "DetailStatsViewController.h"

@implementation DetailStatsViewController

@synthesize level;
@synthesize data, sortedData;

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
    
    self.navigationController.toolbarHidden = false;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem            *buttonItem;
//    
//    buttonItem = [[ UIBarButtonItem alloc ] initWithTitle: @"Back"
//                                                    style: UIBarButtonItemStyleBordered
//                                                   target: self
//                                                   action: @selector( goBack: ) ];
//    self.navigationController.toolbarItems = [ NSArray arrayWithObject: buttonItem ];
//    [ buttonItem release ];
    
    // SORT SORTED DATA
    if(![level isEqualToString:@"MAIN"]) {

        
        if(self.sortedData != nil && [sortedData isKindOfClass:[NSArray class]]) {
            self.sortedData = [sortedData sortedArrayUsingComparator:^(id item1, id item2) {
                NSNumber *value1 = [item1 objectForKey:@"number"];
                NSNumber *value2 = [item2 objectForKey:@"number"];
                //NSLog(@"item 1: %@, item 2:%@",value1,value2);
                return [value1 compare:value2];
            }];
            
            // REVERSE ARRAY
            self.sortedData = [[sortedData reverseObjectEnumerator] allObjects];
        }
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.level = nil;
    self.data = nil;
    self.sortedData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [TableHelperClass changeCellOrientation:cell toOrientation:self.interfaceOrientation];
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

- (void)dealloc {
    [level release];
    [data release];
    [sortedData release];
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
    static NSString *CellIdentifier = @"DetailCell";
    
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
        [cellStats setTextColor:[UIColor colorWithRed:0.84 green:0.58 blue:0.23 alpha:1]];
        [cellStats setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [cellStats setAdjustsFontSizeToFitWidth:true];
        [cellStats setMinimumFontSize: 8.0];
        [cellStats setTextAlignment:UITextAlignmentRight];
        [cellStats setTag:3];
        
        UILabel *cellSubStats = [[UILabel alloc] init];
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
        
        [[cell viewWithTag:2] setHidden:true];

    } else {
        // clean up the reused cell
        [(UILabel *)[cell viewWithTag:1] setText:nil];
        [(UILabel *)[cell viewWithTag:2] setText:nil];
        [(UILabel *)[cell viewWithTag:3] setText:nil];
        [(UILabel *)[cell viewWithTag:4] setText:nil];
    }
    
    // selection styles
    if([level isEqualToString:@"MAIN"]) {
        if(indexPath.section == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide selection style
            [cell setAccessoryType:UITableViewCellAccessoryNone]; // hide selection arrow
        } else if(indexPath.section == 1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray]; // show selection style
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; // show selection arrow
        }
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; // hide selection style
        [cell setAccessoryType:UITableViewCellAccessoryNone]; // hide selection arrow
    }
    
    // number style
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setAlwaysShowsDecimalSeparator:false];
    [numberFormatter setLocale:[NSLocale autoupdatingCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    // date style
    NSDateFormatterStyle timeStyle;
    NSDateFormatterStyle dateStyle;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    // LEVEL MAIN
    if([level isEqualToString:@"MAIN"]) {
        
        // hide the subtexts
//        [[cell viewWithTag:2] setHidden:true];
        
        if(indexPath.section == 0) {
            
            // VISITORS
            if(indexPath.row == 0) {
                [(UILabel *)[cell viewWithTag:1] setText:NSLocalizedString(@"DETAILVIEWS_VISITORS", nil)];
                [(UILabel *)[cell viewWithTag:3] setText:[numberFormatter
                                               stringForObjectValue:[[data objectForKey:@"statistics"] objectForKey:@"userVisitCount"]]];
                if([[data objectForKey:@"statistics"] objectForKey:@"userVisitCountAdd"] != nil)
                    [(UILabel *)[cell viewWithTag:4] setText:[@"+" stringByAppendingString:[[[data objectForKey:@"statistics"] objectForKey:@"userVisitCountAdd"] stringValue]]];
            }
            // WEBCRAWLER
            else if(indexPath.row == 1) {
                [(UILabel *)[cell viewWithTag:1] setText:NSLocalizedString(@"DETAILVIEWS_WEBCRAWLER", nil)];
                [(UILabel *)[cell viewWithTag:3] setText:[numberFormatter
                                               stringForObjectValue:[[data objectForKey:@"statistics"] objectForKey:@"robotVisitCount"]]];
                if([[data objectForKey:@"statistics"] objectForKey:@"robotVisitCountAdd"] != nil)
                    [(UILabel *)[cell viewWithTag:4] setText:[@"+" stringByAppendingString:[[[data objectForKey:@"statistics"] objectForKey:@"robotVisitCountAdd"] stringValue]]];
            }
            
            // FIRST VISIT / LAST VISIT
            else if(indexPath.row == 2 || indexPath.row == 3) {
                
                NSDate *visitDate;
                NSString *visitDateText;
                if(indexPath.row == 2) {
                    visitDateText = NSLocalizedString(@"DETAILVIEWS_FIRSTVISIT", nil);
                    visitDate = [NSDate dateWithTimeIntervalSince1970:[[[data objectForKey:@"statistics"] objectForKey:@"firstVisit"] intValue]];
                }
                if(indexPath.row == 3) {
                    visitDateText = NSLocalizedString(@"DETAILVIEWS_LASTVISIT", nil);
                    visitDate = [NSDate dateWithTimeIntervalSince1970:[[[data objectForKey:@"statistics"] objectForKey:@"lastVisit"] intValue]];
                }                
                
                [(UILabel *)[cell viewWithTag:1] setText:visitDateText];
                
                timeStyle = dateFormatter.timeStyle;
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [(UILabel *)[cell viewWithTag:3] setText:[dateFormatter stringFromDate:visitDate]];
                [dateFormatter setTimeStyle:timeStyle];
                
                dateStyle = dateFormatter.dateStyle;
                [dateFormatter setDateStyle:NSDateFormatterNoStyle];
                [(UILabel *)[cell viewWithTag:4] setText:[dateFormatter stringFromDate:visitDate]];
                [dateFormatter setDateStyle:dateStyle];
                
            }
            
        } else if(indexPath.section == 1) {
            
            // SEARCHWORDS
            if(indexPath.row == 0) {
                [(UILabel *)[cell viewWithTag:1] setText:NSLocalizedString(@"DETAILVIEWS_SEARCHWORDS", nil)];
            }
            // BROWSER STATISTICS
            else if(indexPath.row == 1) {
                [(UILabel *)[cell viewWithTag:1] setText:NSLocalizedString(@"DETAILVIEWS_BROWSERSTATS", nil)];
            }
            // PAGE STATISTICS
            else if(indexPath.row == 2) {
                [(UILabel *)[cell viewWithTag:1] setText:NSLocalizedString(@"DETAILVIEWS_PAGESTATS", nil)];
            }
        }
        
    // SHOW SORTED DATA
    } else if(self.sortedData != nil) {
        
        // hide the subtexts
        [[cell viewWithTag:4] setHidden:true];
        
        if([level isEqualToString:@"PAGES"]) {
            [(UILabel *)[cell viewWithTag:1] setText:[[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"]];
        } else {
            [(UILabel *)[cell viewWithTag:1] setText:[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"]];
        }
       
        [(UILabel *)[cell viewWithTag:3] setText:[numberFormatter stringForObjectValue:[[sortedData objectAtIndex:indexPath.row] objectForKey:@"number"]]];
        
        if([[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"lastVisit"] != nil) {
            
            // first visit
            [(UILabel *)[cell viewWithTag:2] setText:[NSLocalizedString(@"STATSSUBTEXT_FIRSTVISIT", nil) stringByAppendingString:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"firstVisit"] intValue]]]]];
            
            
            // last visit
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            [(UILabel *)[cell viewWithTag:4] setText:[NSLocalizedString(@"STATSSUBTEXT_LASTVISIT", nil) stringByAppendingString:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[sortedData objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"lastVisit"] intValue]]]]];
        }
    }
    
    [numberFormatter release];
    [dateFormatter release];
    [TableHelperClass changeCellOrientation:cell toOrientation:self.interfaceOrientation];
    return cell;
}

#pragma mark - Table view delegate

// SELECT ROW
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    
    if([level isEqualToString:@"MAIN"]) {
        DetailStatsViewController *detailViewController = [[DetailStatsViewController alloc] initWithNibName:@"DetailStatsViewController" bundle:nil];
        
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return true;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        [TableHelperClass changeCellOrientation:cell toOrientation:toInterfaceOrientation];
    }
}

@end

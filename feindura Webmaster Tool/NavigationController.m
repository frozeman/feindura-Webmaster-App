//
//  NavigationController.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 27.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "NavigationController.h"
#import "DetailStatsViewController.h"
#import "RootViewController.h"

@implementation NavigationController

@synthesize accounts,rootView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // LOAD feindura Accounts
        FeinduraAccounts *tmpAccounts = [[FeinduraAccounts alloc] init];
        self.accounts = tmpAccounts;
        [tmpAccounts release];
        
        [self.accounts setNavController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.accounts = nil;
    self.rootView = nil;
}

- (void)dealloc {
    [accounts release];
    [rootView release];
    [super dealloc];
}

#pragma marks Delegates

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return true;
}


#pragma mark Methods

-(void)reloadCell:(NSString *)accountId {
    NSLog(@"RELOAD CELL: %@",accountId);
    
    // -> DetailStatsViewController
    if([self.visibleViewController isKindOfClass:[DetailStatsViewController class]]) {
        DetailStatsViewController *detailView = (DetailStatsViewController *)self.visibleViewController;
        
        // get feindura account id from the current detail view controller
        NSString *accountKey = [detailView.data objectForKey:@"id"];
        
        if([accountKey isEqualToString:accountId]) {
            NSDictionary *feinduraAccount = [self.accounts.dataBase objectForKey:accountKey];
            [detailView setData: feinduraAccount];
            [detailView.tableView reloadData];
        }
    
    
    } 
    
    // -> RootViewController
    // get the cell row
    NSArray *sortOrder = [accounts.dataBase objectForKey:@"sortOrder"];
    NSUInteger indexRow = [sortOrder indexOfObject:accountId];  
    
    // reload the cell
    [self.rootView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexRow inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

@end

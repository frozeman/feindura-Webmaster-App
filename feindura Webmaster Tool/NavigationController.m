//
//  NavigationController.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 27.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "NavigationController.h"
#import "RootViewController.h"
#import "DetailStatsViewController.h"

@implementation NavigationController

@synthesize accounts;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // LOAD feindura Accounts
        SyncFeinduraAccounts *tmpAccounts = [[SyncFeinduraAccounts alloc] init];
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
}

- (void)dealloc {
    [accounts release];
    [super dealloc];
}

#pragma marks Delegates

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return true;
}


#pragma mark Methods

-(void)reloadData {
    NSLog(@"RELOAD TABLE");
    
    // DetailStatsViewController
    if([self.visibleViewController isKindOfClass:[DetailStatsViewController class]]) {
        DetailStatsViewController *tmpController = (DetailStatsViewController *)self.visibleViewController;
        
        // get feindura account id from the current detail viewcontroller
        NSString *accountKey = [tmpController.data objectForKey:@"id"];
        NSDictionary *feinduraAccount = [self.accounts.dataBase objectForKey:accountKey];
        [tmpController setData: feinduraAccount];
        
        [tmpController.tableView reloadData];
    } else {
        for (UIViewController *view in self.viewControllers) {
            // RootViewController
            if([view isKindOfClass:[RootViewController class]]) {
                RootViewController *tmpController = (RootViewController *)view;
                
                [tmpController.tableView reloadData];
            }
        }
    }
}

@end

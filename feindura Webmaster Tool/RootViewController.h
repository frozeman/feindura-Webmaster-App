//
//  RootViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFeinduraViewController.h"
#import "syncFeinduraAccounts.h"

@class feindura_Webmaster_ToolAppDelegate;

@interface RootViewController : UITableViewController <AddFeinduraViewControllerDelegate> {
    feindura_Webmaster_ToolAppDelegate *appDelegate;
    syncFeinduraAccounts *feinduraAccounts;
    IBOutlet UITableView *uiTableView;
    IBOutlet UINavigationItem *titleBar;
}

@property(nonatomic,retain) feindura_Webmaster_ToolAppDelegate *appDelegate;
@property(nonatomic,retain) syncFeinduraAccounts *feinduraAccounts;
@property(nonatomic,retain) IBOutlet UITableView *uiTableView;
@property (nonatomic,retain) UINavigationItem *titleBar;

-(IBAction)showAddFeinduraView:(id)sender;
-(IBAction)editFeinduraAccounts:(id)sender;
-(IBAction)refreshFeinduraAccounts:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

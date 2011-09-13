//
//  RootViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeinduraAccountViewController.h"
#import "SyncFeinduraAccounts.h"
#import "TableHelperClass.h"

@class feindura_Webmaster_ToolAppDelegate;

@interface RootViewController : UITableViewController <FeinduraAccountViewControllerDelegate> {
    feindura_Webmaster_ToolAppDelegate *appDelegate;
    SyncFeinduraAccounts *feinduraAccounts;
    IBOutlet UITableView *uiTableView;
    IBOutlet UINavigationItem *titleBar;
    IBOutlet UIBarButtonItem *editButton;
}

@property(nonatomic,retain) feindura_Webmaster_ToolAppDelegate *appDelegate;
@property(nonatomic,retain) SyncFeinduraAccounts *feinduraAccounts;
@property(nonatomic,retain) IBOutlet UITableView *uiTableView;
@property(nonatomic,retain) IBOutlet UINavigationItem *titleBar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *editButton;

-(IBAction)showAddFeinduraAccountView:(id)sender;
-(void)showEditFeinduraAccountView:(NSDictionary *)account;
-(IBAction)editFeinduraAccounts:(id)sender;
-(IBAction)refreshFeinduraAccounts:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

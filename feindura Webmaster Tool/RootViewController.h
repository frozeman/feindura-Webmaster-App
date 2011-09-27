//
//  RootViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "FeinduraAccountViewController.h"
#import "TableHelperClass.h"

@class feindura_Webmaster_ToolAppDelegate;

@interface RootViewController : UITableViewController <FeinduraAccountViewControllerDelegate> {
    NavigationController *navController;
    
    IBOutlet UINavigationItem *titleBar;
    IBOutlet UIBarButtonItem *editButton;

}

@property(nonatomic,retain) NavigationController *navController;
@property(nonatomic,retain) IBOutlet UINavigationItem *titleBar;
@property(nonatomic,retain) IBOutlet UIBarButtonItem *editButton;

-(IBAction)showAddFeinduraAccountView:(id)sender;
-(void)showEditFeinduraAccountView:(NSDictionary *)account;
-(IBAction)editFeinduraAccounts:(id)sender;
-(IBAction)reloadData:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

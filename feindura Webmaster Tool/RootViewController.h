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

@interface RootViewController : UITableViewController <AddFeinduraViewControllerDelegate> {
    syncFeinduraAccounts *feinduraAccounts;
    IBOutlet UITableView *uiTableView;
}

@property(nonatomic,retain) syncFeinduraAccounts *feinduraAccounts;
@property(nonatomic,retain) IBOutlet UITableView *uiTableView;

-(IBAction)showAddFeinduraView:(id)sender;
-(IBAction)editFeinduraAccounts:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

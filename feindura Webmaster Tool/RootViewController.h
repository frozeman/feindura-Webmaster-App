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
    NSMutableArray *tableList;
    syncFeinduraAccounts *feinduraAccounts;
}

@property(nonatomic,retain) NSMutableArray *tableList;
@property(nonatomic,retain) syncFeinduraAccounts *feinduraAccounts;

-(IBAction)showAddFeinduraView:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

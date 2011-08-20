//
//  RootViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFeinduraViewController.h"

@interface RootViewController : UITableViewController <AddFeinduraViewControllerDelegate> {
    NSMutableArray *feinduraStats;
}

@property(nonatomic,retain) NSMutableArray *feinduraStats;

-(IBAction)showAddFeinduraView:(id)sender;


#pragma mark Delegates

-(void)DismissAddFeinduraView;


@end

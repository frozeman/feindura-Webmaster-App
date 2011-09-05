//
//  feinduraDetailStatsViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 18.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@interface FeinduraDetailStatsViewController : UITableViewController {
    NSInteger level;
    NSDictionary *feinduraAccount;
    
    IBOutlet UITableView *uiTableView;
}

@property(nonatomic,assign) NSInteger level;
@property(nonatomic,retain) NSDictionary *feinduraAccount;
@property(nonatomic,retain) IBOutlet UITableView *uiTableView;

@end

//
//  feinduraDetailStatsViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 18.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@interface DetailStatsViewController : UITableViewController {
    NavigationController *navController;
    NSString *level;
    NSDictionary *data;
    NSArray *sortedData;
}

@property(nonatomic,retain) NavigationController *navController;
@property(nonatomic,retain) NSString *level;
@property(nonatomic,retain) NSDictionary *data;
@property(nonatomic,retain) NSArray *sortedData;

-(void)reloadData; // for the reload button

@end

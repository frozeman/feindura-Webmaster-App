//
//  feinduraDetailStatsViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 18.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeinduraDetailStatsViewController : UITableViewController {
    NSMutableArray *feinduraDetailStats;
}

@property(nonatomic,retain) NSMutableArray *feinduraDetailStats;

@end

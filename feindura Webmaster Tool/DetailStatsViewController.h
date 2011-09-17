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
    NSString *level;
    NSDictionary *data;
    NSArray *sortedData;
}

@property(nonatomic,retain) NSString *level;
@property(nonatomic,retain) NSDictionary *data;
@property(nonatomic,retain) NSArray *sortedData;

@end

//
//  NavigationController.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 27.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncFeinduraAccounts.h"

@interface NavigationController : UINavigationController {

    SyncFeinduraAccounts *accounts;
}

@property(nonatomic,retain) SyncFeinduraAccounts *accounts;

-(void)reloadData;

@end

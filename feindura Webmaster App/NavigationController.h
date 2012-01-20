//
//  NavigationController.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 27.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeinduraAccounts.h"

@class RootViewController;

@interface NavigationController : UINavigationController {

    FeinduraAccounts *accounts;
    RootViewController *rootView;
}

@property(nonatomic,retain) FeinduraAccounts *accounts;
@property(nonatomic,retain) RootViewController *rootView;

-(void)reloadCell:(NSString *)accountId;

@end

//
//  feindura_Webmaster_ToolAppDelegate.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class RootViewController;

@interface feindura_Webmaster_ToolAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    IBOutlet UINavigationController *navigationController;
	IBOutlet RootViewController *rootViewController;
    IBOutlet UINavigationItem *titleBar;    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic,retain) UINavigationItem *titleBar;

@end

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
    IBOutlet NavigationController *navigationController;
	IBOutlet RootViewController *rootViewController;
    
    BOOL appInactive;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, assign) BOOL appInactive;

@end

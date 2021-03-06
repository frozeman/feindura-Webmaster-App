//
//  feindura_Webmaster_ToolAppDelegate.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "feindura_Webmaster_ToolAppDelegate.h"

@implementation feindura_Webmaster_ToolAppDelegate

@synthesize window;
@synthesize navigationController,rootViewController;
@synthesize appInactive;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.appInactive = false;

    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    [navigationController.toolbar setTintColor:[UIColor darkGrayColor]];
    
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    self.appInactive = true;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // update accounts when become active again
//    if(self.appInactive)
//        [navigationController.accounts updateAccounts];
    self.appInactive = false;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [navigationController release];
    [rootViewController release];
	[window release];
    [super dealloc];
}

@end

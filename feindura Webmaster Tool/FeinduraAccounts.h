//
//  SyncFeinduras.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"

@class NavigationController;

@interface FeinduraAccounts : NSObject {
    NavigationController *navController;
    
    NSString *settingsFilePath;
    NSString *imagesPath;
    
    NSMutableDictionary *dataBase;
    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
    
    int countRequests;
}

#pragma mark Properties

@property(nonatomic,retain) NavigationController *navController;
@property(nonatomic,retain) NSString *settingsFilePath;
@property(nonatomic,retain) NSString *imagesPath;
@property(nonatomic,retain) NSMutableDictionary *dataBase;
@property(nonatomic,retain) Reachability *internetReachable;
@property(nonatomic,retain) Reachability *hostReachable;
@property(nonatomic,assign) BOOL internetActive;
@property(nonatomic,assign) int countRequests;

#pragma mark Methods

-(BOOL)createSettingsFile;
-(void)createImagesDirectory;

-(void)loadAccounts;
-(void)saveAccounts;
-(void)saveAccountsWithoutReloadTable;
-(BOOL)updateAccounts;
-(void)saveFavicon:(NSDictionary *)account;

#pragma mark Delegates

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;


@end

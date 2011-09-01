//
//  SyncFeinduras.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "Reachability.h"

@class RootViewController;

@interface syncFeinduraAccounts : NSObject {
    NSString *settingsFilePath;
    NSMutableDictionary *dataBase;
    ASIFormDataRequest *httpRequest;
    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
    
    RootViewController *delegate;
}

#pragma mark Properties

@property(nonatomic,retain) NSString *settingsFilePath;
@property(nonatomic,retain) NSMutableDictionary *dataBase;
@property(nonatomic,retain) ASIFormDataRequest *httpRequest;
@property(nonatomic,retain) Reachability *internetReachable;
@property(nonatomic,retain) Reachability *hostReachable;
@property(nonatomic,assign) BOOL internetActive;
@property(nonatomic,retain) RootViewController *delegate;

#pragma mark Methods

-(syncFeinduraAccounts *)initWithoutInternet;
-(BOOL)setSettingsPath;

-(void)loadAccounts;
-(void)saveAccounts;
-(BOOL)updateAccounts;

#pragma mark Delegates

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;


@end

//
//  SyncFeinduras.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@class ASIFormDataRequest;
@class Reachability;

@interface syncFeinduraAccounts : NSObject {
    NSString *settingsFilePath;
    NSMutableDictionary *dataBase;
    
    ASIFormDataRequest *request;
    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
}

#pragma mark Properties

@property(nonatomic,retain) NSString *settingsFilePath;
@property(nonatomic,retain) NSMutableDictionary *dataBase;
@property(nonatomic,retain) ASIFormDataRequest *request;
@property(nonatomic,retain) Reachability *internetReachable;
@property(nonatomic,retain) Reachability *hostReachable;
@property(nonatomic,assign) BOOL internetActive;

#pragma mark Methods

-(void)loadAccounts;
-(void)saveAccounts;
-(BOOL)updateAccounts;

#pragma mark Delegates

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;


@end

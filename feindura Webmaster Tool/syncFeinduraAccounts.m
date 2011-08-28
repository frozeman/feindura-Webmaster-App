//
//  SyncFeinduras.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "syncFeinduraAccounts.h"

@implementation syncFeinduraAccounts

@synthesize settingsFilePath;
@synthesize dataBase;
@synthesize request;
@synthesize internetReachable, hostReachable, internetActive; // Check Network

- (id)init
{
    self = [super init];
    if (self) {
        
        // -> CHECK for Internet Connection
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        self.internetReachable = [Reachability reachabilityForInternetConnection];
        [self.internetReachable startNotifier];
        // check if a pathway to a random host exists
        self.hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"];
        [self.hostReachable startNotifier];
        
        // -> load account database
        if([self setSettingsPath]) {
            [self loadAccounts];
        } else
            return false;
    }
    
    return self;
}

- (id)initWithoutInternet
{
    self = [super init];
    if (self) {
        
        // -> load account database
        if([self setSettingsPath]) {
            [self loadAccounts];
        } else
            return false;
    }
    
    return self;
}

-(id)setSettingsPath {
    BOOL settingsFileExist;
    NSError *fileError;
    
    // ->> GET settings.plist PATH
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.settingsFilePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    
    // -> if doesnt exist, create a new settings.plist file
    settingsFileExist = [fileManager fileExistsAtPath:self.settingsFilePath];
    if(!settingsFileExist) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        settingsFileExist = [fileManager copyItemAtPath:path toPath:self.settingsFilePath error:&fileError];
    }
    
    return settingsFileExist;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [settingsFilePath release];
    [dataBase release];
    [request release];
    [internetReachable release];
    [hostReachable release];
    [super dealloc];
}

#pragma mark Methods

- (void)loadAccounts {
    self.dataBase = nil;
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingsFilePath];
    self.dataBase = tmp;
    [tmp release];
}

- (void)saveAccounts {
    [self.dataBase writeToFile:self.settingsFilePath atomically: YES];

}

- (BOOL)updateAccounts {
    
    if(self.internetActive) {
        /*
        NSURL *cmsUrl = [NSURL URLWithString:self.url.text];
        self.request = [ASIFormDataRequest requestWithURL:cmsUrl];
        [self.request setDelegate:self];
        [self.request setPostValue:self.username.text forKey:@"username"];
        [self.request setPostValue:self.password.text forKey:@"password"];
        [self.request startAsynchronous];
         */
    }
    
    [self loadAccounts];
    return true;
}

// called after network status changes 
- (void)checkNetworkStatus:(NSNotification *)notice {
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = false;
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = true;
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = true;
            break;
            
        }
    }
}

#pragma mark Delegates

// ->> ASIHTTPRequestDelegates

// -> START
- (void)requestStarted:(ASIHTTPRequest *)request {
    NSLog(@"request started");
    // TODO: change status bar text
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {}

// -> FINISHED
- (void)requestFinished:(ASIHTTPRequest *)requestResponse {
    NSLog(@"request finsihed");
    
    // Use when fetching binary data
    //NSData *responseData = [requestResponse responseData];
    
    NSString *responseString = [requestResponse responseString];
    
    if([responseString isEqualToString:@"TRUE"]) {
        //[self saveFeinduraAccount];
    } else if([responseString isEqualToString:@"FALSE"]) {
        //[self.wrongAccount show];
        //[self.username becomeFirstResponder];
    } else {
        //[self.wrongFeinduraUrl show];
        //[self.url becomeFirstResponder];
    }
}

// -> FAILED
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"request failed");
    
    //[self.wrongUrl show];
    //[self.url becomeFirstResponder];
    
    //NSError *error = [request error];
    
}


@end

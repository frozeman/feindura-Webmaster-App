//
//  SyncFeinduras.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "syncFeinduraAccounts.h"
#import "RootViewController.h"
#import "SBJson.h"
#import "SFHFKeychainUtils.h"

static NSString *feinduraControllerPath = @"/library/controllers/feinduraWebmasterTool.controller.php";

@implementation syncFeinduraAccounts

@synthesize settingsFilePath;
@synthesize dataBase;
@synthesize httpRequest;
@synthesize internetReachable, hostReachable, internetActive; // Check Network
@synthesize delegate;

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

-(BOOL)setSettingsPath {
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
    
    self.dataBase = nil;
    self.settingsFilePath = nil;
    self.httpRequest = nil;
    self.internetReachable = nil;
    self.hostReachable = nil;
    
    [settingsFilePath release];
    [dataBase release];
    [httpRequest release];
    [internetReachable release];
    [hostReachable release];
    [super dealloc];
}

#pragma mark Methods

- (void)loadAccounts {
    self.dataBase = nil;
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingsFilePath];
    self.dataBase = tmp;
    //NSLog(@"DB %@",self.dataBase);
    [tmp release];
}

- (void)saveAccounts {
    [self.dataBase writeToFile:self.settingsFilePath atomically: YES];

}

- (BOOL)updateAccounts {
    
    [self loadAccounts];
    
    // -> FETCH NEW ACCOUNT DATA
    NSError *keychainError;
    // get feindura account keys
    NSArray *accountIds = [self.dataBase allKeys];
    
    // start loading new data from the servers
    for (NSString *accountId in accountIds) {
        if(self.internetActive) {
            // ADD feinduraControllerPath
            NSURL *cmsUrl = [NSURL URLWithString:[[[self.dataBase objectForKey:accountId] objectForKey:@"url"] stringByAppendingString:feinduraControllerPath]];
            //NSLog(@"FULLURL %@",cmsUrl.absoluteURL);
            
            // START REQUEST
            // username,password,status=fetch,id
            self.httpRequest = [ASIFormDataRequest requestWithURL:cmsUrl];
            [self.httpRequest setDelegate:self];
            [self.httpRequest setPostValue:[[self.dataBase objectForKey:accountId] objectForKey:@"account"] forKey:@"username"];
            [self.httpRequest setPostValue:[SFHFKeychainUtils getPasswordForUsername:[[self.dataBase objectForKey:accountId] objectForKey:@"account"]
                                                              andServiceName: [[self.dataBase objectForKey:accountId] objectForKey:@"url"]
                                                              error:&keychainError]
                              forKey:@"password"];
            [self.httpRequest setPostValue:@"fetch" forKey:@"status"];
            [self.httpRequest setUserInfo:[NSDictionary dictionaryWithObject:accountId forKey:@"id"]]; // set id to identify request
            [self.httpRequest startAsynchronous];
        } else
            return false;
    }    
    return true;
}

#pragma mark Selectors

// called after network status changes 
- (void)checkNetworkStatus:(NSNotification *)notice {    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable: {
            NSLog(@"The internet is down.");
            self.internetActive = false;
            break;
            
        }
        case ReachableViaWiFi: {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = true;
            break;
            
        }
        case ReachableViaWWAN: {
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
    NSLog(@"START fetching new account data from server");
    // TODO: change status bar text
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {}

// -> FINISHED
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"END fetching new account data from server");
    
    //...

    // STORE success status
    NSMutableDictionary *succedAccount = [self.dataBase objectForKey:[request.userInfo valueForKey:@"id"]];
    [succedAccount setValue:@"works" forKey:@"status"];
    [self.dataBase setObject:succedAccount forKey:[request.userInfo valueForKey:@"id"]];
    NSLog(@"%@",succedAccount);
    [self saveAccounts];

    // reload the tableList
    RootViewController *delagateTemp = ((RootViewController *)self.delegate);  
    [delagateTemp.uiTableView reloadData];
    self.httpRequest = nil;
}

// -> FAILED
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"FAILED fetching new account data from server");
    
    // STORE failed status
    NSMutableDictionary *failedAccount = [self.dataBase objectForKey:[request.userInfo valueForKey:@"id"]];    
    [failedAccount setValue:@"failed" forKey:@"status"];
    [self.dataBase setObject:failedAccount forKey:[self.dataBase objectForKey:[request.userInfo valueForKey:@"id"]]];
    
    [self saveAccounts];
    
    // reload the tableList
    RootViewController *delagateTemp = ((RootViewController *)self.delegate);  
    [delagateTemp.uiTableView reloadData];
    self.httpRequest = nil;
}


@end

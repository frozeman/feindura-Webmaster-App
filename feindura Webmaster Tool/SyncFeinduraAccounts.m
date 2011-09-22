//
//  SyncFeinduras.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "SyncFeinduraAccounts.h"
#import "RootViewController.h"
#import "SBJson.h"
#import "SFHFKeychainUtils.h"


@implementation SyncFeinduraAccounts

// STATIC
static NSString *feinduraControllerPath = @"/library/controllers/feinduraWebmasterTool-0.2.controller.php";

// PROPERTIES
@synthesize settingsFilePath,imagesPath;
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
        [internetReachable startNotifier];
        // check if a pathway to a random host exists
        self.hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"];
        [hostReachable startNotifier];
        
        [self createImagesDirectory];
        
        // -> load account database
        if([self createSettingsFile]) {
            [self loadAccounts];
        } else
            return false;
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hostReachable stopNotifier];
    [internetReachable stopNotifier];
    
    [settingsFilePath release];
    [imagesPath release];
    [dataBase release];
    [httpRequest release];
    [internetReachable release];
    [hostReachable release];
    [delegate release];
    [super dealloc];
}

#pragma mark Methods

-(BOOL)createSettingsFile {
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]; // use default settings.plist
        settingsFileExist = [fileManager copyItemAtPath:path toPath:self.settingsFilePath error:&fileError];
    }
    
    return settingsFileExist;
}

-(void)createImagesDirectory {
    
    // vars
    NSError *error;    
    
    // ->> GET settings.plist PATH
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // CREATE IMAGE DIR
    self.imagesPath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    if (![fileManager fileExistsAtPath:self.imagesPath]) {	//Does directory already exist?
		if (![fileManager createDirectoryAtPath:self.imagesPath
									   withIntermediateDirectories:NO
														attributes:nil
															 error:&error]) {
			NSLog(@"Couldn't create Image directory: %@", error);
		}
	}
}

- (void)loadAccounts {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingsFilePath];
    self.dataBase = tmp;
    [tmp release];
    //NSLog(@"DB %@",self.dataBase);
    
    // reload table
    [delegate.tableView reloadData];
}

- (void)saveAccounts {
    [dataBase writeToFile:self.settingsFilePath atomically: YES];

}

- (BOOL)updateAccounts {
    
    if(self.internetActive) {        
        // -> FETCH NEW ACCOUNT DATA
        NSError *keychainError;
        
        // start loading new data from the servers
        for (NSString *accountId in [dataBase objectForKey:@"sortOrder"]) {
            
                // ADD feinduraControllerPath
                NSURL *cmsUrl = [NSURL URLWithString:[[[dataBase objectForKey:accountId] objectForKey:@"url"] stringByAppendingString:feinduraControllerPath]];
                //NSLog(@"FULLURL %@",cmsUrl.absoluteURL);
                
                // START REQUEST
                // username,password,status=fetch,id
                self.httpRequest = [ASIFormDataRequest requestWithURL:cmsUrl];
                [httpRequest setDelegate:self];
                [httpRequest setPostValue:[[dataBase objectForKey:accountId] objectForKey:@"account"] forKey:@"username"];
                [httpRequest setPostValue:[SFHFKeychainUtils getPasswordForUsername:[[dataBase objectForKey:accountId] objectForKey:@"account"]
                                                                  andServiceName: [[dataBase objectForKey:accountId] objectForKey:@"url"]
                                                                  error:&keychainError]
                                  forKey:@"password"];
                [httpRequest setPostValue:@"FETCH" forKey:@"status"];
                [httpRequest setUserInfo:[NSDictionary dictionaryWithObject:accountId forKey:@"id"]]; // set id to identify request
                [httpRequest startAsynchronous];
            
        }
        return true;
    } else {
        [self loadAccounts];
        return false;
    }    
}

-(void)saveFavicon:(NSDictionary *)account {
    
    NSString *imageUrlString = [NSString stringWithFormat:@"%@apple-touch-icon.png", [account objectForKey:@"websiteUrl"]];
    
    NSURL *url = [NSURL URLWithString:imageUrlString];
    UIImage *downloadedImage = [[UIImage alloc] initWithContentsOfFile:[[ASIDownloadCache sharedCache] pathToCachedResponseDataForURL:url]];
    if([downloadedImage CGImage] != nil) {        
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", self.imagesPath,[account objectForKey:@"id"]];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(downloadedImage)];
        [imageData writeToFile:pngFilePath atomically:YES];
    }
    [downloadedImage release];
    
    // reload the tableList 
    [delegate.tableView reloadData];
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
            // update on when connection is available
            [self updateAccounts];
            break;
            
        }
        case ReachableViaWWAN: {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = true;
            // update on when connection is available
            [self updateAccounts];
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
    
    NSMutableDictionary *account = [[NSMutableDictionary alloc] initWithDictionary:[dataBase objectForKey:[request.userInfo objectForKey:@"id"]]];
    
    // if favicon request SAVE FAVICON
    if([request.userInfo objectForKey:@"type"] != nil && [[request.userInfo objectForKey:@"type"] isEqualToString:@"favicon"]) {
        [self saveFavicon:account];
        return;
    }
    
    // -> WRONG account
    if([request.responseString isEqualToString:@"FALSE"]) {    
        [account setObject:@"FAILED" forKey:@"status"];
        
    // -> TRY TO GET JSON DATA
    } else {
        // CORRECT data fetched
        NSDictionary *fetchedData = [request.responseString JSONValue];
//        NSLog(@"%@",request.responseString);
        
        if([fetchedData objectForKey:@"title"] != nil) {
            
            NSNumber *oldUserVisitCountAdd = [[account objectForKey:@"statistics"] objectForKey:@"userVisitCountAdd"];
            NSNumber *userVisitCountBefore = [[account objectForKey:@"statistics"] objectForKey:@"userVisitCount"];
            NSNumber *userVisitCountNow = [[fetchedData objectForKey:@"statistics"] objectForKey:@"userVisitCount"];
            NSNumber *userVisitCountAdd =  [NSNumber numberWithInt:[userVisitCountNow intValue] - [userVisitCountBefore intValue]];
            
            NSNumber *oldRobotVisitCountAdd = [[account objectForKey:@"statistics"] objectForKey:@"robotVisitCountAdd"];
            NSNumber *robotVisitCountBefore = [[account objectForKey:@"statistics"] objectForKey:@"robotVisitCount"];
            NSNumber *robotVisitCountNow = [[fetchedData objectForKey:@"statistics"] objectForKey:@"robotVisitCount"];
            NSNumber *robotVisitCountAdd =  [NSNumber numberWithInt:[robotVisitCountNow intValue] - [robotVisitCountBefore intValue]];
            
            [account setObject:[fetchedData objectForKey:@"title"] forKey:@"title"]; // set title
            [account setObject:[fetchedData objectForKey:@"websiteUrl"] forKey:@"websiteUrl"]; // set websiteUrl
            if([fetchedData objectForKey:@"statistics"] != nil)
                [account setObject:[fetchedData objectForKey:@"statistics"] forKey:@"statistics"]; // set statistics
            if([fetchedData objectForKey:@"browser"] != nil)
                [[account objectForKey:@"statistics"] setObject:[fetchedData objectForKey:@"browser"] forKey:@"browser"]; // set browser
            [account setObject:@"WORKING" forKey:@"status"];

            // add userVisitCountAdd
            if(![userVisitCountAdd isEqualToNumber:[NSNumber numberWithInt:0]])
                [[account objectForKey:@"statistics"] setObject:userVisitCountAdd forKey:@"userVisitCountAdd"];
            else if(oldUserVisitCountAdd != nil)
                [[account objectForKey:@"statistics"] setObject:oldUserVisitCountAdd forKey:@"userVisitCountAdd"];
            else
                [[account objectForKey:@"statistics"] setObject:[NSNumber numberWithInt:0] forKey:@"userVisitCountAdd"];
            
            // add robotVisitCountAdd
            if(![robotVisitCountAdd isEqualToNumber:[NSNumber numberWithInt:0]])
                [[account objectForKey:@"statistics"] setObject:robotVisitCountAdd forKey:@"robotVisitCountAdd"];
            else if(oldRobotVisitCountAdd != nil)
                [[account objectForKey:@"statistics"] setObject:oldRobotVisitCountAdd forKey:@"robotVisitCountAdd"];
            else
                [[account objectForKey:@"statistics"] setObject:[NSNumber numberWithInt:0] forKey:@"robotVisitCountAdd"];
            
            
            // DOWNLOAD IMAGE
            if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.png", self.imagesPath,[request.userInfo objectForKey:@"id"]]]) {
                NSString *imageUrlString = [NSString stringWithFormat:@"%@apple-touch-icon.png", [account objectForKey:@"websiteUrl"]];
                NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
                __block ASIHTTPRequest *imageRequest = [ASIHTTPRequest requestWithURL:imageUrl];
                [imageRequest setDownloadCache:[ASIDownloadCache sharedCache]];
                [imageRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
                [imageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
                [imageRequest setSecondsToCache:86400];
                [imageRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[request.userInfo objectForKey:@"id"],@"id",@"favicon",@"type",nil]]; // set id to identify request
                [imageRequest setDelegate:self];
                [imageRequest startAsynchronous];
            }
            
        // WRONG feindura url
        } else {
            [account setObject:@"FAILED" forKey:@"status"];
        }
    }    

    // STORE success status    
    [dataBase setObject:account forKey:[request.userInfo objectForKey:@"id"]];
    [account release];
    
    [self saveAccounts];
    [self loadAccounts];

    // reload the tableList 
    //[delegate.tableView reloadData];
    self.httpRequest = nil;
}

// -> FAILED
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"FAILED fetching new account data from server");
    
    // STORE failed status
    NSMutableDictionary *failedAccount = [[NSMutableDictionary alloc] initWithDictionary:[dataBase objectForKey:[request.userInfo objectForKey:@"id"]]];    
    [failedAccount setObject:@"FAILED" forKey:@"status"];
    [dataBase setObject:failedAccount forKey:[request.userInfo objectForKey:@"id"]];
    [failedAccount release];
    
    [self saveAccounts];
    [self loadAccounts];
    
    // reload the tableList
    //[delegate.tableView reloadData];
    self.httpRequest = nil;
}

@end

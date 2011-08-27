//
//  AddFeinduraViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "AddFeinduraViewController.h"
#import "NSString+MD5.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "SFHFKeychainUtils.h"
#import "syncFeinduraAccounts.h"


@implementation AddFeinduraViewController

// PROPERTIES
@synthesize delegate;
@synthesize scrollView, titleBar; // TopBar
@synthesize urlTitle, accountTitle; // Labels
@synthesize url, username, password; //TextFields
@synthesize wrongUrl, wrongAccount, wrongFeinduraUrl; // Alerts
@synthesize request, internetReachable, hostReachable, internetActive; // Request
@synthesize feinduraAccounts;

// METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [feinduraAccounts release];
    [internetReachable release];
    [hostReachable release];
    [request clearDelegatesAndCancel];
    [request release];
    [wrongFeinduraUrl release];
    [wrongAccount release];
    [wrongUrl release];
    [urlTitle release];
    [accountTitle release];
    [url release];
    [username release];
    [password release];
    [titleBar release];
    [scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    syncFeinduraAccounts *tmp = [[syncFeinduraAccounts alloc] init];
    self.feinduraAccounts = tmp;
    [tmp release];
    
    /*
    //NSLog(@"process Name: %@ Process ID: %d",self.feinduraAccounts.settingsFilePath);
    for (id key in self.feinduraAccounts.dataBase) {
        
        NSLog(@"key: %@, value: %@", key, [self.feinduraAccounts.dataBase objectForKey:key]);
        
    }
     */
    
    // -> add a title which fits in the navbar
    UILabel *title = [[UILabel alloc] init];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[UIColor whiteColor]];
    [title setShadowColor:[UIColor darkGrayColor]];
    [title setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [title setText:NSLocalizedString(@"ADDFEINDURA_TITLE", nil)];
    [title sizeToFit];
    [title setAdjustsFontSizeToFitWidth:true];
    [self.titleBar setTitleView:title];
    [title release];
    
    // ->> add texts
    //self.titleBar.title = NSLocalizedString(@"ADDFEINDURA_TITLE", nil);
    self.urlTitle.text = NSLocalizedString(@"ADDFEINDURA_TITLE_URL", nil);
    self.accountTitle.text = NSLocalizedString(@"ADDFEINDURA_TITLE_ACCOUNT", nil);
    self.url.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_URL", nil);
    self.url.tag = 1;
    self.username.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_USERNAME", nil);
    self.username.tag = 2;
    self.password.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_PASSWORD", nil);
    self.password.tag = 3;
    
    // -> basic setup
    [self.url becomeFirstResponder];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                               self.password.frame.origin.y + self.password.frame.size.height + 15)];
    //[self.scrollView setContentOffset:CGPointMake(0,200)];
    
    // -> set up the ALerts
    UIAlertView *wrongUrlTemp = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_TITLE_WRONGURL", nil) message:NSLocalizedString(@"ADDFEINDURA_ALERT_TEXT_WRONGURL", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
    self.wrongUrl = wrongUrlTemp;
    [wrongUrlTemp release];
    
    UIAlertView *wrongAccountTemp = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_TITLE_WRONGACCOUNT", nil) message:NSLocalizedString(@"ADDFEINDURA_ALERT_TEXT_WRONGACCOUNT", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
    self.wrongAccount = wrongAccountTemp;
    [wrongAccountTemp release];
    
    UIAlertView *wrongFeinduraUrlTemp = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_TITLE_WRONGURL", nil) message:NSLocalizedString(@"ADDFEINDURA_ALERT_TEXT_WRONGFEINDURAURL", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
    self.wrongFeinduraUrl = wrongFeinduraUrlTemp;
    [wrongFeinduraUrlTemp release];
    
    // -> CHECK for Internet Connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    self.internetReachable = [Reachability reachabilityForInternetConnection];
    [self.internetReachable startNotifier];
    // check if a pathway to a random host exists
    self.hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"];
    [self.hostReachable startNotifier];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.feinduraAccounts = nil;
    self.internetReachable = nil;
    self.hostReachable = nil;
    self.wrongFeinduraUrl = nil;
    self.wrongAccount = nil;
    self.wrongUrl = nil;
    self.urlTitle = nil;
    self.accountTitle = nil;
    self.url = nil;
    self.username = nil;
    self.password = nil;
    self.titleBar = nil;
    self.scrollView = nil;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return false;
}
*/

#pragma mark Methods

- (IBAction)cancelAddFeindura:(id)sender {
	[delegate DismissAddFeinduraView];
}

- (void)checkFeinduraAccount {
    
    if(self.internetActive) {
        NSURL *cmsUrl = [NSURL URLWithString:self.url.text];
        self.request = [ASIFormDataRequest requestWithURL:cmsUrl];
        [self.request setDelegate:self];
        [self.request setPostValue:self.username.text forKey:@"username"];
        [self.request setPostValue:self.password.text forKey:@"password"];
        [self.request startAsynchronous];
    } else
        [self saveFeinduraAccount];
    
}

- (void)saveFeinduraAccount {    

    // -> STORE user data    
    NSError *keychainError;
    
    // ->> STORE password in keychain
    [SFHFKeychainUtils storeUsername:self.username.text andPassword:self.password.text forServiceName:self.url.text updateExisting:true error:&keychainError];
    
    /*
     to get it:
    [SFHFKeychainUtils getPasswordForUsername:self.username.text andServiceName: self.url.text error:&keychainError];
     */     

    // if account doesnt already exist OR has a new username
    if([self.feinduraAccounts.dataBase valueForKey:self.url.text] == nil || ([self.feinduraAccounts.dataBase valueForKey:self.url.text] != nil && ![[[self.feinduraAccounts.dataBase objectForKey:self.url.text] valueForKey:@"username"] isEqualToString: self.username.text])) {
        
        // create dictionaries for storing current feindura account
        NSMutableDictionary* currentAccount = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                   self.username.text,@"username",nil];
                                                //[self.password.text MD5],@"password", nil];
        // add new feindura account to the database
        [self.feinduraAccounts.dataBase setObject: currentAccount forKey:self.url.text];
        [self.feinduraAccounts saveAccounts];
        
        [currentAccount release];
    }
    
	[delegate DismissAddFeinduraView];
}

- (UITextField*)textFieldsAreEmpty {
    if([self.url.text isEqualToString:@""])
        return self.url;    
    else if([self.username.text isEqualToString:@""])
        return self.username;
    else if([self.password.text isEqualToString:@""])
        return self.password;
    else
        return false;
}

- (BOOL)validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
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

// -> ScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)sView {
	// return a view that will be scaled. If delegate returns nil, nothing happens
	return sView;
}

// ->> TextFieldDelegates

// -> CHANGE Return Button 
- (void)textFieldDidBeginEditing:(UITextField*)textField {
    if(textField.tag == 3 &&
       (self.textFieldsAreEmpty == false || self.textFieldsAreEmpty == textField) &&
       [self validateUrl:self.url.text])
        [textField setReturnKeyType:UIReturnKeyDone];
    else if(textField.tag == 3 || [self validateUrl:self.url.text] == false)
        [textField setReturnKeyType:UIReturnKeyNext];
}
// ->> JUMP to TextFields
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    switch (textField.tag) {
        // -> URL TextField
        case 1: {
            
                // add a slash on the end of the url
                self.url.text = [self.url.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
                //self.url.text = [self.url.text stringByAppendingString:@"/"];
            
                NSURL *cmsURL = [NSURL URLWithString:self.url.text];            
            
                // check if there is a scheme (like http://) in this url string
                if([cmsURL scheme] == nil) {
                    self.url.text = [[NSString stringWithString:@"http://"] stringByAppendingString:self.url.text];	
                }
                
                // -> JUMP to the next one, if is a valid url
                if([self validateUrl:self.url.text])                    
                    [[self.scrollView viewWithTag:2] becomeFirstResponder];
                // -> otherwise throw warning
                else {
                    [self.wrongUrl show];
                }                    
            }
            break;
            
        // -> USERNAME TextField
        case 2:
            // -> JUMP to the next one
            [[self.scrollView viewWithTag:3] becomeFirstResponder];
            break;
            
        // -> PASSWORD TextField
        case 3:
            // -> JUMP to the empty one 
            if([self textFieldsAreEmpty] != false)
                [[self textFieldsAreEmpty] becomeFirstResponder];
            // -> JUMP to url, if not valid
            if([self validateUrl:self.url.text] == false) {
                [self.wrongUrl show];
                [self.url becomeFirstResponder];
            // -> SAVE the data
            } else if([self textFieldsAreEmpty] == false)
                [self checkFeinduraAccount];
                
            break;
        default:
            [[self.scrollView viewWithTag:1] becomeFirstResponder];
            break;
    }
    return true;
}


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
    
    if([responseString isEqualToString:@"TRUE"])
        [self saveFeinduraAccount];
    else if([responseString isEqualToString:@"FALSE"]) {
        [self.wrongAccount show];
        [self.username becomeFirstResponder];
    } else {
        [self.wrongFeinduraUrl show];
        [self.url becomeFirstResponder];
    }
}

// -> FAILED
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"request failed");
    
    [self.wrongUrl show];
    [self.url becomeFirstResponder];
    
    //NSError *error = [request error];

}

@end

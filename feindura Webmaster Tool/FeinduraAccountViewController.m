//
//  AddFeinduraViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "FeinduraAccountViewController.h"
#import "NSString+MD5.h"
#import "SFHFKeychainUtils.h"
#import "RootViewController.h"

@implementation FeinduraAccountViewController

// STATIC
static NSString *feinduraControllerPath = @"/library/controllers/feinduraWebmasterTool-0.2.controller.php";

// PROPERTIES
@synthesize delegate,navController;
@synthesize scrollView, titleBar; // TopBar
@synthesize urlTitle, accountTitle; // Labels
@synthesize url, username, password; //TextFields
@synthesize wrongUrl, wrongAccount, wrongFeinduraUrl; // Alerts
@synthesize request; // Request
@synthesize editAccount;

// METHODS
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
*/

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // -> setting the nav controller
    self.navController = (NavigationController *)self.parentViewController;
    
    // -> BASIC SETUP
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
    [urlTitle setText:NSLocalizedString(@"ADDFEINDURA_TITLE_URL", nil)];
    [accountTitle setText:NSLocalizedString(@"ADDFEINDURA_TITLE_ACCOUNT", nil)];
    [url setPlaceholder:NSLocalizedString(@"ADDFEINDURA_TEXT_URL", nil)];
    [url setTag:1];
    [username setPlaceholder:NSLocalizedString(@"ADDFEINDURA_TEXT_USERNAME", nil)];
    [username setTag:2];
    [password setPlaceholder:NSLocalizedString(@"ADDFEINDURA_TEXT_PASSWORD", nil)];
    [password setTag:3];
    
    [url becomeFirstResponder];
    [scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                          self.password.frame.origin.y + self.password.frame.size.height + 15)];
    
    //[scrollView setContentOffset:CGPointMake(0,200)];
    
    // -> ADD ACCOUNT DATA if available
    if(self.editAccount != NULL) {
        [url setText:[editAccount objectForKey:@"url"]];
        [username setText:[editAccount objectForKey:@"account"]];
        //[password.text];
    }
    
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

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [request clearDelegatesAndCancel];
    
    self.editAccount = nil;
    self.request = nil;
    
    self.wrongFeinduraUrl = nil;
    self.wrongAccount = nil;
    self.wrongUrl = nil;
    
    self.password = nil;
    self.username = nil;
    self.url = nil;
    self.accountTitle = nil;
    self.urlTitle = nil;
    
    self.titleBar = nil;
    self.scrollView = nil;
    self.delegate = nil;
    self.navController = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    
    [editAccount release];  
    [request release];
    
    [wrongFeinduraUrl release];
    [wrongAccount release];
    [wrongUrl release];
    
    [password release];
    [username release];
    [url release];
    [accountTitle release];
    [urlTitle release];
    
    [titleBar release];
    [scrollView release];
    [delegate release];
    [navController release];
    
    [super dealloc];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return false;
}
*/

#pragma mark Methods

- (IBAction)buttonCancel:(id)sender {
	[delegate DismissAddFeinduraView];
}
- (IBAction)buttonSave:(id)sender {
    
    // repair url
    [self repairURL];
    
    // validate url
    if(![self validateUrl:self.url.text])
        [wrongUrl show];
    
    else if([url.text isEqualToString:@""])
        [url becomeFirstResponder];
    else if([username.text isEqualToString:@""])
        [username becomeFirstResponder];
    else if([password.text isEqualToString:@""])
        [password becomeFirstResponder];
    else
        [self checkFeinduraAccount];
}

- (void)checkFeinduraAccount {
    
    if(self.navController.accounts.internetActive) {
        NSString *urlString = [[NSString stringWithString:self.url.text] stringByAppendingString:feinduraControllerPath];
        NSURL *cmsUrl = [NSURL URLWithString:urlString];
        //NSLog(@"FULLURL %@",tempUrl);
        
        self.request = [ASIFormDataRequest requestWithURL:cmsUrl];
        [request setDelegate:self];
        [request setPostValue:@"CHECK" forKey:@"status"];
        [request setPostValue:self.username.text forKey:@"username"];
        [request setPostValue:[password.text MD5] forKey:@"password"];
        [request startAsynchronous];
    } else
        [self saveFeinduraAccount];
    
}

- (void)saveFeinduraAccount {    

    // vars   
    NSError *keychainError;
    NSString* accountId;
    BOOL accountAlreadyExists = false;
    
    // ->> STORE password in keychain
    [SFHFKeychainUtils storeUsername:self.username.text andPassword:[self.password.text MD5] forServiceName:self.url.text updateExisting:true error:&keychainError];
    
    /*
     to get it:
    [SFHFKeychainUtils getPasswordForUsername:self.username.text andServiceName: self.url.text error:&keychainError];
     */
    
    // STORE entered ACCOUNT DATA
    NSMutableDictionary* currentAccount = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    self.url.text,@"url",
                                    @"",@"title",
                                    self.username.text,@"account",nil];
    //[self.password.text MD5],@"password", nil];
    
    
    // if EXISTING ACCOUNT (if url matches an existing one)
    // TODO: currently its not possible to save one url twice, with different accounts ()
    for (NSString *accountKey in [navController.accounts.dataBase objectForKey:@"sortOrder"]) {
        if([[[navController.accounts.dataBase objectForKey:accountKey] objectForKey:@"url"] isEqualToString:self.url.text]) {
            accountAlreadyExists = true;
            accountId = accountKey;
            self.editAccount = [navController.accounts.dataBase objectForKey:accountKey];
        }
    }
    
    // if EDIT ACCOUNT
    if(self.editAccount != NULL) {
        if(!accountAlreadyExists)
            accountId = [editAccount objectForKey:@"id"];
        
        [currentAccount setObject:[editAccount objectForKey:@"title"] forKey:@"title"];
        [currentAccount setObject:[editAccount objectForKey:@"statistics"] forKey:@"statistics"];
    
    // if NEW ACCOUNT
    } else {
        // generate unique key
        CFUUIDRef identifier = CFUUIDCreate(NULL);
        accountId = (NSString*)CFUUIDCreateString(NULL, identifier);
        CFRelease(identifier);
        
        // add new accountId to the order array
        NSMutableArray *sortOrderArray = [[NSMutableArray alloc] initWithArray:[navController.accounts.dataBase objectForKey:@"sortOrder"]];
        [sortOrderArray addObject:accountId];
        [currentAccount setObject:accountId forKey:@"id"];
        [navController.accounts.dataBase setObject:sortOrderArray forKey:@"sortOrder"];
        
        [sortOrderArray release];
        [accountId release];
    }
    
    // add new feindura account to the database
    [navController.accounts.dataBase setObject: currentAccount forKey:accountId];
    [navController.accounts saveAccounts];
    
    [currentAccount release];
    
    if(self.editAccount != NULL) [delegate editFeinduraAccounts:nil]; // turn off the edit mode, only when saving an edit feindura account
	[delegate DismissAddFeinduraView];
}

- (UITextField*)textFieldsAreEmpty {
    if([url.text isEqualToString:@""])
        return self.url;    
    else if([username.text isEqualToString:@""])
        return self.username;
    else if([password.text isEqualToString:@""])
        return self.password;
    else
        return false;
}

- (BOOL)validateUrl: (NSString *) candidate {
    NSString *urlRegEx = [NSString stringWithString:@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"];
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (void)repairURL {
    
    // add a slash on the end of the url
    [url setText:[url.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]];
    
    NSURL *cmsURL = [NSURL URLWithString:self.url.text];            
    
    // check if there is a scheme (like http://) in this url string
    if([cmsURL scheme] == nil) {
        [url setText:[[NSString stringWithString:@"http://"] stringByAppendingString:self.url.text]];
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
- (void)textFieldShouldReturn:(UITextField*)textField {
    
    // always check url first
    [self repairURL];
    if(![self validateUrl:self.url.text]) {
        [wrongUrl show];
        [url becomeFirstResponder];
        return;
    }
    
    switch (textField.tag) {
        // -> URL TextField
        case 1: {
                // -> JUMP to the next one, if is a valid url
                if([self validateUrl:self.url.text])                
                    [username becomeFirstResponder];
                // -> otherwise throw warning
                else {
                    [wrongUrl show];
                }     
            }
            break;
            
        // -> USERNAME TextField
        case 2:
            // -> JUMP to the next one
            [password becomeFirstResponder];
            break;
            
        // -> PASSWORD TextField
        case 3:
            // -> JUMP to the empty one 
            if([self textFieldsAreEmpty] != false)
                [[self textFieldsAreEmpty] becomeFirstResponder];
            // -> JUMP to url, if not valid
            if([self validateUrl:self.url.text] == false) {
                [wrongUrl show];
                [url becomeFirstResponder];
            // -> SAVE the data
            } else if([self textFieldsAreEmpty] == false)
                [self checkFeinduraAccount];
                
            break;
        default:
            [url becomeFirstResponder];
            break;
    }
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
        [wrongAccount show];
        [username becomeFirstResponder];
    } else {
        [wrongFeinduraUrl show];
        [url becomeFirstResponder];
    }
}

// -> FAILED
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"request failed");
    
    [wrongUrl show];
    [url becomeFirstResponder];

}

@end

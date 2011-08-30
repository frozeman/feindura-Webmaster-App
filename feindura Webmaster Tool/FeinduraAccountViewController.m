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

static NSString *feinduraControllerPath = @"/library/controllers/feinduraWebmasterTool.controller.php";

@implementation FeinduraAccountViewController

// PROPERTIES
@synthesize delegate;
@synthesize scrollView, titleBar; // TopBar
@synthesize urlTitle, accountTitle; // Labels
@synthesize url, username, password; //TextFields
@synthesize wrongUrl, wrongAccount, wrongFeinduraUrl; // Alerts
@synthesize request; // Request
@synthesize feinduraAccountsFromRootView;
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // get the feindura accounts form the parentview
    syncFeinduraAccounts *delagateTemp = ((RootViewController *)self.delegate).feinduraAccounts;
    self.feinduraAccountsFromRootView = delagateTemp;
    [delagateTemp release];
    
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
    self.urlTitle.text = NSLocalizedString(@"ADDFEINDURA_TITLE_URL", nil);
    self.accountTitle.text = NSLocalizedString(@"ADDFEINDURA_TITLE_ACCOUNT", nil);
    self.url.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_URL", nil);
    self.url.tag = 1;
    self.username.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_USERNAME", nil);
    self.username.tag = 2;
    self.password.placeholder = NSLocalizedString(@"ADDFEINDURA_TEXT_PASSWORD", nil);
    self.password.tag = 3;
    
    [self.url becomeFirstResponder];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                               self.password.frame.origin.y + self.password.frame.size.height + 15)];
    
    // -> ADD ACCOUNT DATA if available
    if(editAccount != NULL) {
        self.url.text = [self.editAccount valueForKey:@"url"];
        self.username.text =[self.editAccount valueForKey:@"account"];
        //self.password.text;
    }
    
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

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [request clearDelegatesAndCancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.feinduraAccountsFromRootView = nil;
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

- (void)dealloc {
    
    //[delegate release];
    //[feinduraAccountsFromRootView release];
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

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return false;
}
*/

#pragma mark Methods

- (IBAction)buttonCancelAddFeindura:(id)sender {
	[self.delegate DismissAddFeinduraView];
}
- (IBAction)buttonSaveFeinduraAccount:(id)sender {
    
    // repair url
    [self repairURL];
    
    // validate url
    if(![self validateUrl:self.url.text])                
        [self.wrongUrl show];
    
    else if([self.url.text isEqualToString:@""])
        [self.url becomeFirstResponder];
    else if([self.username.text isEqualToString:@""])
        [self.username becomeFirstResponder];
    else if([self.password.text isEqualToString:@""])
        [self.password becomeFirstResponder];
    else
        [self checkFeinduraAccount];
}

- (void)checkFeinduraAccount {
    
    if(self.feinduraAccountsFromRootView.internetActive) {
        NSString *tempUrl = [[NSString stringWithString:self.url.text] stringByAppendingString:feinduraControllerPath];
        NSURL *cmsUrl = [NSURL URLWithString:tempUrl];
        //NSLog(@"FULLURL %@",tempUrl);
        
        self.request = [ASIFormDataRequest requestWithURL:cmsUrl];
        [self.request setDelegate:self];
        [self.request setPostValue:@"CHECK" forKey:@"status"];
        [self.request setPostValue:self.username.text forKey:@"username"];
        [self.request setPostValue:[self.password.text MD5] forKey:@"password"];
        [self.request startAsynchronous];
    } else
        [self saveFeinduraAccount];
    
}

- (void)saveFeinduraAccount {    

    // -> STORE user data    
    NSError *keychainError;
    
    // ->> STORE password in keychain
    [SFHFKeychainUtils storeUsername:self.username.text andPassword:[self.password.text MD5] forServiceName:self.url.text updateExisting:true error:&keychainError];
    
    /*
     to get it:
    [SFHFKeychainUtils getPasswordForUsername:self.username.text andServiceName: self.url.text error:&keychainError];
     */     
    
    BOOL accountAlreadyExists = false;
    for (NSDictionary *account in self.feinduraAccountsFromRootView.dataBase) {
        NSLog(@"%@",account);
        if([[[self.feinduraAccountsFromRootView.dataBase objectForKey:account] objectForKey:@"url"] isEqualToString:self.url.text])
            accountAlreadyExists = true;
    }
    
    // if account doesnt already exist OR has a new username
    if(!accountAlreadyExists) {
        
        // CREATE A NEW ACCOUNT
        NSDictionary* currentAccount = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               self.url.text,@"url",
                                               @"",@"title",
                                               self.username.text,@"account",nil];
                                               //[self.password.text MD5],@"password", nil];
        
        // generate unique key
        CFUUIDRef identifier = CFUUIDCreate(NULL);
        NSString* identifierString = (NSString*)CFUUIDCreateString(NULL, identifier);
        CFRelease(identifier);
        
        // add new feindura account to the database
        [self.feinduraAccountsFromRootView.dataBase setObject: currentAccount forKey:identifierString];
        //[self.feinduraAccountsFromRootView.dataBase addObject:currentAccount];
        [self.feinduraAccountsFromRootView saveAccounts];
        
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

- (void)repairURL {
    
    // add a slash on the end of the url
    self.url.text = [self.url.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    
    NSURL *cmsURL = [NSURL URLWithString:self.url.text];            
    
    // check if there is a scheme (like http://) in this url string
    if([cmsURL scheme] == nil) {
        self.url.text = [[NSString stringWithString:@"http://"] stringByAppendingString:self.url.text];	
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
        [self.wrongUrl show];
        [self.url becomeFirstResponder];
        return;
    }
    
    switch (textField.tag) {
        // -> URL TextField
        case 1: {
                // -> JUMP to the next one, if is a valid url
                if([self validateUrl:self.url.text])                
                    [self.username becomeFirstResponder];
                // -> otherwise throw warning
                else {
                    [self.wrongUrl show];
                }     
            }
            break;
            
        // -> USERNAME TextField
        case 2:
            // -> JUMP to the next one
            [self.password becomeFirstResponder];
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

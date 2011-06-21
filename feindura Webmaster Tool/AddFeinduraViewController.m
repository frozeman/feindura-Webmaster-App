//
//  AddFeinduraViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "AddFeinduraViewController.h"
#import "NSString+MD5.h"
//#import "SFHFKeychainUtils.h"


@implementation AddFeinduraViewController

// PROPERTIES
@synthesize delegate;
@synthesize scrollView, titleBar; // TopBar
@synthesize urlTitle, accountTitle; // Labels
@synthesize url, username, password; //TextFields
@synthesize wrongUrl; // ALerts

// METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
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
    
    // -> basic set tup
    [self.url becomeFirstResponder];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                               self.password.frame.origin.y + self.password.frame.size.height + 15)];
    //[self.scrollView setContentOffset:CGPointMake(0,200)];
    
    // -> set up the ALerts
    self.wrongUrl = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_TITLE_WRONGURL", nil) message:NSLocalizedString(@"ADDFEINDURA_ALERT_TEXT_WRONGURL", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ADDFEINDURA_ALERT_BUTTON_WRONGURL", nil) otherButtonTitles: nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
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

-(IBAction)cancelAddFeindura:(id)sender {
	[delegate DismissAddFeinduraView];
}

-(BOOL)saveAddFeindura {
    
    // TODO: check internet connection first (if failed display error)
    // TODO: check if username and password is correct (if failed display error)
    
    // -> STORE user data
    
    BOOL settingsExist;
    NSError *error;
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
	
    // if doesnt exist, create a new settings.plist file
	settingsExist = [fileManager fileExistsAtPath:filePath];
	if(!settingsExist) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
		settingsExist = [fileManager copyItemAtPath:path toPath:filePath error:&error];
	}	
	
    if(settingsExist) {
        // create dictionaries for storing settings
        NSMutableDictionary* settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];    
        NSMutableDictionary* currentAccountDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                   @"username",self.username.text,
                                                   @"password",[self.password.text MD5], nil];
	
        // if setting doesnt exist alreay
        if([settingsDict valueForKey:self.url.text] == nil) {
            [settingsDict setObject: currentAccountDict forKey:self.url.text];
            [settingsDict writeToFile:filePath atomically: YES];
        }
    
        [currentAccountDict release];
        [settingsDict release];
    }
    
    /*
    NSURL *serverURL = [NSURL URLWithString:self.url.text];
    NSError *error = nil;
    
    [SFHFKeychainUtils storeUsername:self.username.text andPassword:self.password.text forServiceName:[serverURL absoluteString] updateExisting:YES error:&error];
     */
    
	[delegate DismissAddFeinduraView];
    return true;
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


#pragma mark Delegates

// -> ScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView*)sView {
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
// JUMP to TextFields
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    switch (textField.tag) {
        case 1: {
            
                // add a slash on the end of the url    
                self.url.text = [self.url.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
                //self.url.text = [self.url.text stringByAppendingString:@"/"];
            
                NSURL *cmsURL = [NSURL URLWithString:self.url.text];            
            
                // check if there is a scheme (like http://) in this url string
                if([cmsURL scheme] == nil) {
                    self.url.text = [[NSString stringWithString:@"http://"] stringByAppendingString:self.url.text];
                    //[cmsURL initWithString:self.url.text];	
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
        case 2:
            // -> JUMP to the next one
            [[self.scrollView viewWithTag:3] becomeFirstResponder];
            break;
        case 3:
            // -> JUMP to the empty one 
            if([self textFieldsAreEmpty] != false)
                [[self textFieldsAreEmpty] becomeFirstResponder];
            // -> JUMP to url, if not valid
            if([self validateUrl:self.url.text] == false) {
                [self.wrongUrl show];
                [self.url becomeFirstResponder];
            // -> SAVE the data
            } else
                [self saveAddFeindura];
                
            break;
        default:
            [[self.scrollView viewWithTag:1] becomeFirstResponder];
            break;
    }
    return true;
}

@end

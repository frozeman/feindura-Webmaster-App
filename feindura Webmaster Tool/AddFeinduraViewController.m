//
//  AddFeinduraViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "AddFeinduraViewController.h"
//#import "SFHFKeychainUtils.h"


@implementation AddFeinduraViewController

// PROPERTIES
@synthesize delegate;
@synthesize scrollView, titleBar;
@synthesize urlTitle, accountTitle;
@synthesize url, username, password;

// METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
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
    //NSLog(@"%@",self.scrollView);
    //NSLog(@"%@",self.password);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    
    // TODO: check internet connection first
    // TODO: check if username and password is correct
    
    // -> STORE user data
    
    BOOL success;
    NSError *error;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
	
	success = [fileManager fileExistsAtPath:filePath];
	if (!success) {		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
		success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
	}	
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	
	[plistDict setValue:self.username.text forKey:self.url.text];
	[plistDict writeToFile:filePath atomically: YES];
    
    [plistDict release];
    
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
       (self.textFieldsAreEmpty == false || self.textFieldsAreEmpty == textField))
        [textField setReturnKeyType:UIReturnKeyDone];
    else if(textField.tag == 3)
        [textField setReturnKeyType:UIReturnKeyNext];
}
// JUMP to TextFields
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    switch (textField.tag) {
        case 1:
            // -> JUMP to the next one
            [[self.scrollView viewWithTag:2] becomeFirstResponder];
            break;
        case 2:
            // -> JUMP to the next one
            [[self.scrollView viewWithTag:3] becomeFirstResponder];
            break;
        case 3:
            // -> JUMP to the empty one 
            if([self textFieldsAreEmpty] != false)
                [[self textFieldsAreEmpty] becomeFirstResponder];
            // -> SAVE the data
            else 
                [self saveAddFeindura];
                
            break;
        default:
            [[self.scrollView viewWithTag:1] becomeFirstResponder];
            break;
    }
    return true;
}

@end

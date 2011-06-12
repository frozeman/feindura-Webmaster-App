//
//  AddFeinduraViewController.m
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import "AddFeinduraViewController.h"


@implementation AddFeinduraViewController

@synthesize delegate;
@synthesize titleBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.titleBar = nil;
    self.delegate = nil;
    [titleBar release];
    [delegate release];
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
    
    // add a title which fits in the navbar
    UILabel *title = [[UILabel alloc] init];
	[title setBackgroundColor:[UIColor clearColor]];
	[title setTextColor:[UIColor whiteColor]];
    [title setShadowColor:[UIColor darkGrayColor]];
	[title setText:NSLocalizedString(@"ADDFEINDURA_TITLE", nil)];
	[title sizeToFit];
    [title setAdjustsFontSizeToFitWidth:true];
	[self.titleBar setTitleView:title];
	[title release];
    
    // just adding the title as text
    //self.titleBar.title = NSLocalizedString(@"ADDFEINDURA_TITLE", nil);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.titleBar = nil;
    self.delegate = nil;    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return true;
}

#pragma mark Methods

-(IBAction)cancelAddFeindura:(id)sender {
	[self.delegate DismissAddFeinduraView];
}

-(IBAction)saveAddFeindura:(id)sender {    
	[self.delegate DismissAddFeinduraView];
}

@end

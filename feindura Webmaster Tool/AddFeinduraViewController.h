//
//  AddFeinduraViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Reachability.h"

#import "syncFeinduraAccounts.h"

#pragma mark Protocol

@protocol AddFeinduraViewControllerDelegate <NSObject>

-(void)DismissAddFeinduraView;

@end


#pragma mark Class

@interface AddFeinduraViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate> {
    
    id<AddFeinduraViewControllerDelegate> delegate;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationItem *titleBar;
    
    IBOutlet UILabel *urlTitle;
    IBOutlet UILabel *accountTitle;
    IBOutlet UITextField *url;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    
    UIAlertView *wrongUrl;
    UIAlertView *wrongAccount;
    UIAlertView *wrongFeinduraUrl;
    
    ASIFormDataRequest *request;
    Reachability *internetReachable;
    Reachability *hostReachable;
    BOOL internetActive;
    
    syncFeinduraAccounts *feinduraAccounts;
}

@property(nonatomic,assign) id<AddFeinduraViewControllerDelegate> delegate;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UINavigationItem *titleBar;
@property(nonatomic,retain) UILabel *urlTitle;
@property(nonatomic,retain) UILabel *accountTitle;
@property(nonatomic,retain) UITextField *url;
@property(nonatomic,retain) UITextField *username;
@property(nonatomic,retain) UITextField *password;
@property(nonatomic,retain) UIAlertView *wrongUrl;
@property(nonatomic,retain) UIAlertView *wrongAccount;
@property(nonatomic,retain) UIAlertView *wrongFeinduraUrl;
@property(nonatomic,retain) ASIFormDataRequest *request;
@property(nonatomic,retain) Reachability *internetReachable;
@property(nonatomic,retain) Reachability *hostReachable;
@property(nonatomic,assign) BOOL internetActive;
@property(nonatomic,retain) syncFeinduraAccounts *feinduraAccounts;


- (IBAction)cancelAddFeindura:(id)sender;
- (void)checkFeinduraAccount;
- (void)saveFeinduraAccount;
- (UITextField*)textFieldsAreEmpty;
- (BOOL)validateUrl:(NSString *)candidate;

- (void) checkNetworkStatus:(NSNotification *)notice;


#pragma mark Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end

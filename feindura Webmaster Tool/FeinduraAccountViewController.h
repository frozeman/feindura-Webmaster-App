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

@interface FeinduraAccountViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate> {
    
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
    syncFeinduraAccounts *feinduraAccountsFromRootView;
    NSDictionary *editAccount;
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
@property(nonatomic,retain) syncFeinduraAccounts *feinduraAccountsFromRootView;
@property(nonatomic,retain) NSDictionary *editAccount;

- (IBAction)buttonCancelAddFeindura:(id)sender;
- (IBAction)buttonSaveFeinduraAccount:(id)sender;
- (void)checkFeinduraAccount;
- (void)saveFeinduraAccount;
- (UITextField*)textFieldsAreEmpty;
- (BOOL)validateUrl:(NSString *)candidate;
- (void)repairURL;

#pragma mark Delegates

- (void)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

- (void)requestStarted:(ASIHTTPRequest *)request;
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end

//
//  AddFeinduraViewController.h
//  feindura Webmaster Tool
//
//  Created by Fabian on 12.06.11.
//  Copyright 2011 [frozeman.de] All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark Protocol

@protocol AddFeinduraViewControllerDelegate <NSObject>

-(void)DismissAddFeinduraView;

@end


#pragma mark Class

@interface AddFeinduraViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate> {
    
    id<AddFeinduraViewControllerDelegate> delegate;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationItem *titleBar;
    
    IBOutlet UILabel *urlTitle;
    IBOutlet UILabel *accountTitle;
    IBOutlet UITextField *url;
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}

@property(nonatomic,assign) id<AddFeinduraViewControllerDelegate> delegate;
@property(nonatomic,retain) UIScrollView *scrollView;
@property(nonatomic,retain) UINavigationItem *titleBar;
@property(nonatomic,retain) UILabel *urlTitle;
@property(nonatomic,retain) UILabel *accountTitle;
@property(nonatomic,retain) UITextField *url;
@property(nonatomic,retain) UITextField *username;
@property(nonatomic,retain) UITextField *password;


-(IBAction)saveAddFeindura:(id)sender;
-(IBAction)cancelAddFeindura:(id)sender;

#pragma mark Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end

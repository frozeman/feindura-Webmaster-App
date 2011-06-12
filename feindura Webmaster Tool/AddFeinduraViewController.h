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

@interface AddFeinduraViewController : UIViewController {
    
    id<AddFeinduraViewControllerDelegate> delegate;    
    IBOutlet UINavigationItem *titleBar;
}

@property(nonatomic,assign) id<AddFeinduraViewControllerDelegate> delegate;
@property(nonatomic,retain) UINavigationItem *titleBar;

-(IBAction)saveAddFeindura:(id)sender;
-(IBAction)cancelAddFeindura:(id)sender;

@end

//
//  tableViewHelperClass.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 13.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "TableHelperClass.h"
#import "RootViewController.h"

@implementation TableHelperClass

#pragma mark Singltons


+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation {
    [self changeCellOrientation:cell  toOrientation:orientation inTable:nil];
}

+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation inTable:(id)tableViewController {
    //NSLog(@"CHANGE ORIENTATION");
    
    int leftPadding = 11;
    int statsWidthLandscape = 130;
    int statsWidthPortrait = 85;    
    
    if([tableViewController isKindOfClass:[RootViewController class]]) {
        leftPadding = 50;
        statsWidthLandscape = 105;
        statsWidthPortrait = 60;
    }
    
    UILabel *label;
    
    // LANDSCAPE
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        // TODO: add more stats in this orientation?
        
        // subtext
        [[cell viewWithTag:2] setFrame:CGRectMake( leftPadding, 22, 230, 20 )];
        label = (UILabel *)[cell viewWithTag:2];
        if(label.text != nil)
            [label setHidden:false];
        
        // text
        if([cell viewWithTag:2].hidden == true)
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 12, 285, 20 )];
        else
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 5, 285, 20 )];
        
        // stats subtext
        [[cell viewWithTag:4] setFrame:CGRectMake( 285, 22, statsWidthLandscape + 50, 20 )];
        label = (UILabel *)[cell viewWithTag:4];
        if(label.text != nil)
            [label setHidden:false];
        
        // stats
        if([cell viewWithTag:4].hidden == true)
            [[cell viewWithTag:3] setFrame:CGRectMake( 340, 12, statsWidthLandscape, 20 )];
        else
            [[cell viewWithTag:3] setFrame:CGRectMake( 340, 5, statsWidthLandscape, 20 )];
        
    // PORTRAIT
    } else {
        
        // subtext
        [[cell viewWithTag:2] setFrame:CGRectMake( leftPadding, 22, 165, 20 )];
        label = (UILabel *)[cell viewWithTag:2];
        if(label.text != nil)
            [label setHidden:false];
        
        // text
        if([cell viewWithTag:2].hidden == true)
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 12, 165, 20 )];
        else
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 5, 165, 20 )];
        
        // stats subtext
        [[cell viewWithTag:4] setFrame:CGRectMake( 220, 22, statsWidthPortrait, 20 )];
        [[cell viewWithTag:4] setHidden:true];
        
        // stats
        if([cell viewWithTag:4].hidden == true)
            [[cell viewWithTag:3] setFrame:CGRectMake( 220, 11, statsWidthPortrait, 20 )];
        else
            [[cell viewWithTag:3] setFrame:CGRectMake( 220, 5, statsWidthPortrait, 20 )];
    }
}

#pragma mark Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



@end

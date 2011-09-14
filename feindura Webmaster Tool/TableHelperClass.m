//
//  tableViewHelperClass.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 13.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "TableHelperClass.h"

@implementation TableHelperClass

#pragma mark Singltons


+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation {
    [self changeCellOrientation:cell  toOrientation:orientation inTable:@"Default"];
}

+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation inTable:(NSString *)name {
    //NSLog(@"CHANGE ORIENTATION");
    
    int leftPadding = 11;
    int statsWidthLandscape = 125;
    int statsWidthPortrait = 85;    
    
    if([name isEqualToString:@"RootViewController"]) {
        leftPadding = 45;
        statsWidthLandscape = 105;
        statsWidthPortrait = 65;
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    // LANDSCAPE
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        // TODO: add more stats in this orientation?
        
        // subtext
        [[cell viewWithTag:2] setFrame:CGRectMake( leftPadding, 22, 235, 20 )];
        
        // text
        if([cell viewWithTag:2].hidden == true)
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 12, 285, 20 )];
        else
            [[cell viewWithTag:1] setFrame:CGRectMake( leftPadding, 5, 285, 20 )];
        
        // stats subtext
        [[cell viewWithTag:4] setFrame:CGRectMake( 290, 22, statsWidthLandscape + 50, 20 )];
        [[cell viewWithTag:4] setHidden:false];
        
        // stats
        if([cell viewWithTag:4].hidden == true)
            [[cell viewWithTag:3] setFrame:CGRectMake( 340, 12, statsWidthLandscape, 20 )];
        else
            [[cell viewWithTag:3] setFrame:CGRectMake( 340, 5, statsWidthLandscape, 20 )];
        
    // PORTRAIT
    } else {
        
        // subtext
        [[cell viewWithTag:2] setFrame:CGRectMake( leftPadding, 22, 165, 20 )];
        
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
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
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

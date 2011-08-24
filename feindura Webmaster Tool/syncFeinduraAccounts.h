//
//  SyncFeinduras.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface syncFeinduraAccounts : NSObject {
    NSString *settingsFilePath;
    NSMutableDictionary *dataBase;
}

#pragma mark Properties

@property(nonatomic,retain) NSString *settingsFilePath;
@property(nonatomic,retain) NSMutableDictionary *dataBase;

#pragma mark Methods

-(void)loadAccounts;
-(void)saveAccounts;
-(BOOL)updateAccounts;

@end

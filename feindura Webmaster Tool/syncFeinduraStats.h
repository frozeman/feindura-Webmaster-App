//
//  SyncFeinduras.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface syncFeinduraStats : NSObject {
    NSString *settingsFilePath;
    NSMutableDictionary *feindurasDataBase;
}

#pragma mark Properties

@property(nonatomic,retain) NSString *settingsFilePath;
@property(nonatomic,retain) NSMutableDictionary *feindurasDataBase;

#pragma mark Methods

-(void)loadFeindurasDataBase;
-(BOOL)saveFeindurasDataBase;
-(BOOL)updateFeinduraStats;

@end

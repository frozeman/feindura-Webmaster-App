//
//  SyncFeinduras.m
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 24.08.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import "syncFeinduraStats.h"

@implementation syncFeinduraStats

@synthesize settingsFilePath;
@synthesize feinduraDataBases;

- (id)init
{
    self = [super init];
    if (self) {
        
        BOOL settingsFileExist;
        NSError *fileError;
        
        // ->> GET settings.plist PATH
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.settingsFilePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
        
        // -> if doesnt exist, create a new settings.plist file
        settingsFileExist = [fileManager fileExistsAtPath:self.settingsFilePath];
        if(!settingsFileExist) {
        	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        	settingsFileExist = [fileManager copyItemAtPath:path toPath:self.settingsFilePath error:&fileError];
        }
        
        if(settingsFileExist) {
            [self loadFeinduraDataBases];
        } else
            return false;
    }
    
    return self;
}

- (void)dealloc {
    [settingsFilePath release];
    [feinduraDataBases release];
    [super dealloc];
}

#pragma mark Methods
- (void)loadFeinduraDataBases {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingsFilePath];
    self.feinduraDataBases = tmp;
    [tmp release];
}

- (void)saveFeinduraDataBases {
    [self.feinduraDataBases writeToFile:self.settingsFilePath atomically: YES];

}

- (BOOL)updateFeinduraStats {
    return true;
}

@end

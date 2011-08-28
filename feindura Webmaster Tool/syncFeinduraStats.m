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
@synthesize feindurasDataBase;

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
    [feindurasDataBase release];
    [super dealloc];
}

#pragma mark Methods
- (void)loadFeindurasDataBase {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:self.settingsFilePath];
    self.feindurasDataBase = tmp;
    [tmp release];
}

- (BOOL)saveFeindurasDataBase {
    
//    // -> STORE user data    
//    
//    
//    // ->> SAVE settings.plist
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
//	
//    // if doesnt exist, create a new settings.plist file
//	settingsFileExist = [fileManager fileExistsAtPath:filePath];
//	if(!settingsFileExist) {
//		NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
//		settingsFileExist = [fileManager copyItemAtPath:path toPath:filePath error:&fileError];
//	}	
//	
//    if(settingsFileExist) {
//        // create dictionaries for storing settings
//        NSMutableDictionary* settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];    
//        NSMutableDictionary* currentAccountDict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                                   @"username",self.username.text,nil];
//        //@"password",[self.password.text MD5], nil];
//        
//        // if setting doesnt exist alreay
//        if([settingsDict valueForKey:self.url.text] == nil) {
//            [settingsDict setObject: currentAccountDict forKey:self.url.text];
//            [settingsDict writeToFile:filePath atomically: YES];
//        }
//        
//        [currentAccountDict release];
//        [settingsDict release];
//    }
    return true;
}

- (BOOL)updateFeinduraStats {
    return true;
}

@end

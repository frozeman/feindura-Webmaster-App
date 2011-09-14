//
//  tableViewHelperClass.h
//  feindura Webmaster Tool
//
//  Created by Fabian Vogelsteller on 13.09.11.
//  Copyright 2011 [frozeman.de]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableHelperClass : NSObject

+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation;
+(void)changeCellOrientation:(UITableViewCell *)cell toOrientation:(UIInterfaceOrientation)orientation inTable:(NSString *)name;

@end

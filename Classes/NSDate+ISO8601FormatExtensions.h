//
//  NSDate+ISO8601FormatExtensions.h
//  bant
//
//  Created by Mat Trudel on 09-12-01.
//  Copyright 2009 University Health Network. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (ISO8601FormatExtensions)
- (NSString *)formattedAsISO8601;

+ (NSDate *)dateFromISO8601String: (NSString *)string;
@end

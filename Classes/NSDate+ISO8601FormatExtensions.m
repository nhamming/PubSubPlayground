//
//  NSDate+ISO8601FormatExtensions.m
//  bant
//
//  Created by Mat Trudel on 09-12-01.
//  Copyright 2009 University Health Network. All rights reserved.
//

#import "NSDate+ISO8601FormatExtensions.h"

#define kISO8601Format @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define kISO8601DateOnlyFormat @"yyyy-MM-dd"

@implementation NSDate (ISO8601FormatExtensions)
- (NSString *)formattedAsISO8601 {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = kISO8601Format;
	formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
	return [formatter stringFromDate: self];
}

+ (NSDate *)dateFromISO8601String: (NSString *)string {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = kISO8601Format;
	formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
	NSDate *result = nil;
	if (!(result = [formatter dateFromString: string])) {
		formatter.dateFormat = kISO8601DateOnlyFormat;
		result = [formatter dateFromString: string];
	}
	return result;
}
@end

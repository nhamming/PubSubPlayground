//
//  NSMutableString+ReplacementExtensions.m
//  bant
//
//  Created by Mat Trudel on 09-12-01.
//  Copyright 2009 University Health Network. All rights reserved.
//

#import "NSMutableString+ReplacementExtensions.h"

@implementation NSMutableString (ReplacementExtensions)

- (NSInteger)replace: (NSString *)needle with: (NSString *)replacement {
	return [self replaceOccurrencesOfString: needle 
								 withString: replacement
									options: 0 
									  range: NSMakeRange(0, [self length])];
}


- (void)replace: (NSString *)needle with: (NSString *)replacement expectedCount: (NSInteger)expectedCount {
	NSAssert2([self replace: needle with: replacement] == expectedCount, @"Didn't do exactly %d substitution of %@", expectedCount, needle);
}

@end

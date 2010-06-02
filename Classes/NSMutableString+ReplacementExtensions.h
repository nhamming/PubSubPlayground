//
//  NSMutableString+ReplacementExtensions.h
//  bant
//
//  Created by Mat Trudel on 09-12-01.
//  Copyright 2009 University Health Network. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableString (ReplacementExtensions)

- (NSInteger)replace: (NSString *)needle with: (NSString *)replacement;

- (void)replace: (NSString *)needle with: (NSString *)replacement expectedCount: (NSInteger)expectedCount;

@end

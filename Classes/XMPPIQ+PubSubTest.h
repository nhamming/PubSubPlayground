//
//  XMPPIQ+PubSubTest
//  iPhoneXMPP
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPIQ.h"

@interface XMPPIQ (XMPPIQ_PubSubTest)

+ (XMPPIQ*) pubSubTest;
+ (XMPPIQ*) createPubSubIQWithValue:(NSString*)value;
+ (XMPPIQ*) createPubSubIQWithCCR;

@end

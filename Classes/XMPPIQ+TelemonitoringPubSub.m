//
//  XMPPIQ+TelemonitoringPubSub.m
//  iPhoneXMPP
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMPPIQ+TelemonitoringPubSub.h"
#import "XMPPJID.h"
#import "NSXMLElementAdditions.h"
#import "NSMutableString+ReplacementExtensions.h"
#import "NSDate+ISO8601FormatExtensions.h"

@implementation XMPPIQ (XMPPIQ_TelemonitoringPubSub)

+ (XMPPIQ*)pubSubTest {
//	return [self createPubSubIQWithValue:[NSString stringWithFormat:@"(iPhone) sent: %@",[NSDate date]]];
	return [self createPubSubIQWithCCR];
}

+ (XMPPIQ*) createPubSubIQWithValue:(NSString*)value {
	DDXMLElement *childElement = [NSXMLElement elementWithName:@"pubsub" xmlns:@"pubsubserver"];
	DDXMLElement *publishElement = [[[DDXMLElement alloc] initWithName:@"publish"] autorelease];
	[publishElement addAttributeWithName:@"node" stringValue:@"node"];
	[childElement addChild:publishElement];
	[(DDXMLElement*)[childElement nextNode] addChild:[DDXMLNode elementWithName:@"item"]];
	[(DDXMLElement*)[[childElement nextNode] nextNode] addChild:[DDXMLNode elementWithName:@"value" stringValue:value]];
	
	XMPPIQ *xmlIQ = [XMPPIQ iqWithType:@"set" to:[XMPPJID jidWithString:@"pubsubJID"]];
	[xmlIQ addChild:childElement];
	NSAssert(xmlIQ,@"xmlIQ not created");
	
	return xmlIQ;
}

+ (XMPPIQ*) createPubSubIQWithCCR {
	static NSString *kUsernameReplacementTarget = @"<!-- USERNAME USERNAME USERNAME USERNAME USERNAME -->";
	static NSString *kValueReplacementTarget = @"<!-- VALUE VALUE VALUE VALUE VALUE -->";
	static NSString *kUnitReplacementTarget = @"<!-- UNIT UNIT UNIT UNIT UNIT -->";
	static NSString *kDateReplacementTarget = @"<!-- TAKENTIME TAKENTIME TAKENTIME TAKENTIME TAKENTIME -->";
	
	NSError *error = nil;
	NSMutableString *resultString = [NSMutableString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"GlucoseReadingCCRTemplate" ofType:@"xml"] encoding:NSUTF8StringEncoding error: &error];
	NSAssert1(!error, @"Error encountered: %@", error);
	
	[resultString replace: kUsernameReplacementTarget with: @"PubSubTest"];
	[resultString replace: kValueReplacementTarget with: @"9.0"];
	[resultString replace: kUnitReplacementTarget with: @"mmol/l"];
	[resultString replace: kDateReplacementTarget with: [[NSDate date] formattedAsISO8601]];
	DDXMLElement *resultStringXML = [[[DDXMLElement alloc] initWithXMLString:resultString error:&error] autorelease];
	NSAssert(!error,@"resultStringXML not created");
	
	DDXMLElement *childElement = [NSXMLElement elementWithName:@"pubsub" xmlns:@"pubsubserver"];
	DDXMLElement *publishElement = [[[DDXMLElement alloc] initWithName:@"publish"] autorelease];
	[publishElement addAttributeWithName:@"node" stringValue:@"node"];
	[childElement addChild:publishElement];
	[(DDXMLElement*)[childElement nextNode] addChild:[DDXMLNode elementWithName:@"item"]];
	[(DDXMLElement*)[[childElement nextNode] nextNode] addChild:resultStringXML];
	
	XMPPIQ *xmlIQ = [XMPPIQ iqWithType:@"set" to:[XMPPJID jidWithString:@"pubsubJID"]];
	[xmlIQ addChild:childElement];
	NSAssert(xmlIQ,@"xmlIQ not created");
	
	return xmlIQ;
}

@end


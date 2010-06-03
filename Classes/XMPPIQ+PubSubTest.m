//
//  XMPPIQ+PubSubTest.m
//  iPhoneXMPP
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "XMPPIQ+PubSubTest.h"
#import "XMPPJID.h"
#import "NSXMLElementAdditions.h"
#import "NSMutableString+ReplacementExtensions.h"
#import "NSDate+ISO8601FormatExtensions.h"

static NSString	*kDeviceGUIDReplacementTarget = @"<!-- DEVICEGUID DEVICEGUID DEVICEGUID DEVICEGUID DEVICEGUID -->";
static NSString *kUsernameReplacementTarget = @"<!-- USERNAME USERNAME USERNAME USERNAME USERNAME -->";
static NSString *kValueReplacementTarget = @"<!-- VALUE VALUE VALUE VALUE VALUE -->";
static NSString *kUnitReplacementTarget = @"<!-- UNIT UNIT UNIT UNIT UNIT -->";
static NSString *kDateReplacementTarget = @"<!-- TAKENTIME TAKENTIME TAKENTIME TAKENTIME TAKENTIME -->";

@implementation XMPPIQ (XMPPIQ_PubSubTest)

+ (XMPPIQ*) pubSubTest {
//	return [self createPubSubIQWithValue:[NSString stringWithFormat:@"(iPhone) sent: %@",[NSDate date]]];
	return [self createPubSubIQWithCCR];
}

+ (XMPPIQ*) createPubSubIQWithItemElemnt: (DDXMLElement*)itemElement {
	DDXMLElement *childElement = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
	DDXMLElement *publishElement = [[[DDXMLElement alloc] initWithName:@"publish"] autorelease];
	[publishElement addAttributeWithName:@"node" stringValue:@"/home/jabber.telemonitoring.ca/device/readings"];
	[childElement addChild:publishElement];
	[(DDXMLElement*)[childElement nextNode] addChild:itemElement];
	
	XMPPIQ *xmlIQ = [XMPPIQ iqWithType:@"set" to:[XMPPJID jidWithString:@"pubsub.jabber.telemonitoring.ca"]];
	[xmlIQ addChild:childElement];
	NSAssert(xmlIQ,@"xmlIQ not created");
	
	return xmlIQ;	
}

+ (XMPPIQ*) createPubSubIQWithValue:(NSString*)value {
	DDXMLElement *itemElement = [DDXMLNode elementWithName:@"item"];
	[itemElement addChild:[DDXMLNode elementWithName:@"value" stringValue:value]];
	
	return [self createPubSubIQWithItemElemnt:itemElement];
}

+ (XMPPIQ*) createPubSubIQWithCCR {
	NSError *error = nil;
	NSMutableString *resultString = [NSMutableString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"GlucoseReadingCCRTemplate" ofType:@"xml"] encoding:NSUTF8StringEncoding error: &error];
	NSAssert1(!error, @"Error encountered: %@", error);
	
	[resultString replace: kDeviceGUIDReplacementTarget with:[[UIDevice currentDevice] uniqueIdentifier]];
	[resultString replace: kUsernameReplacementTarget with: [[UIDevice currentDevice] name]];
	[resultString replace: kValueReplacementTarget with: @"9.0"];
	[resultString replace: kUnitReplacementTarget with: @"mmol/l"];
	[resultString replace: kDateReplacementTarget with: [[NSDate date] formattedAsISO8601]];
	DDXMLElement *ccrXML = [[[DDXMLElement alloc] initWithXMLString:resultString error:&error] autorelease];
	NSAssert(!error,@"resultStringXML not created");
	
	DDXMLElement *itemElement = [DDXMLNode elementWithName:@"item"];
	[itemElement addChild:ccrXML];
	
	return [self createPubSubIQWithItemElemnt:itemElement];
}

@end


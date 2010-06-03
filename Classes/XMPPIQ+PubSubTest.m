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

static NSString	*kDeviceIDReplacementTarget = @"<!-- DEVICEID DEVICEID DEVICEID DEVICEID DEVICEID -->";
static NSString *kDeviceNameReplacementTarget = @"<!-- DEVICENAME DEVICENAME DEVICENAME DEVICENAME DEVICENAME -->";	
static NSString *kActorIDReplacementTarget = @"<!-- ACTORID ACTORID ACTORID ACTORID ACTORID -->";
static NSString *kActorRolerReplacementTarget = @"<!-- ACTORROLE ACTORROLE ACTORROLE ACTORROLE ACTORROLE -->";
static NSString *kVitalSignTypeReplacementTarget = @"<!-- VITALSIGNTYPE VITALSIGNTYPE VITALSIGNTYPE VITALSIGNTYPE VITALSIGNTYPE -->";
static NSString *kLIONCCodeReplacementTarget = @"<!-- LOINCCODE LOINCCODE LOINCCODE LOINCCODE LOINCCODE -->";
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
	
	[resultString replace: kDeviceIDReplacementTarget with:[[UIDevice currentDevice] uniqueIdentifier]];
	[resultString replace: kDeviceNameReplacementTarget with:[[UIDevice currentDevice] name]];
	[resultString replace: kActorIDReplacementTarget with: @"Nurse Betty"];
	[resultString replace: kActorRolerReplacementTarget with: @"Ward Nurse"];
	[resultString replace: kVitalSignTypeReplacementTarget with: @"Heart Beat"];
	[resultString replace: kLIONCCodeReplacementTarget with: @"8867-4"];
	[resultString replace: kValueReplacementTarget with: @"60"];
	[resultString replace: kUnitReplacementTarget with: @"bpm"];
	[resultString replace: kDateReplacementTarget with: [[NSDate date] formattedAsISO8601]];
	DDXMLElement *ccrXML = [[[DDXMLElement alloc] initWithXMLString:resultString error:&error] autorelease];
	NSAssert1(!error,@"ccrXML not created: %@",error);
	
	DDXMLElement *itemElement = [DDXMLNode elementWithName:@"item"];
	[itemElement addChild:ccrXML];
	
	return [self createPubSubIQWithItemElemnt:itemElement];
}

@end


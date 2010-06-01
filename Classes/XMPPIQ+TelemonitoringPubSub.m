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

@implementation XMPPIQ (XMPPIQ_TelemonitoringPubSub)

+ (XMPPIQ*)pubSubTest {
	return [self createPuBSubIQWithValue:[NSString stringWithFormat:@"(iPhone) sent: %@",[NSDate date]]];
}

+ (XMPPIQ*) createPuBSubIQWithValue:(NSString*)value {
	DDXMLElement *childElement = [NSXMLElement elementWithName:@"pubsub" xmlns:@"http://jabber.org/protocol/pubsub"];
	DDXMLElement *publishElement = [[[DDXMLElement alloc] initWithName:@"publish"] autorelease];
	[publishElement addAttributeWithName:@"node" stringValue:@"/home/jabber.telemonitoring.ca/device/readings"];
	[childElement addChild:publishElement];
	[(DDXMLElement*)[childElement nextNode] addChild:[DDXMLNode elementWithName:@"item"]];
	[(DDXMLElement*)[[childElement nextNode] nextNode] addChild:[DDXMLNode elementWithName:@"value" stringValue:value]];
	
	XMPPIQ *xmlIQ = [XMPPIQ iqWithType:@"set" to:[XMPPJID jidWithString:@"pubsub.jabber.telemonitoring.ca"]];
	[xmlIQ addChild:childElement];
	NSAssert(xmlIQ,@"xmlIQ not created");
	
	return xmlIQ;
}

@end


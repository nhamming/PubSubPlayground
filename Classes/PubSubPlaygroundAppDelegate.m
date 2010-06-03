//
//  PubSubPlaygroundAppDelegate.m
//  PubSubPlayground
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PubSubPlaygroundAppDelegate.h"
#import "RootViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"

@implementation PubSubPlaygroundAppDelegate
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize window;

#pragma mark -
- (void)dealloc {
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	[xmppStream disconnect];
	[xmppStream release];
	[xmppRoster release];
	[password release];
    [navigationController release];
	[window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	//setup the stream
	xmppStream = [[XMPPStream alloc] init];
	[xmppStream addDelegate:self];

	//setup the roster
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
	[xmppRoster addDelegate:self];
	[xmppRoster setAutoRoster:YES];
	
	[xmppStream setHostName:@"jabber.telemonitoring.ca"];
	[xmppStream setHostPort:5222];
	[xmppStream setMyJID:[XMPPJID jidWithString:@"device@jabber.telemonitoring.ca"]];
	password = @"spamhead";
	
	NSError *error = nil;
	if (![xmppStream connect:&error]) {
		NSLog(@"Error connecting publisher stream: %@", error);
	}

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	return YES;
}

#pragma mark -
#pragma mark Custom Methods
- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

#pragma mark -
#pragma mark XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (allowSelfSignedCertificates) {
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch) {
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else {
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"]) {
			if ([virtualDomain isEqualToString:@"gmail.com"]) {
				expectedCertName = virtualDomain;
			}
			else {
				expectedCertName = serverDomain;
			}
		}
		else {
			expectedCertName = serverDomain;
		}
		
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	isOpen = YES;
	
	NSError *error = nil;
	if (![[self xmppStream] authenticateWithPassword:password error:&error]) {
		NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	NSLog(@"---------- xmppStream:didReceiveMessage: ----------");
	NSLog(@"message: %@",message);
	while (message) {
		DDXMLElement *valueElement = [message elementForName:@"value"];
		if (valueElement) {
			NSString *valueElementContents = [valueElement stringValue];
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Received Message" message:[NSString stringWithFormat:@"%@",valueElementContents] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[alert show];		
			break;
		}
		message	= (XMPPMessage*)[message nextNode]; 
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
	NSLog(@"---------- xmppStrea:didReceiveError: ----------");
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender {
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	if (!isOpen) {
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppStream:(XMPPStream *)sender willSendIQ:(XMPPIQ *)iq {
	NSLog(@"---------- xmppStreamDidSendIQ: ----------");
}

@end

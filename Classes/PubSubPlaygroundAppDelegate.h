//
//  PubSubPlaygroundAppDelegate.h
//  PubSubPlayground
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;

@interface PubSubPlaygroundAppDelegate : NSObject <UIApplicationDelegate> {
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;	
	
	XMPPStream *xmppStream;
	NSString *password;
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isOpen;
	UIWindow *window;
	UINavigationController *navigationController;
}
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end


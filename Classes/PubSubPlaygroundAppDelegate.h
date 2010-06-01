//
//  PubSubPlaygroundAppDelegate.h
//  PubSubPlayground
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPStream;

@interface PubSubPlaygroundAppDelegate : NSObject <UIApplicationDelegate> {
	XMPPStream *xmppStream;
	NSString *password;
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isOpen;
	UIWindow *window;
}

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction) sendButtonPressed;

@end


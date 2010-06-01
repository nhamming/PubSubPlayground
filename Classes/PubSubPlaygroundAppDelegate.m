//
//  PubSubPlaygroundAppDelegate.m
//  PubSubPlayground
//
//  Created by Nathaniel Hamming on 10-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PubSubPlaygroundAppDelegate.h"

@implementation PubSubPlaygroundAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end

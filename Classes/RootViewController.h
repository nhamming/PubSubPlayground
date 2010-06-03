#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class XMPPStream;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	IBOutlet UILabel *tableHeaderLabel;
	NSFetchedResultsController *fetchedResultsController;
	XMPPStream *xmppStream;
}

- (IBAction) sendButtonPressed;
	
@end

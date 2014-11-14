#import <Cocoa/Cocoa.h>

@interface ZYAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *currencySelectorMenuItem;

@end

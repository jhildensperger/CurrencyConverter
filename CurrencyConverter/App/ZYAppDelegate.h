#import <Cocoa/Cocoa.h>

@interface ZYAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate>

@property (nonatomic) IBOutlet NSMenu *menu;
@property (nonatomic) IBOutlet NSMenuItem *currencySelectorMenuItem;
@property (nonatomic) IBOutlet NSWindow *inputWindow;
@property (nonatomic) IBOutlet NSTextField *textField;

@end

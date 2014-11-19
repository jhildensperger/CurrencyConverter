#import <Cocoa/Cocoa.h>

@interface ZYAppDelegate : NSObject <NSApplicationDelegate,NSTokenFieldDelegate, NSMenuDelegate>

@property (nonatomic) IBOutlet NSMenu *menu;
@property (nonatomic) IBOutlet NSMenuItem *currencySelectorMenuItem;
@property (nonatomic) IBOutlet NSWindow *inputWindow;
@property (nonatomic) IBOutlet NSTokenField *textField;
@property (nonatomic) IBOutlet NSTextField *labelTextField;
@property (nonatomic) IBOutlet NSLayoutConstraint *labelFieldLeadingContraint;

@end

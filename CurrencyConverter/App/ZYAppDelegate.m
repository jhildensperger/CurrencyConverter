#import "ZYAppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import <ParseOSX/Parse.h>
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>
#import "ReactiveCocoa.h"
#import "Currency.h"

@interface ZYAppDelegate ()

@property (nonatomic) NSStatusItem *statusItem;
@property (nonatomic) NSMenuItem *selectedCurrencyMenuItem;
@property (nonatomic) NSArray *currencyArray;
@property (nonatomic) Currency *selectedCurrency;
@property (nonatomic) NSDictionary *textFieldAttributes;

@end

static NSString * const kParseApplicationId = @"OedvE5YXkz9gRNfTSYx2YReMUpUyv9WuHDSmJVty";
static NSString * const kParseOSXClientKey = @"G2mO2ZjdNltQQo0ocR5wN0Um2qJBBK3XplKBeeP1";
static NSString * const kParseRESTAPIKey = @"pjBXsKkEzUI2ZVcLAG857BIrbR637CPv9fWG5oSV";
static NSString * const kFetchCurrenciesURLString = @"https://api.parse.com/1/functions/calculateExchangeRate";

@implementation ZYAppDelegate

+ (AFHTTPRequestOperationManager *)requestManager {
    static AFHTTPRequestOperationManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [AFHTTPRequestOperationManager manager];
        
        requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [requestManager.requestSerializer setValue:@"OedvE5YXkz9gRNfTSYx2YReMUpUyv9WuHDSmJVty" forHTTPHeaderField:@"X-Parse-Application-Id"];
        [requestManager.requestSerializer setValue:@"pjBXsKkEzUI2ZVcLAG857BIrbR637CPv9fWG5oSV" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    });
    return requestManager;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [Currency registerSubclass];
    [Parse setApplicationId:kParseApplicationId clientKey:kParseOSXClientKey];
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [PFAnalytics trackAppOpenedWithLaunchOptions:nil];
    
    PFQuery *query = [Currency query];
    query.limit = 1000;
    [query orderByAscending:@"display_name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
        self.currencyArray = [objects sortedArrayUsingDescriptors:@[sortDescriptor]];
        [self setupStatusItem];
        [self setupForCurrencies];
        [[DDHotKeyCenter sharedHotKeyCenter] registerHotKeyWithKeyCode:kVK_ANSI_C modifierFlags:NSControlKeyMask target:self action:@selector(didReceiveHotKey) object:nil];
    }];
    
    self.labelTextField.alphaValue = 0;
    
    self.textField.focusRingType = NSFocusRingTypeNone;
    self.textField.placeholderAttributedString = [[NSAttributedString alloc] initWithString:@"Convert Currency" attributes:self.textFieldAttributes];
    self.textField.font = [NSFont fontWithName:@"Helvetica Neue Light" size:28];
    self.textField.textColor = [NSColor darkGrayColor];
    
    [self.textField setTokenStyle:NSTokenStylePlainSquared];
    [self.textField setCompletionDelay:0.2];	// speed up auto completion a bit for type matching
}

- (void)setupForCurrencies {
    NSRegularExpression *amountRegex = [[NSRegularExpression alloc] initWithPattern:@"\\.?([0-9]\\,?)+(\\.[0-9]+)?" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *patternString = [NSString stringWithFormat:@"(%@)", [[self.currencyArray valueForKeyPath:@"@distinctUnionOfObjects.isoCode"] componentsJoinedByString:@"|"]];
    
    NSRegularExpression *currencyIndicatorRegex = [[NSRegularExpression alloc] initWithPattern:patternString options:NSRegularExpressionCaseInsensitive error:nil];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:NSControlTextDidChangeNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        if (self.labelTextField.alphaValue) {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                [context setDuration:0.25];
                self.labelTextField.alphaValue = 0;
            } completionHandler:nil];
        }
        
        NSString *value = [notification.object stringValue].uppercaseString;
        
        NSSize size = [value sizeWithAttributes:self.textFieldAttributes];
        if (size.width < 542) {
            self.labelFieldLeadingContraint.constant = 10 + size.width;
        }
        
        NSTextCheckingResult *toIsoCodeResult = [currencyIndicatorRegex firstMatchInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, value.length)];
        if (toIsoCodeResult) {
            NSString *toIsoCode = [value substringWithRange:toIsoCodeResult.range];
            NSTextCheckingResult *amountResult = [amountRegex firstMatchInString:value options:NSMatchingAnchored range:NSMakeRange(0, value.length)];
            if (amountResult) {
                NSString *amountString = [value substringWithRange:amountResult.range];
                NSNumber *amount = @([[amountString stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]);
                [self getExchangeRateFromCurrency:toIsoCode toCurrency:self.selectedCurrency.isoCode amount:amount];
            }
        }
    }];
}

- (NSDictionary *)textFieldAttributes {
    if (!_textFieldAttributes) {
        _textFieldAttributes = @{NSForegroundColorAttributeName : [NSColor lightGrayColor], NSFontAttributeName : [NSFont fontWithName:@"Helvetica Neue Light" size:28]};
    }
    return _textFieldAttributes;
}

- (void)getExchangeRateFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency amount:(NSNumber *)amount {
    NSDictionary *params = @{ @"from_iso_code" : fromCurrency.uppercaseString, @"to_iso_code" : toCurrency.uppercaseString, @"amount" : amount};
    [[self.class requestManager] POST:kFetchCurrenciesURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *toIsoCode = responseObject[@"result"][@"to_iso_code"];
        NSNumber *convertedAmount = @([responseObject[@"result"][@"converted_amount"] doubleValue]);
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.currencyCode = toIsoCode;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 2;
        self.labelTextField.stringValue = [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:convertedAmount], toIsoCode];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration:0.25];
            self.labelTextField.alphaValue = 1;
        } completionHandler:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)setupStatusItem {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.highlightMode = YES;
    
    [self setupMenu];
}

- (void)setupMenu {
    NSMenu *subMenu = [[NSMenu alloc] init];
    [self.currencyArray enumerateObjectsUsingBlock:^(Currency *currency, NSUInteger idx, BOOL *stop) {
        [subMenu addItemWithTitle:currency.displayName action:@selector(setCountry:) keyEquivalent:@""];
    }];
    self.selectedCurrencyMenuItem = [subMenu itemWithTitle:@"United States Dollar"];
    
    [self.menu setSubmenu:subMenu forItem:self.currencySelectorMenuItem];
    self.statusItem.menu = self.menu;
}

#pragma mark - NSTokenFieldDelegate

#pragma mark - Actions

- (void)didReceiveHotKey {
    [self.inputWindow center];
    [self.inputWindow makeKeyAndOrderFront:self];
    [self.inputWindow orderFrontRegardless];
}

- (void)terminate:(id)sender {
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

#pragma mark - Setters

- (void)setCountry:(NSMenuItem *)item {
    self.selectedCurrencyMenuItem = item;
}

- (void)setSelectedCurrencyMenuItem:(NSMenuItem *)selectedCurrencyMenuItem {
    if (_selectedCurrencyMenuItem != selectedCurrencyMenuItem) {
        _selectedCurrencyMenuItem.state = NSOffState;
        selectedCurrencyMenuItem.state = NSOnState;
        _selectedCurrencyMenuItem = selectedCurrencyMenuItem;
        self.currencySelectorMenuItem.title = selectedCurrencyMenuItem.title;
        
        NSUInteger index = [selectedCurrencyMenuItem.menu indexOfItem:selectedCurrencyMenuItem];
        self.selectedCurrency = self.currencyArray[index];
        _statusItem.title = self.selectedCurrency.isoCode;
    }
}

@end

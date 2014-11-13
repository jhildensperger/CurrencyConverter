//
//    KMAppDelegate.m
//    FeedbinNotifier
//
//    Created by Mikael Konutgan on 30/06/2013.
//    Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMFeedbinClient.h"
#import <ParseOSX/Parse.h>

@interface KMAppDelegate ()

@property (strong, nonatomic) KMFeedbinClient *feedbinClient;
@property (nonatomic) NSMenuItem *currencySelectorMenuItem;
@property (nonatomic) NSMenuItem *selectedCurrencyMenuItem;

@end

static NSString * const kParseApplicationId = @"OedvE5YXkz9gRNfTSYx2YReMUpUyv9WuHDSmJVty";
static NSString * const kParseRESTAPIKey = @"pjBXsKkEzUI2ZVcLAG857BIrbR637CPv9fWG5oSV";

@implementation KMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//        [Parse setApplicationId: clientKey:];
//        [PFUser enableAutomaticUser];
//
//        PFACL *defaultACL = [PFACL ACL];
//        [defaultACL setPublicReadAccess:YES];
//        [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
//        [PFAnalytics trackAppOpenedWithLaunchOptions:nil];

        [self setupStatusItem];
}

- (void)getExchangeRateFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency amount:(NSNumber *)amount {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithString:@"https://api.parse.com"];
        URLComponents.path = @"/1/functions/calculateExchangeRate.json";

}

- (void)setupStatusItem {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.title = @"";
        _statusItem.image = [NSImage imageNamed:@"icon"];
        _statusItem.alternateImage = [NSImage imageNamed:@"icon-alt"];
        _statusItem.highlightMode = YES;

        [self setupMenu];
}

- (NSArray *)currencies {
        static NSArray *currencies;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                currencies = @[@"United Arab Emirates Dirham",
                                             @"Afghan Afghani",
                                             @"Albanian Lek",
                                             @"Armenian Dram",
                                             @"Netherlands Antillean Guilder",
                                             @"Angolan Kwanza",
                                             @"Argentine Peso",
                                             @"Australian Dollar",
                                             @"Aruban Florin",
                                             @"Azerbaijani Manat",
                                             @"Bosnia-Herzegovina Convertible Mark",
                                             @"Barbadian Dollar",
                                             @"Bangladeshi Taka",
                                             @"Bulgarian Lev",
                                             @"Bahraini Dinar",
                                             @"Burundian Franc",
                                             @"Bermudan Dollar",
                                             @"Brunei Dollar",
                                             @"Bolivian Boliviano",
                                             @"Brazilian Real",
                                             @"Bahamian Dollar",
                                             @"Bitcoin",
                                             @"Bhutanese Ngultrum",
                                             @"Botswanan Pula",
                                             @"Belarusian Ruble",
                                             @"Belize Dollar",
                                             @"Canadian Dollar",
                                             @"Congolese Franc",
                                             @"Swiss Franc",
                                             @"Chilean Unit of Account (UF)",
                                             @"Chilean Peso",
                                             @"Chinese Yuan",
                                             @"Colombian Peso",
                                             @"Costa Rican Colón",
                                             @"Cuban Peso",
                                             @"Cape Verdean Escudo",
                                             @"Czech Republic Koruna",
                                             @"Djiboutian Franc",
                                             @"Danish Krone",
                                             @"Dominican Peso",
                                             @"Algerian Dinar",
                                             @"Estonian Kroon",
                                             @"Egyptian Pound",
                                             @"Eritrean Nakfa",
                                             @"Ethiopian Birr",
                                             @"Euro",
                                             @"Fijian Dollar",
                                             @"Falkland Islands Pound",
                                             @"British Pound Sterling",
                                             @"Georgian Lari",
                                             @"Guernsey Pound",
                                             @"Ghanaian Cedi",
                                             @"Gibraltar Pound",
                                             @"Gambian Dalasi",
                                             @"Guinean Franc",
                                             @"Guatemalan Quetzal",
                                             @"Guyanaese Dollar",
                                             @"Hong Kong Dollar",
                                             @"Honduran Lempira",
                                             @"Croatian Kuna",
                                             @"Haitian Gourde",
                                             @"Hungarian Forint",
                                             @"Indonesian Rupiah",
                                             @"Israeli New Sheqel",
                                             @"Manx pound",
                                             @"Indian Rupee",
                                             @"Iraqi Dinar",
                                             @"Iranian Rial",
                                             @"Icelandic Króna",
                                             @"Jersey Pound",
                                             @"Jamaican Dollar",
                                             @"Jordanian Dinar",
                                             @"Japanese Yen",
                                             @"Kenyan Shilling",
                                             @"Kyrgystani Som",
                                             @"Cambodian Riel",
                                             @"Comorian Franc",
                                             @"North Korean Won",
                                             @"South Korean Won",
                                             @"Kuwaiti Dinar",
                                             @"Cayman Islands Dollar",
                                             @"Kazakhstani Tenge",
                                             @"Laotian Kip",
                                             @"Lebanese Pound",
                                             @"Sri Lankan Rupee",
                                             @"Liberian Dollar",
                                             @"Lesotho Loti",
                                             @"Lithuanian Litas",
                                             @"Latvian Lats",
                                             @"Libyan Dinar",
                                             @"Moroccan Dirham",
                                             @"Moldovan Leu",
                                             @"Malagasy Ariary",
                                             @"Macedonian Denar",
                                             @"Myanma Kyat",
                                             @"Mongolian Tugrik",
                                             @"Macanese Pataca",
                                             @"Mauritanian Ouguiya",
                                             @"Maltese Lira",
                                             @"Mauritian Rupee",
                                             @"Maldivian Rufiyaa",
                                             @"Malawian Kwacha",
                                             @"Mexican Peso",
                                             @"Malaysian Ringgit",
                                             @"Mozambican Metical",
                                             @"Namibian Dollar",
                                             @"Nigerian Naira",
                                             @"Nicaraguan Córdoba",
                                             @"Norwegian Krone",
                                             @"Nepalese Rupee",
                                             @"New Zealand Dollar",
                                             @"Omani Rial",
                                             @"Panamanian Balboa",
                                             @"Peruvian Nuevo Sol",
                                             @"Papua New Guinean Kina",
                                             @"Philippine Peso",
                                             @"Pakistani Rupee",
                                             @"Polish Zloty",
                                             @"Paraguayan Guarani",
                                             @"Qatari Rial",
                                             @"Romanian Leu",
                                             @"Serbian Dinar",
                                             @"Russian Ruble",
                                             @"Rwandan Franc",
                                             @"Saudi Riyal",
                                             @"Solomon Islands Dollar",
                                             @"Seychellois Rupee",
                                             @"Sudanese Pound",
                                             @"Swedish Krona",
                                             @"Singapore Dollar",
                                             @"Saint Helena Pound",
                                             @"Sierra Leonean Leone",
                                             @"Somali Shilling",
                                             @"Surinamese Dollar",
                                             @"São Tomé and Príncipe Dobra",
                                             @"Salvadoran Colón",
                                             @"Syrian Pound",
                                             @"Swazi Lilangeni",
                                             @"Thai Baht",
                                             @"Tajikistani Somoni",
                                             @"Turkmenistani Manat",
                                             @"Tunisian Dinar",
                                             @"Tongan Paʻanga",
                                             @"Turkish Lira",
                                             @"Trinidad and Tobago Dollar",
                                             @"New Taiwan Dollar",
                                             @"Tanzanian Shilling",
                                             @"Ukrainian Hryvnia",
                                             @"Ugandan Shilling",
                                             @"United States Dollar",
                                             @"Uruguayan Peso",
                                             @"Uzbekistan Som",
                                             @"Venezuelan Bolívar Fuerte",
                                             @"Vietnamese Dong",
                                             @"Vanuatu Vatu",
                                             @"Samoan Tala",
                                             @"CFA Franc BEAC",
                                             @"Silver (troy ounce)",
                                             @"Gold (troy ounce)",
                                             @"East Caribbean Dollar",
                                             @"Special Drawing Rights",
                                             @"CFA Franc BCEAO",
                                             @"CFP Franc",
                                             @"Yemeni Rial",
                                             @"South African Rand",
                                             @"Zambian Kwacha (pre-2013)",
                                             @"Zambian Kwacha",
                                             @"Zimbabwean Dollar"
                                             ];
        });
        return currencies;
}

- (NSMenu *)subMenu {
        NSMenu *subMenu = [[NSMenu alloc] init];
        [[self currencies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [subMenu addItemWithTitle:obj action:@selector(setCountry:) keyEquivalent:@""];
        }];
        self.selectedCurrencyMenuItem = [subMenu itemWithTitle:@"United States Dollar"];
        return subMenu;
}

- (void)setupMenu {
        NSMenu *menu = [[NSMenu alloc] init];
        self.currencySelectorMenuItem = [[NSMenuItem alloc] initWithTitle:@"Select Default" action:nil keyEquivalent:@""];

        [menu setSubmenu:[self subMenu] forItem:self.currencySelectorMenuItem];
        [menu addItem:self.currencySelectorMenuItem];

        [menu addItemWithTitle:@"Refresh" action:@selector(getUnreadEntries:) keyEquivalent:@""];

        [menu addItem:[NSMenuItem separatorItem]];
        [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];

        self.statusItem.menu = menu;
}

#pragma mark - Menu actions

- (void)setCountry:(NSMenuItem *)item {
        self.selectedCurrencyMenuItem = item;
}

- (void)setSelectedCurrencyMenuItem:(NSMenuItem *)selectedCurrencyMenuItem {
        if (_selectedCurrencyMenuItem != selectedCurrencyMenuItem) {
                _selectedCurrencyMenuItem.state = NSOffState;
                selectedCurrencyMenuItem.state = NSOnState;
                _selectedCurrencyMenuItem = selectedCurrencyMenuItem;
                self.currencySelectorMenuItem.title = selectedCurrencyMenuItem.title;

        }
}

- (void)terminate:(id)sender {
        [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end

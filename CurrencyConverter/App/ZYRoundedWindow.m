//
//    ZYRoundedWindow.m
//    CurrencyConverter
//
//    Created by James Hildensperger on 11/14/14.
//    Copyright (c) 2014 Parse. All rights reserved.
//

#import "ZYRoundedWindow.h"

@implementation ZYRoundedWindow

- (BOOL) canBecomeKeyWindow { return YES; }
- (BOOL) acceptsFirstResponder { return YES; }
- (BOOL) becomeFirstResponder { return YES; }
- (BOOL) resignFirstResponder { return YES; }

@end

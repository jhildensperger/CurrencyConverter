//
//                                ZYRoundedWindow.m
//                                CurrencyConverter
//
//                                Created by James Hildensperger on 11/14/14.
//                                Copyright (c) 2014 Parse. All rights reserved.
//

#import "ZYRoundedWindow.h"
#import <Quartz/Quartz.h>

@interface ZYRoundedView : NSClipView

@end

@implementation ZYRoundedView

- (void)drawRect:(NSRect)rect {
                                NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.frame xRadius:5 yRadius:5];
                                [path addClip];

                                [[NSColor controlColor] set];
                                [path fill];

                                [super drawRect:rect];
}

@end

@implementation ZYRoundedWindow

- (void)awakeFromNib {
                                [self setOpaque:NO];
                                self.delegate = self;
                                self.backgroundColor = [NSColor clearColor];
}

- (void)windowDidResignKey:(NSNotification *)notification {
                                [self orderOut:self];
}

- (BOOL)canBecomeKeyWindow {
                                return YES;
}

- (BOOL)acceptsFirstResponder {
                                return YES;
}

- (BOOL)becomeFirstResponder {
                                return YES;
}

- (BOOL)resignFirstResponder {
                                return YES;
}

@end

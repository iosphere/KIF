//
//  UIView+testHelpers.m
//  Cashier
//
//  Created by Felix Schneider on 23.10.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "UIView+testHelpers.h"

@implementation UIView (testHelpers)

- (UIView *)superviewWithKindOfClass:(Class)aClass returnSelfIfMatchesClass:(BOOL)canReturnSelf
{
    
    UIView *node = canReturnSelf?self:self.superview;
    
    while (node && ![node isKindOfClass:aClass]) {
        node = [node superview];
    }
    return node;
}

- (UIView *)subviewWithKindOfClass:(Class)aClass;
{
    NSMutableArray* nodeQueue = [NSMutableArray arrayWithObject:self];
    while ([nodeQueue count] > 0) {
        UIView* node = [nodeQueue objectAtIndex:0];
        [nodeQueue removeObjectAtIndex:0];
        if ([node isKindOfClass:aClass]) {
            return node;
        } else {
            [nodeQueue addObjectsFromArray:node.subviews];
        }
    }
    return nil;
}

- (UIView *)subviewWithAccessibilityLabel:(NSString *)aLabel {
    NSMutableArray* nodeQueue = [NSMutableArray arrayWithObject:self];
    while ([nodeQueue count] > 0) {
        UIView* node = [nodeQueue objectAtIndex:0];
        [nodeQueue removeObjectAtIndex:0];
        if ([node.accessibilityLabel isEqualToString:aLabel]) {
            return node;
        } else {
            [nodeQueue addObjectsFromArray:node.subviews];
        }
    }
    return nil;
}

@end

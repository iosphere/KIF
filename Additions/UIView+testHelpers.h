//
//  UIView+testHelpers.h
//  Cashier
//
//  Created by Felix Schneider on 23.10.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (testHelpers)

- (UIView *)subviewWithKindOfClass:(Class)aClass;
- (UIView *)subviewWithAccessibilityLabel:(NSString *)aLabel;
- (UIView *)superviewWithKindOfClass:(Class)aClass returnSelfIfMatchesClass:(BOOL)canReturnSelf;
@end

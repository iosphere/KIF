//
//  UIBarButtonItem+KIFAdditions.h
//  KIF
//
//  Created by Felix Lamouroux on 28.11.12.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (KIFAdditions)

+ (NSString*)accessibilityLabelForBarButtonWithSystemItem:(UIBarButtonSystemItem)item;

@end

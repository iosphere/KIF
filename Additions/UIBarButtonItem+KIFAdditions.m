//
//  UIBarButtonItem+KIFAdditions.m
//  KIF
//
//  Created by Felix Lamouroux on 28.11.12.
//
//

#import "UIBarButtonItem+KIFAdditions.h"

@implementation UIBarButtonItem (KIFAdditions)

+ (NSString*)accessibilityLabelForBarButtonWithSystemItem:(UIBarButtonSystemItem)item {
    UIBarButtonItem *barButtonClone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:nil action:nil];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UINavigationItem *navitem = [[UINavigationItem alloc] init];
    [navitem setLeftBarButtonItem:barButtonClone];
    [navBar setItems:@[  navitem ] animated:NO];
    NSString *title = [(id)[(id)barButtonClone view] title];
    [navBar release];
    [navitem release];
    [barButtonClone release];
    NSAssert(title, @"Could not create title for UIBarButtonSystemItem: %i", item);
    return title;
}

@end

//
//  NSLocale+forceLocale.m
//  KIF
//
//  Created by Felix Schneider on 27.11.12.
//
//

#import "NSLocale+forceLocale.h"

@implementation NSLocale (forceLocale)

+ (id)currentLocale {
    return [[NSLocale alloc] initWithLocaleIdentifier:[[[NSProcessInfo processInfo] environment] objectForKey:@"ISH_LOCALE"]];
}

+ (id)autoupdatingCurrentLocale {
    return [self currentLocale];
}

@end

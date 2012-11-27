//
//  NSLocale+forceLocale.h
//  KIF
//
//  Created by Felix Schneider on 27.11.12.
//
//

#import <Foundation/Foundation.h>

@interface NSLocale (forceLocale)
+ (id)currentLocale;
+ (id)autoupdatingCurrentLocale;
@end

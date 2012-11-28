//
//  KIFTestStep+usefulSteps.h
//  Cashier
//
//  Created by Felix Schneider on 23.10.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFTestStep.h"

@interface KIFTestStep (usefulSteps)

+ (id)stepToTapRowInTableViewAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method stepToSelectPickerViewRowWithTitle:inComponent:
 @abstract A step that selects an item from a currently visible picker view in a specific picker component.
 @discussion With a picker view already visible, this step will find an item with the given title in the specified component, nd select that item.
 @param title The title of the row to select.
 @param componentIndex The index of the component to draw from.
 @result A configured test step.
 */
+ (KIFTestStep *)stepToSelectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)componentIndex;
+ (KIFTestStep *)stepToScrollToBottom;
+ (KIFTestStep *)stepToEnterDateInFirstDatePicker:(NSDate*)date;
+ (KIFTestStep *)stepToResignFirstResponderWithAccessibilityLabel:(NSString *)label;
+ (KIFTestStep *)stepToTapCameraShutterButton;
+ (KIFTestStep *)stepToTapCameraUseImageButton;

+ (KIFTestStep *)stepToWaitToSettleShort;
+ (KIFTestStep *)stepToScrollInTableViewToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
+ (id)stepToScrollToCellContainingAccessibilityLabel:(NSString *)label atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
+ (id)stepToTapCellInCollectionViewWithAccessibilityLabel:(NSString*)collectionViewLabel atIndexPath:(NSIndexPath *)indexPath;
#endif

+ (id)stepToTapBarButtonItemWithSystemItem:(UIBarButtonSystemItem)item;
+ (id)stepToWaitForBarButtonItemWithSystemItem:(UIBarButtonSystemItem)item;
+ (id)stepToDismissViewController;
@end

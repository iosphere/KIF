//
//  KIFTestStep+usefulSteps.m
//  Cashier
//
//  Created by Felix Schneider on 23.10.12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#import "KIFTestStep+usefulSteps.h"
#import "CGGeometry-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIView+testHelpers.h"
#import "UIAccessibilityElement-KIFAdditions.h"


@implementation KIFTestStep (usefulSteps)

+ (id)stepToTapRowInTableViewAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *description = [NSString stringWithFormat:@"Step to tap row %d in tableView", [indexPath row]];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {

        UITableView *tableView = (UITableView *)
        [[[[UIApplication sharedApplication] delegate] window] subviewWithKindOfClass:[UITableView class]];

        KIFTestCondition(tableView, error, @"No TableView found");

        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            KIFTestCondition([indexPath section] < [tableView numberOfSections], error, @"Section %d is not found in table view %@", [indexPath section], tableView);
            KIFTestCondition([indexPath row] < [tableView numberOfRowsInSection:[indexPath section]], error, @"Row %d is not found in section %d of table view; TableView has %d sections. The current section has %d indexes", [indexPath row], [indexPath section], [tableView numberOfSections], [tableView numberOfRowsInSection:[indexPath section]]);
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
            cell = [tableView cellForRowAtIndexPath:indexPath];
        }
        KIFTestCondition(cell, error, @"Table view cell at index path %@ not found", indexPath);

        CGRect cellFrame = [cell.contentView convertRect:[cell.contentView frame] toView:tableView];
        [tableView tapAtPoint:CGPointCenteredInRect(cellFrame)];

        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToScrollInTableViewToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSString *description = [NSString stringWithFormat:@"Step to scroll to indexPath %@ in tableView", indexPath];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UITableView *tableView = (UITableView *)
        [[[[UIApplication sharedApplication] delegate] window] subviewWithKindOfClass:[UITableView class]];
        
        KIFTestCondition(tableView, error, @"No TableView found");
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
        if (animated) {
            // Wait
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, false);
        }
        
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToScrollToCellContainingAccessibilityLabel:(NSString *)label atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSString *description = [NSString stringWithFormat:@"Step to scroll to row with label: %@ in tableView", label];
    return [KIFTestStep stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        UITableView *tableView = (UITableView *)
        [[[[UIApplication sharedApplication] delegate] window] subviewWithKindOfClass:[UITableView class]];
        
        KIFTestCondition(tableView, error, @"No TableView found");
        
        KIFTestCondition([tableView isKindOfClass:[UITableView class]], error, @"Specified view is not a UITableView");

        
        UIView *view = [tableView subviewWithAccessibilityLabel:label];
        
        UITableViewCell *aCell = (UITableViewCell *)[view superviewWithKindOfClass:[UITableViewCell class] returnSelfIfMatchesClass:YES];
        if (!aCell) {
            NSUInteger numSections = tableView.numberOfSections;
            NSUInteger section = 0;
            while (section < numSections) {
                NSUInteger numRows = [tableView numberOfRowsInSection:section];
                NSUInteger row = 0;

                while (row < numRows) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    NSLog(@"indexPath: %@",indexPath);
                    
                    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:scrollPosition animated:animated];
                    if (animated) {
                        // Wait
                        CGFloat timeToWait = ((row == 0) && (section == 0))?0.8:0.5;
                        CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeToWait, false);
                    }
                    
                    view = [tableView subviewWithAccessibilityLabel:label];
                    
                    aCell = (UITableViewCell *)[view superviewWithKindOfClass:[UITableViewCell class] returnSelfIfMatchesClass:YES];
                    if (aCell) {
                        break;
                    }
                    indexPath = [[tableView indexPathsForVisibleRows] lastObject];
                    section = indexPath.section;
                    row = indexPath.row + 1;
                    numRows = [tableView numberOfRowsInSection:section];
                }
                if (aCell) {
                    break;
                }
                section ++;
            }
        }
        KIFTestCondition(aCell, error, @"No cell containing view with label: %@ found",label);
        
        [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:aCell] atScrollPosition:scrollPosition animated:animated];
        if (animated) {
            // Wait
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
        }
        return KIFTestStepResultSuccess;
    }];
}

+ (id)stepToSelectPickerViewRowWithTitle:(NSString *)title inComponent:(NSInteger)componentIndex {
    NSString *description = [NSString stringWithFormat:@"Select the \"%@\" item from the picker", title];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {

        // Find the picker view
        UIPickerView *pickerView = nil;
        for (UIView *window in [[UIApplication sharedApplication] windows]) {
            pickerView = (UIPickerView *)[window subviewWithKindOfClass:[UIPickerView class]];
            if (pickerView) {
                break;
            }
        }
        
        KIFTestCondition(pickerView, error, @"No picker view is present");

        NSInteger rowCount = [pickerView.dataSource pickerView:pickerView numberOfRowsInComponent:componentIndex];
        for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            NSString *rowTitle = nil;
            if ([pickerView.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
                rowTitle = [pickerView.delegate pickerView:pickerView titleForRow:rowIndex forComponent:componentIndex];
            } else if ([pickerView.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
                // This delegate inserts views directly, so try to figure out what the title is by looking for a label
                UIView *rowView = [pickerView.delegate pickerView:pickerView viewForRow:rowIndex forComponent:componentIndex reusingView:nil];
                NSArray *labels = [rowView subviewsWithClassNameOrSuperClassNamePrefix:@"UILabel"];
                UILabel *label = (labels.count > 0 ? [labels objectAtIndex:0] : nil);
                rowTitle = label.text;
            }

            if ([rowTitle isEqual:title]) {
                [pickerView selectRow:rowIndex inComponent:componentIndex animated:YES];
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);

                // Tap in the middle of the picker view to select the item
                [pickerView tap];

                // The combination of selectRow:inComponent:animated: and tap does not consistently result in
                // pickerView:didSelectRow:inComponent: being called on the delegate. We need to do it explicitly.
                if ([pickerView.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
                    [pickerView.delegate pickerView:pickerView didSelectRow:rowIndex inComponent:componentIndex];
                }

                return KIFTestStepResultSuccess;
            }
        }

        KIFTestCondition(NO, error, @"Failed to find picker view value with title \"%@\"", title);
        return KIFTestStepResultFailure;
    }];
}

+ (id)stepToEnterDateInFirstDatePicker:(NSDate*)date {
    NSString *description=[NSString stringWithFormat:@"Enter date to Date picker with date '%@'",[date description]];
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error)
            {

                UIDatePicker *picker = nil;

                for (UIView *window in [[UIApplication sharedApplication] windows]) {
                    picker = (UIDatePicker *)[window subviewWithKindOfClass:[UIDatePicker class]];
                    if (picker) {
                        break;
                    }
                }

                KIFTestCondition([picker isKindOfClass:[UIDatePicker class]], error, @"Specified view is not a picker");

                // Wait for the view to appear
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);

                [picker setDate:date animated:NO];
                [picker sendActionsForControlEvents:UIControlEventValueChanged];

                // Wait for the things to settle
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);

                UITableView *tableView = (UITableView *)[ [[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:[UITableView class]];
                [tableView endEditing:YES];

                // Wait for the keyboard to disappear
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);

                return KIFTestStepResultSuccess;
            }];
}

+ (id)stepToScrollToTop {
    KIFTestStep *scrollStep = nil;
    
    scrollStep = [KIFTestStep stepWithDescription:@"Scroll to top" executionBlock:^(KIFTestStep * step, NSError **error) {
        UIScrollView *scrollView = (UIScrollView *)[[[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:[UIScrollView class]];
        KIFTestCondition(scrollView, error, @"No scrollView view is present");
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
        return KIFTestStepResultSuccess;
    }];
    
    return scrollStep;
}

+ (id)stepToScrollToBottom {
    KIFTestStep *scrollStep = nil;

    scrollStep = [KIFTestStep stepWithDescription:@"Scroll to bottom" executionBlock:^(KIFTestStep * step, NSError **error) {
        UIScrollView *scrollView = (UIScrollView *)[[[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:[UIScrollView class]];
        KIFTestCondition(scrollView, error, @"No scrollView view is present");
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height) animated:YES];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);        
        return KIFTestStepResultSuccess;
    }];

    return scrollStep;
}

+ (id)stepToTapCameraShutterButton {
    KIFTestStep *scrollStep = nil;

    scrollStep = [self stepWithDescription:@"Tapping Camera Button" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {
        UIView *taggedView = [[[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:NSClassFromString(@"PLCameraLargeShutterButton")];

        if (!taggedView) {
            taggedView = [[[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:NSClassFromString(@"PLCameraButton")];
        }

        KIFTestCondition(taggedView, error, @"Cannot find Camera Shutter Button");
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, false);

        NSString *accessibilityLabel = taggedView.accessibilityLabel;
        [[KIFTestStep stepToTapViewWithAccessibilityLabel:accessibilityLabel] executeAndReturnError:error];

        return KIFTestStepResultSuccess;

    }];

    return scrollStep;
}

+ (id)stepToTapCameraUseImageButton {
//
//    <PLCropOverlayBottomBar: 0x1ecb8f30; frame = (0 472; 320 96); autoresize = W+TM; layer = <CALayer: 0x1ecee800>>
//    | <UIImageView: 0x1d208d50; frame = (0 0; 320 96); autoresize = W; layer = <CALayer: 0x1ebeff10>> - PLCameraCropOverlayBottomBarOpaque-568h
//    |    | <PLCropOverlayBottomBarButton: 0x1eb58450; baseClass = UIButton; frame = (6 30.5; 102 41); opaque = NO; layer = <CALayer: 0x1eb58560>>
//    |    |    | <UIImageView: 0x1ecf1de0; frame = (0 0; 102 41); clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x1ecf1e40>> - (null)
//    |    |    | <UIButtonLabel: 0x1ecf0e00; frame = (15 10.5; 72 15); text = 'Wiederholen'; clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x1ecf0ea0>>
//    |    | <PLCropOverlayBottomBarButton: 0x1ecf1fe0; baseClass = UIButton; frame = (212 30.5; 102 41); opaque = NO; layer = <CALayer: 0x1ecf1db0>>
//    |    |    | <UIImageView: 0x1eceb9f0; frame = (0 0; 102 41); clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x1ecc25a0>> - (null)
//    |    |    | <UIButtonLabel: 0x1ecc0040; frame = (18 10.5; 65 15); text = 'Verwenden'; clipsToBounds = YES; opaque = NO; userInteractionEnabled = NO; layer = <CALayer: 0x1ecc00e0>>
//    |    | <UILabel: 0x1d1e0060; frame = (108 -1; 104 96); text = 'Vorschau'; clipsToBounds = YES; userInteractionEnabled = NO; layer = <CALayer: 0x1c5aaf60>>

    return [self stepWithDescription:@"Tapping Camera Use Image Button" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5.0, false);

        UIView *toolBar = [[[UIApplication sharedApplication] keyWindow] subviewWithKindOfClass:NSClassFromString(@"PLCropOverlayBottomBar")];
        UIView *container = [toolBar subviewWithKindOfClass:[UIImageView class]];

        KIFTestCondition(container, error, @"Cannot find Camera Toolbar");

        UIView *farRightView = nil;
        for (UIView *aView in container.subviews) {
            if ([aView isKindOfClass:NSClassFromString(@"PLCropOverlayBottomBarButton")]) {
                if (aView.frame.origin.x > farRightView.frame.origin.x) {
                    farRightView = aView;
                }
            }
        }

        NSString *accessibilityLabel = [[farRightView subviewWithKindOfClass:NSClassFromString(@"UIButtonLabel")] accessibilityLabel];
        KIFTestCondition(accessibilityLabel, error, @"Cannot find Use Photo label");

        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0, false);
        [[KIFTestStep stepToTapViewWithAccessibilityLabel:accessibilityLabel] executeAndReturnError:error];

        return KIFTestStepResultSuccess;

    }];
}

+ (id)stepToResignFirstResponderWithAccessibilityLabel:(NSString *)label {
    return [self stepWithDescription:@"End Editing" executionBlock:^(KIFTestStep *step, NSError **error) {
        UIAccessibilityElement *element = [self _accessibilityElementWithLabel:label accessibilityValue:nil tappable:NO traits:UIAccessibilityTraitNone error:error];
        if (!element) {
            return KIFTestStepResultWait;
        }

        UIView *view = (UIView *)[UIAccessibilityElement viewContainingAccessibilityElement:element];
        KIFTestWaitCondition(view, error, @"Cannot find view with accessibility label \"%@\"", label);

        [view resignFirstResponder];

        // Give the keyboard time

        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, false);
     

        return KIFTestStepResultSuccess;
    }];
}

+ (KIFTestStep *)stepToWaitToSettleShort {
    return [KIFTestStep stepToWaitForTimeInterval:0.5 description:@"WAIT FOR THINGS TO SETTLE FOR 0.5 secs"];
}

@end

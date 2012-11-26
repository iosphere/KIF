//
//  ISHKIFHelpers.h
//  Cashier
//
//  Created by Lukas Mollidor on 10/30/12.
//  Copyright (c) 2012 iosphere GmbH. All rights reserved.
//

#pragma mark - CI
#if RUN_KIF_TESTS
#define ISH_CI_SET_ACCESSIBILITY_LABEL(view, label) [(view) setAccessibilityLabel:(label)]
#else
#define ISH_CI_SET_ACCESSIBILITY_LABEL(view, label) while(0)
#endif

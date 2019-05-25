//
//  NavigationController.m
//  theremin
//
//  Created by Zakk Hoyt on 5/24/19.
//  Copyright © 2019 Zakk Hoyt. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    return self.viewControllers.firstObject;
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeAll;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfScreenEdgesDeferringSystemGestures];
    } else {
        // Fallback on earlier versions
    }
    
    [self.interactivePopGestureRecognizer setEnabled:NO];
}


@end

//
//  VWWInAppPurchaseIdentifier.m
//  STKTest
//
//  Created by Zakk Hoyt on 10/22/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//
//  A good tutorial on IAP here: http://www.raywenderlich.com/21081/introduction-to-in-app-purchases-in-ios-6-tutorial

#import "VWWInAppPurchaseIdentifier.h"


@implementation VWWInAppPurchaseIdentifier

+ (VWWInAppPurchaseIdentifier *)sharedInstance {
    static dispatch_once_t once;
    static VWWInAppPurchaseIdentifier * sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSMutableSet setWithObjects:
                                     VWWInAppPurchaseAutotuneKeysKey,
                                     VWWInAppPurchaseCameraDeviceKey,
                                     VWWInAppPurchaseGraphSensorsKey,
//                                     VWWInAppPurchaseTestPurchaseKey,
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end
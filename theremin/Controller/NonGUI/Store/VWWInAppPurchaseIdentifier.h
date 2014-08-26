//
//  VWWInAppPurchaseIdentifier.h
//  STKTest
//
//  Created by Zakk Hoyt on 10/22/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//
#import "VWWInAppPurchase.h"
#import <StoreKit/StoreKit.h>


static NSString *VWWInAppPurchaseAutotuneKeysKey = @"com.vaporwarewolf.theremin.autotune_keys";
static NSString *VWWInAppPurchaseTestPurchaseKey = @"com.vaporwarewolf.theremin.test_purchase";
static NSString *VWWInAppPurchaseGraphSensorsKey = @"com.vaporwarewolf.theremin.graph_sensors";

@interface VWWInAppPurchaseIdentifier : VWWInAppPurchase
+ (VWWInAppPurchaseIdentifier *)sharedInstance;
+ (BOOL)productPurchased:(NSString*)productIdentifier;
@end
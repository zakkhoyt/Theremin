//
//  VWWInAppPurchase.h
//  STKTest
//
//  Created by Zakk Hoyt on 10/22/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const VWWInAppPurchaseProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@interface VWWInAppPurchase : NSObject
+(VWWInAppPurchase *)sharedInstance;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
-(void)buyProduct:(SKProduct *)product;
-(BOOL)productPurchased:(NSString *)productIdentifier;
-(void)restoreCompletedTransactions;

@end
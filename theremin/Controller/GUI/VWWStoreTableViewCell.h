//
//  VWWStoreTableViewCell.h
//  theremin
//
//  Created by Zakk Hoyt on 8/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@class VWWStoreTableViewCell;


@interface VWWStoreTableViewCell : UITableViewCell
@property (nonatomic, strong) SKProduct *product;
@end

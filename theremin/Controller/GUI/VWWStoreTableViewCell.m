//
//  VWWStoreTableViewCell.m
//  theremin
//
//  Created by Zakk Hoyt on 8/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStoreTableViewCell.h"
#import "VWWInAppPurchaseIdentifier.h"

@interface VWWStoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation VWWStoreTableViewCell


-(void)setProduct:(SKProduct *)product{
    _product = product;
    self.productLabel.text = product.localizedTitle;
    if(product.localizedDescription){
        self.descriptionLabel.text = [NSString stringWithFormat:@"Description: %@", product.localizedDescription];
    } else {
        self.descriptionLabel.text = @"Description: ";
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier] == NO){
        [self.buyButton setTitle:[NSString stringWithFormat:@"$%.2f", _product.price.floatValue] forState:UIControlStateNormal];
        self.buyButton.userInteractionEnabled = YES;
    } else {
        [self.buyButton setTitle:@"Purchased" forState:UIControlStateNormal];
        self.buyButton.userInteractionEnabled = NO;
    }
    
}


- (IBAction)buyButtonTouchUpInside:(id)sender {
    [self.delegate storeTableViewCellBuyButtonAction:self];
}

@end

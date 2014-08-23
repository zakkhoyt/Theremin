//
//  VWWStoreTableViewCell.m
//  theremin
//
//  Created by Zakk Hoyt on 8/23/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWStoreTableViewCell.h"

@interface VWWStoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation VWWStoreTableViewCell


-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}
- (IBAction)buyButtonTouchUpInside:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"Purchase?" message:@"Would you like to purchase?" delegate:self cancelButtonTitle:@"Not not" otherButtonTitles:@"Yes", nil]show];
}

@end

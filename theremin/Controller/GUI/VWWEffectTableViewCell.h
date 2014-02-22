//
//  VWWEffectTableViewCell.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VWWSynthesizerTypes.h"

@class VWWEffectTableViewCell;

@protocol VWWEffectTableViewCellDelegate <NSObject>
-(void)effectTableViewCellEffectConfigButtonTouchUpInside:(VWWEffectTableViewCell*)sender;
@end

@interface VWWEffectTableViewCell : UITableViewCell
@property (nonatomic) VWWEffectType effectType;
@property (nonatomic, weak) id <VWWEffectTableViewCellDelegate> delegate;
@end

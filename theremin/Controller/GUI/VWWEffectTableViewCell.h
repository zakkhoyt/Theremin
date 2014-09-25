//
//  VWWEffectTableViewCell.h
//  Synthesizer
//
//  Created by Zakk Hoyt on 2/19/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTableViewCell.h"

#import "VWWSynthesizerTypes.h"


@interface VWWEffectTableViewCell : VWWTableViewCell
@property (nonatomic) VWWEffectType effectType;
@property (nonatomic) VWWAutoTuneType keyType;
@end

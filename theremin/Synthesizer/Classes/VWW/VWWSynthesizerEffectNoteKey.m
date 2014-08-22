//
//  VWWSynthesizerEffectNoteKey.m
//  Synthesizer
//
//  Created by Zakk Hoyt on 1/7/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWSynthesizerEffectNoteKey.h"

static __attribute ((unused)) NSString* kKeyKey = @"key";
static __attribute ((unused)) NSString* kKeyAMinor = @"aminor";
static __attribute ((unused)) NSString* kKeyAMajor = @"amajor";
static __attribute ((unused)) NSString* kKeyBMinor = @"bminor";
static __attribute ((unused)) NSString* kKeyBMajor = @"bmajor";
static __attribute ((unused)) NSString* kKeyCMajor = @"cmajor";
static __attribute ((unused)) NSString* kKeyDMinor = @"dminor";
static __attribute ((unused)) NSString* kKeyDMajor = @"dmajor";
static __attribute ((unused)) NSString* kKeyEMinor = @"eminor";
static __attribute ((unused)) NSString* kKeyEMajor = @"emajor";
static __attribute ((unused)) NSString* kKeyFMajor = @"fmajor";
static __attribute ((unused)) NSString* kKeyGMinor = @"gminor";
static __attribute ((unused)) NSString* kKeyGMajor = @"gmajor";
static __attribute ((unused)) NSString* kKeyChromatic = @"chromatic";


@implementation VWWSynthesizerEffectNoteKey
-(NSString*)stringForKey{
    switch(self.key){
        case VWWAutoTuneTypeAMinor:
            return kKeyAMinor;
        case VWWAutoTuneTypeAMajor:
            return kKeyAMajor;
        case VWWAutoTuneTypeBMinor:
            return kKeyBMinor;
        case VWWAutoTuneTypeBMajor:
            return kKeyBMajor;
        case VWWAutoTuneTypeCMajor:
            return kKeyCMajor;
        case VWWAutoTuneTypeDMinor:
            return kKeyDMinor;
        case VWWAutoTuneTypeDMajor:
            return kKeyDMajor;
        case VWWAutoTuneTypeEMinor:
            return kKeyEMinor;
        case VWWAutoTuneTypeEMajor:
            return kKeyEMajor;
        case VWWAutoTuneTypeFMajor:
            return kKeyFMajor;
        case VWWAutoTuneTypeGMinor:
            return kKeyAMinor;
        case VWWAutoTuneTypeGMajor:
            return kKeyAMajor;
        case VWWAutoTuneTypeChromatic:
        default:
            return kKeyChromatic;
    }
}
-(VWWAutoTuneType)keyFromString:(NSString*)keyString{
    if([keyString isEqualToString:kKeyAMinor]){
        return VWWAutoTuneTypeAMinor;
    }
    else if([keyString isEqualToString:kKeyAMajor]){
        return VWWAutoTuneTypeAMajor;
    }
    else if([keyString isEqualToString:kKeyBMinor]){
        return VWWAutoTuneTypeBMinor;
    }
    else if([keyString isEqualToString:kKeyBMajor]){
        return VWWAutoTuneTypeBMajor;
    }
    else if([keyString isEqualToString:kKeyCMajor]){
        return VWWAutoTuneTypeCMajor;
    }
    else if([keyString isEqualToString:kKeyDMinor]){
        return VWWAutoTuneTypeDMinor;
    }
    else if([keyString isEqualToString:kKeyDMajor]){
        return VWWAutoTuneTypeDMajor;
    }
    else if([keyString isEqualToString:kKeyEMinor]){
        return VWWAutoTuneTypeEMinor;
    }
    else if([keyString isEqualToString:kKeyEMajor]){
        return VWWAutoTuneTypeEMajor;
    }
    else if([keyString isEqualToString:kKeyFMajor]){
        return VWWAutoTuneTypeFMajor;
    }
    else if([keyString isEqualToString:kKeyGMinor]){
        return VWWAutoTuneTypeGMinor;
    }
    else if([keyString isEqualToString:kKeyGMajor]){
        return VWWAutoTuneTypeGMajor;
    }
    else /* if([keyString isEqualToString:kKeyChromatic]) */ {
        return VWWAutoTuneTypeChromatic;
    }
}

@end

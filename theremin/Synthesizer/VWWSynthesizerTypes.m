

#import "VWWSynthesizerTypes.h"

static NSString *VWWSynthesizerTypesKeyChromatic = @"Chromatic";
static NSString *VWWSynthesizerTypesKeyAMinor = @"A Minor";
static NSString *VWWSynthesizerTypesKeyAMajor = @"A Major";
static NSString *VWWSynthesizerTypesKeyBMinor = @"B Minor";
static NSString *VWWSynthesizerTypesKeyBMajor = @"B Major";
static NSString *VWWSynthesizerTypesKeyCMinor = @"C Minor";
static NSString *VWWSynthesizerTypesKeyCMajor = @"C Major";
static NSString *VWWSynthesizerTypesKeyDMinor = @"D Minor";
static NSString *VWWSynthesizerTypesKeyDMajor = @"D Major";
static NSString *VWWSynthesizerTypesKeyEMinor = @"E Minor";
static NSString *VWWSynthesizerTypesKeyEMajor = @"E Major";
static NSString *VWWSynthesizerTypesKeyFMinor = @"F Minor";
static NSString *VWWSynthesizerTypesKeyFMajor = @"F Major";
static NSString *VWWSynthesizerTypesKeyGMinor = @"G Minor";
static NSString *VWWSynthesizerTypesKeyGMajor = @"G Major";



@implementation VWWSynthesizerTypes

+(NSString*)stringFromKey:(VWWAutoTuneType)key{
    if(key == VWWAutoTuneTypeChromatic){
        return VWWSynthesizerTypesKeyChromatic;
    } else if(key == VWWAutoTuneTypeAMinor){
        return VWWSynthesizerTypesKeyAMinor;
    } else if(key == VWWAutoTuneTypeAMajor){
        return VWWSynthesizerTypesKeyAMajor;
    } else if(key == VWWAutoTuneTypeBMinor){
        return VWWSynthesizerTypesKeyBMinor;
    } else if(key == VWWAutoTuneTypeBMajor){
        return VWWSynthesizerTypesKeyBMajor;
    } else if(key == VWWAutoTuneTypeCMinor){
        return VWWSynthesizerTypesKeyCMinor;
    } else if(key == VWWAutoTuneTypeCMajor){
        return VWWSynthesizerTypesKeyCMajor;
    } else if(key == VWWAutoTuneTypeDMinor){
        return VWWSynthesizerTypesKeyDMinor;
    } else if(key == VWWAutoTuneTypeDMajor){
        return VWWSynthesizerTypesKeyDMajor;
    } else if(key == VWWAutoTuneTypeEMinor){
        return VWWSynthesizerTypesKeyEMinor;
    } else if(key == VWWAutoTuneTypeEMajor){
        return VWWSynthesizerTypesKeyEMajor;
    } else if(key == VWWAutoTuneTypeFMinor){
        return VWWSynthesizerTypesKeyFMinor;
    } else if(key == VWWAutoTuneTypeFMajor){
        return VWWSynthesizerTypesKeyFMajor;
    } else if(key == VWWAutoTuneTypeGMinor){
        return VWWSynthesizerTypesKeyGMinor;
    } else if(key == VWWAutoTuneTypeGMajor){
        return VWWSynthesizerTypesKeyGMajor;
    }
    return @"Unknown Key";
}
+(VWWAutoTuneType)keyFromString:(NSString*)keyString{
    if([keyString isEqualToString:VWWSynthesizerTypesKeyChromatic]){
        return VWWAutoTuneTypeChromatic;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyAMinor]){
        return VWWAutoTuneTypeAMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyAMajor]){
        return VWWAutoTuneTypeAMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyBMinor]){
        return VWWAutoTuneTypeBMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyBMajor]){
        return VWWAutoTuneTypeBMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyCMinor]){
        return VWWAutoTuneTypeCMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyCMajor]){
        return VWWAutoTuneTypeCMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyDMinor]){
        return VWWAutoTuneTypeDMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyDMajor]){
        return VWWAutoTuneTypeDMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyEMinor]){
        return VWWAutoTuneTypeEMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyEMajor]){
        return VWWAutoTuneTypeEMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyFMinor]){
        return VWWAutoTuneTypeFMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyFMajor]){
        return VWWAutoTuneTypeFMajor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyGMinor]){
        return VWWAutoTuneTypeGMinor;
    } else if([keyString isEqualToString:VWWSynthesizerTypesKeyGMajor]){
        return VWWAutoTuneTypeGMajor;
    }
    
    return VWWAutoTuneTypeChromatic;
}

@end
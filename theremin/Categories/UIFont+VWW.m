//
//  UIFont+VWW.m
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "UIFont+VWW.h"
//#import "VWW.h"
@implementation UIFont (VWW)

+(UIFont*)fontForVWW{
    UIFont *font = [UIFont fontWithName:UIFontSmileFontRegular size:18];
    return font;
}

+(UIFont*)fontForVWWWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:UIFontSmileFontRegular size:size];
    return font;
}

+(void)printAvailableFonts{
    VWW_LOG_DEBUG(@"\nListing fonts installed on this device:\n");
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"family:\t%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"name:\t\t%@", name);
        }
    }
}


@end

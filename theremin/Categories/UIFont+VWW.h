//
//  UIFontVWW.h
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>



//static NSString *UIFontSmileFontRegular = @"HelveticaNeue-UltraLight";
//static NSString *UIFontSmileFontRegular = @"HelveticaNeue-Light";
static NSString *UIFontSmileFontRegular = @"HelveticaNeue-Thin";
static NSString *UIFontSmileFontBold = @"HelveticaNeue-Light";


@interface UIFont(VWW)
+(UIFont*)fontForVWW;
+(UIFont*)fontForVWWWithSize:(CGFloat)size;
+(void)printAvailableFonts;
@end

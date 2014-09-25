//
//  UIView+VWW.m
//  RCToolsBalancer
//
//  Created by Zakk Hoyt on 9/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "UIView+VWW.h"
#import "UIFont+VWW.h"

@implementation UIView (VWW)
- (void) setVWWFonts{
    for (UIView *subview in [self subviews]){
        //        NSString *className = NSStringFromClass([subview class]);
        //        SM_LOG_DEBUG(@"Classname: %@", className);
        
        if ([subview isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subview;
            [label setFont:[self smileFontFromCurrentFont:label.font]];
        } else if ([subview isMemberOfClass:[UITextField class]] || [subview isMemberOfClass:[UITextView class]]) {
            UITextField *textfield = (UITextField *)subview;
            [textfield setFont:[self smileFontFromCurrentFont:textfield.font]];
        } else if ([subview isMemberOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [[button titleLabel] setFont:[self smileFontFromCurrentFont:button.titleLabel.font]];
        } else if ([[subview subviews] count] > 0) {
            [subview setVWWFonts];
        }
    }
}

-(UIFont*)smileFontFromCurrentFont:(UIFont*)aCurrentFont{
    if ([self isFontNameBold:[aCurrentFont fontName]]) {
        return [UIFont fontWithName:UIFontSmileFontBold size:aCurrentFont.pointSize];
    }
    return [UIFont fontWithName:UIFontSmileFontRegular size:aCurrentFont.pointSize];
}

-(BOOL)isFontNameBold:(NSString *)aFontName{
    NSRange range = [aFontName rangeOfString:@"Bold"];
    if (range.length == 0 && range.location == NSNotFound) {
        return NO;
    }
    return YES;
}

@end

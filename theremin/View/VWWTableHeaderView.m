//
//  VWWTableHeaderView.m
//  theremin
//
//  Created by Zakk Hoyt on 9/24/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWTableHeaderView.h"
#import "UIFont+VWW.h"

@implementation VWWTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, frame.size.width - 16, frame.size.height - 16)];
        [label setFont:[UIFont fontForVWWWithSize:20]];
        label.textColor = [UIColor greenColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        [self addSubview:label];
        //[self setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    }
    return self;
}
@end

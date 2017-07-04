//
//  tabBarButton.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "tabBarButton.h"

@implementation tabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateDisabled)];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted
{
    
}

@end

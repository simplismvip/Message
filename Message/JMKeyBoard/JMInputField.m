//
//  JMInputField.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMInputField.h"

@interface JMInputField()
@end

@implementation JMInputField

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        self.returnKeyType = UIReturnKeySend;
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.reload) {self.reload();}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

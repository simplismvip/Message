//
//  JMInputField.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^relodBlock)(void);
@interface JMInputField : UITextField
@property (nonatomic, copy) relodBlock reload;
@end

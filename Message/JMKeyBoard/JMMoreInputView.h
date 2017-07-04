//
//  JMMoreInputView.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    typeImage=0,
    typeCamer,
    typeFile,
    typeVideo,
    typeSave,
    typeMoney,
    typeLocation,
    typeCall
} ActionType;

typedef void(^callBackBlock)(ActionType actionType);
@interface JMMoreInputView : UIScrollView
- (void)callBack:(callBackBlock)callBack;
@end

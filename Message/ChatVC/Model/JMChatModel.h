//
//  JMChatModel.h
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageFromMe = 0,
    MessageFromOther = 1
} MessageFrom;

typedef enum {
    MessageText = 0,
    MessageVideo = 1,
    MessageAudio = 2,
    MessageImage = 3,
    MessageUrl = 4
} MessageType;

@interface JMChatModel : NSObject

// 后来新添加的属性
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *msgBody;
@property (nonatomic, assign) MessageFrom msgFrom;
@property (nonatomic, assign) MessageType msgType;

@end

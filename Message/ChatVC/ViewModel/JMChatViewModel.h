//
//  JMChatViewModel.h
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMChatModel.h"

@interface JMChatViewModel : NSObject
@property (nonatomic, assign) CGRect msgBodyFrame;
@property (nonatomic, assign) CGRect timestampframe;
@property (nonatomic, assign) CGRect headerPhotoFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) JMChatModel *message;
@end

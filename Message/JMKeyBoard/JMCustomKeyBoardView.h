//
//  JMCustomKeyBoardView.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMCustomKeyBoardViewDelegate <NSObject>

- (void)jmCustomKeyBoard:(NSDictionary *)dic;

@end

@interface JMCustomKeyBoardView : UIView
@property (nonatomic, weak) id <JMCustomKeyBoardViewDelegate>delegate;
@end

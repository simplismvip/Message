//
//  JMButtomTabbarButton.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    KeyBoardViewTypeDefault,
    KeyBoardViewTypeRecent,
    KeyBoardViewTypeEmoji,
    KeyBoardViewTypeLxh
    
} KeyBoardViewType;

@class JMButtomTabbarButton;
@protocol JMButtomTabbarButtonDelegate <NSObject>

- (void)emojitabBar:(JMButtomTabbarButton *)tabBar didSelectBtn:(KeyBoardViewType)type;
@end

@interface JMButtomTabbarButton : UIView
@property (nonatomic, assign) id <JMButtomTabbarButtonDelegate> delegate;
@end

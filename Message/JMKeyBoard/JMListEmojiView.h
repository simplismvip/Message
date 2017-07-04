//
//  JMListEmojiView.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMListEmojiViewDelegate <NSObject>
- (void)ListEmojiView:(NSDictionary *)dic;
@end

@interface JMListEmojiView : UIView
@property (nonatomic, weak) id <JMListEmojiViewDelegate>delegate;
@property (nonatomic, strong) NSArray *emojis;
@end

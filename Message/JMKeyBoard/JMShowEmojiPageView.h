//
//  JMShowEmojiPageView.h
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JMShowEmojiPageViewDelegate <NSObject>
- (void)showEmojiPage:(NSDictionary *)dic;
@end

@interface JMShowEmojiPageView : UIView
@property (nonatomic, weak) id <JMShowEmojiPageViewDelegate>delegate;
@property (nonatomic, retain) NSArray *emojiPage;
@end

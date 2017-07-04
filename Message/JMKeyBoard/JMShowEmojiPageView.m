//
//  JMShowEmojiPageView.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMShowEmojiPageView.h"
#import "JMEmojiModel.h"
#import "NSString+Emoji.h"
#import "UIView+Extension.h"
#import <AVFoundation/AVFoundation.h>
@interface JMShowEmojiPageView ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation JMShowEmojiPageView

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)arr
{
    if (_arr == nil) {
        self.arr = [NSMutableArray array];
    }
    return _arr;
}


- (void)setEmojiPage:(NSArray *)emojiPage
{
    _emojiPage = emojiPage;
    
    for (int i = 0; i < emojiPage.count + 1; i ++) {
        
        if (i == emojiPage.count)
        {
            UIButton *emojiBtn       = [[UIButton alloc] init];
            [emojiBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:(UIControlStateNormal)];
            [emojiBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:(UIControlStateSelected)];
            [emojiBtn addTarget:self action:@selector(btnClickDelete:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:emojiBtn];
            return;
        }
        
        JMEmojiModel *model   = emojiPage[i];
        UIButton *emojiBtn       = [[UIButton alloc] init];
        emojiBtn.tag             = i;
        [emojiBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        if (model.png != nil && model.png.length != 0)
        {
            [emojiBtn setImage:[UIImage imageNamed:model.png] forState:(UIControlStateNormal)];
            [emojiBtn setTitle:model.png forState:(UIControlStateNormal)];
            emojiBtn.titleLabel.font = [UIFont systemFontOfSize:0.0];
        }
        else if (model.code)
        {
            [emojiBtn setTitle:[model.code emoji] forState:(UIControlStateNormal)];
            emojiBtn.titleLabel.font = [UIFont systemFontOfSize:32.0];
        }
        [self addSubview:emojiBtn];
    }
}

// 表情按钮
- (void)btnClick:(UIButton *)sender
{
    JMEmojiModel *model = _emojiPage[sender.tag];
    if ([self.delegate respondsToSelector:@selector(showEmojiPage:)]) {
        
        [self.delegate showEmojiPage:@{@"code":model.code}];
    }
}

// 删除按钮
- (void)btnClickDelete:(UIButton *)sender
{
    if (self.dataArray.count == 0) {
        return;
    }
    
    // 删除最后一个元素
    [self.dataArray removeLastObject];
}

- (void)layoutSubviews
{
    CGFloat insert  = 8;
    CGFloat H       = (self.height - 2 * insert) / 3;
    CGFloat W       = (self.width  - 2 * insert) / 7;
    NSInteger count = self.subviews.count;
    
    for (int i = 0; i < count; i ++) {
        
        UIButton *btn = self.subviews[i];
        
        btn.width   = W;
        btn.height  = H;
        btn.x       = insert + W * (i%7);
        btn.y       = insert + H * (i/7);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

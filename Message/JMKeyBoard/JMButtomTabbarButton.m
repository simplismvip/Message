//
//  JMButtomTabbarButton.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMButtomTabbarButton.h"
#import "tabBarButton.h"
#import "UIView+Extension.h"

@interface JMButtomTabbarButton ()
@property (nonatomic, strong) tabBarButton *selectBtn;
@end

@implementation JMButtomTabbarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupTitle:@"Emoji" type:KeyBoardViewTypeEmoji];
    }
    return self;
}

// 设置底部的View上的文字
- (tabBarButton *)setupTitle:(NSString *)title type:(KeyBoardViewType)type
{
//    NSString *selecImage   = @"compose_emotion_table_mid_selected";
    tabBarButton *btn     = [[tabBarButton alloc] init];
    btn.tag           = type;
    
//    [btn setTitle:title forState:(UIControlStateNormal)];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    
//    if (self.subviews.count == 1) {
//        
//        selecImage = @"compose_emotion_table_left_selected";
//        
//    }else if (self.subviews.count == 4){
//        
//        selecImage = @"compose_emotion_table_right_selected";
//    }
//    
//    [btn setBackgroundImage:[UIImage imageNamed:selecImage] forState:(UIControlStateDisabled)];
//    [self addSubview:btn];
    
    return btn;
}

- (void)btnClick:(tabBarButton *)sender
{
    /**
     * 设置上一个取消选中
     * 设置现在选中
     * 当前这个赋值给当前属性
     */
    self.selectBtn.enabled = YES;
    sender.enabled         = NO;
    self.selectBtn         = sender;
    
    if ([self.delegate respondsToSelector:@selector(emojitabBar:didSelectBtn:)]) {
        
        [self.delegate emojitabBar:self didSelectBtn:(KeyBoardViewType)sender.tag];
    }
}

- (void)setDelegate:(id<JMButtomTabbarButtonDelegate>)delegate
{
    _delegate = delegate;
    [self btnClick: [self setupTitle:@"添加" type:KeyBoardViewTypeDefault]];
}


- (void)layoutSubviews
{
    NSInteger btncount = self.subviews.count;
    CGFloat btnw       = self.width / btncount;
    CGFloat btnH       = self.height;
    
    for (int i = 0; i < btncount; i ++) {
        
        tabBarButton *btn = self.subviews[i];
        if (i == 0) {btn.x = i * btnw;}
        if (i > 0 && i < 3) {btn.x = (i+1) * btnw;}
        if (i == btncount-1) {btn.x = btnw;}
        btn.y    = 0;
        btn.width  = btnw;
        btn.height  = btnH;
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

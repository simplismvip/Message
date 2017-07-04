//
//  JMListEmojiView.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMListEmojiView.h"
#import "JMShowEmojiPageView.h"
#import "UIView+Extension.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface JMListEmojiView()<UIScrollViewDelegate, JMShowEmojiPageViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageController;
@end

@implementation JMListEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollView  = [[UIScrollView alloc] init];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled   = YES;
        self.scrollView.delegate  = self;
        [self addSubview:self.scrollView];
        
        self.pageController         = [[UIPageControl alloc] init];
        self.pageController.userInteractionEnabled        = NO;
        self.pageController.currentPageIndicatorTintColor = [UIColor orangeColor];
        self.pageController.pageIndicatorTintColor        = JMColor(222, 223, 225);
        //        self.pageController.backgroundColor   = [UIColor whiteColor];
        [self addSubview:self.pageController];
    }
    return self;
}

// 计算Emoji表情的位置
- (void)setEmojis:(NSArray *)emojis
{
    _emojis    = emojis;
    NSInteger count   = emojis.count / 21 + 1;
    self.pageController.numberOfPages = count;
    
    for (int i = 0; i < count; i ++) {
        
        // 计算每一页个数
        NSRange range;
        range.location = i * 20;
        NSInteger number = emojis.count - range.location;
        
        if (number > 20) {
            
            range.length = 20;
        }else{
            range.length = number;
        }
        
        NSArray *rangeArray           = [emojis subarrayWithRange:range];
        JMShowEmojiPageView *pageView            = [[JMShowEmojiPageView alloc] init];
        pageView.emojiPage            = rangeArray;
        pageView.delegate = self;
        [self.scrollView addSubview:pageView];
        
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pageController.x       = 0;
    self.pageController.width   = self.width;
    self.pageController.height  = 28;
    self.pageController.y       = self.height - 28;
    
    self.scrollView.width       = self.width;
    self.scrollView.x           = 0;
    self.scrollView.y           = 0;
    self.scrollView.height      = self.pageController.y;
    
    NSInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i ++) {
        
        UIView *view            = self.scrollView.subviews[i];
        view.height             = self.scrollView.height;
        view.width              = self.scrollView.width;
        view.y                  = 0;
        view.x                  = self.scrollView.width * i;
    }
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page  = scrollView.contentOffset.x / scrollView.width;
    self.pageController.currentPage = (int)(page + 0.5);
}


#pragma mark -- JMShowEmojiPageViewDelegate
- (void)showEmojiPage:(NSDictionary *)dic
{
    // 运行代理
    if ([self.delegate respondsToSelector:@selector(ListEmojiView:)]) {
        
        [self.delegate ListEmojiView:dic];
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

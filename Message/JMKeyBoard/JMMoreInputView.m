//
//  JMMoreInputView.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMMoreInputView.h"
#import "UIView+Extension.h"
#import "UIImage+JMImage.h"

//Frame
#define kW [[UIScreen mainScreen] bounds].size.width
#define kH [[UIScreen mainScreen] bounds].size.height
#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define baseTag 200

@interface JMMoreInputView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageContorl;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, copy) callBackBlock callBack;
@end

@implementation JMMoreInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSArray *icons = @[@"image", @"camera", @"files", @"video", @"collect"];
        NSArray *names = @[@"相册", @"相机", @"白板", @"视频", @"其他"];
        for (int i = 0; i < names.count; i ++) {
            
            UIButton *btnAction = [UIButton buttonWithType:(UIButtonTypeSystem)];
            btnAction.tag = i+baseTag;
            btnAction.titleLabel.font = [UIFont systemFontOfSize:10];
            btnAction.titleLabel.textColor = JMColor(139, 139, 139);
            //            btnAction.layer.cornerRadius = 10;
            //            btnAction.layer.borderWidth = 1;
            //            btnAction.layer.borderColor = [UIColor grayColor].CGColor;
            //            btnAction.backgroundColor = JMColor(255, 255, 255);
            [btnAction setTitle:names[i] forState:(UIControlStateNormal)];
            [btnAction setImage:[UIImage imageWithRenderingName:icons[i]] forState:(UIControlStateNormal)];
            [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:btnAction];
        }
        
        [self configurePageControl];
    }
    return self;
}

- (void)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case baseTag+0:
            self.callBack(typeImage);
            break;
            
        case baseTag+1:
            self.callBack(typeCamer);
            break;
            
        case baseTag+2:
            self.callBack(typeFile);
            break;
            
        case baseTag+3:
            self.callBack(typeVideo);
            break;
            
        case baseTag+4:
            self.callBack(typeSave);
            break;
            
        case baseTag+5:
            self.callBack(typeMoney);
            break;
            
        case baseTag+6:
            self.callBack(typeLocation);
            
        case baseTag+7:
            self.callBack(typeCall);
            break;
        default:
            break;
    }
}

- (void)configurePageControl{
    
    self.pageContorl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kH - 40, kW, 30)];
    _pageContorl.numberOfPages = 2;
    _pageContorl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageContorl.pageIndicatorTintColor = [UIColor greenColor];
    [_pageContorl addTarget:self action:@selector(handlePageControl:) forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:_pageContorl];
}

- (void)handlePageControl:(UIPageControl *)sender{
    
    // 取出当前分页
    NSInteger number = sender.currentPage;
    
    // 通过分页控制scrollview的偏移量
    self.contentOffset = CGPointMake(number * kW, 0);
}

#pragma UISlider使用方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 结束减速时的偏移量
    CGPoint offSet = scrollView.contentOffset;
    CGFloat number = offSet.x / kW;
    self.pageNum = (NSInteger)number;
    _pageContorl.currentPage = _pageNum;
    
}

#pragma mark --- 代理方法
- (void)changeValue:(NSInteger)page
{
    _pageContorl.currentPage = page-1;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.contentOffset = CGPointMake((page)*kW, 0);
    }];
    
}

+ (instancetype)initWithInputImageView:(CGRect)rect delegate:(id)delegate
{
    JMMoreInputView *inputView = [[JMMoreInputView alloc] initWithFrame:rect];
    inputView.backgroundColor = JMColor(245, 245, 245);
    inputView.pagingEnabled = YES;
    inputView.bounces = NO;
    inputView.contentSize = CGSizeMake(2 * kW, 0);
    return inputView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat edgeW = 30;
    CGFloat edgeH = 30;
    CGFloat w = (self.width-5*edgeW)/4;
    CGFloat h = (self.height-3*edgeH)/2;
    
    int i = 0;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            if (i < 4) {
                
                view.frame = CGRectMake(i*(edgeW+w)+edgeW, edgeH, w, h);
            }else{
                view.frame = CGRectMake((i-4)*(edgeW+w)+edgeW, 2*edgeH+h, w, h);
            }
            
            i++;
        }
    }
}

- (void)callBack:(callBackBlock)callBack
{
    self.callBack = callBack;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

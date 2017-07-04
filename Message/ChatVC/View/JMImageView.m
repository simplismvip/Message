//
//  JMImageView.m
//  PageShare
//
//  Created by JM Zhao on 2017/7/3.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMImageView.h"
#import "UIView+Extension.h"

@interface JMImageView()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation JMImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imageView.center = self.center;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setImageRect:(CGRect)imageRect
{
    _imageRect = imageRect;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    _imageView.frame = _imageRect;
    CGFloat rate = image.size.width/image.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        
        _imageView.frame = CGRectMake(0, 0, self.width, self.width/rate);
        _imageView.center = self.center;
        
    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _imageView.frame = _imageRect;
//        _imageView.center = self.center;
//        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
     
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

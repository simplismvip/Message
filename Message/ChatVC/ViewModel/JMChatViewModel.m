//
//  JMChatViewModel.m
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMChatViewModel.h"
#import "NSString+Extension.h"
#import "UIImage+JMImage.h"

#define kW [[UIScreen mainScreen] bounds].size.width
#define kH [[UIScreen mainScreen] bounds].size.height
#define JMTextPadding 20
#define JMMargin 10

@implementation JMChatViewModel

- (void)setMessage:(JMChatModel *)message
{
    _message = message;
    
    // timestampframe
    _timestampframe = CGRectMake(0, 0, kW, 10);
    
    if (message.msgFrom == MessageFromMe) {
        
        // headerPhotoFrame
        CGFloat iconX = kW-44-JMMargin;
        _headerPhotoFrame = CGRectMake(iconX, CGRectGetMaxY(_timestampframe), 44, 44);
        
        // msgBody
        if (message.msgType == MessageText || message.msgType == MessageUrl) {
            
            CGSize textSize = [message.msgBody sizeWithFont:[UIFont systemFontOfSize:14.0] maxW:kW*0.6];
            CGSize lastSize = CGSizeMake(textSize.width + JMTextPadding*2, textSize.height + JMTextPadding*2);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe);
            CGFloat textX = kW - JMMargin*2 - CGRectGetWidth(_headerPhotoFrame)-lastSize.width;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
            
        }else if (message.msgType == MessageVideo || message.msgType == MessageImage){
            
            CGSize imageSize;
            if (message.msgType == MessageVideo) {
                
                UIImage *image = [UIImage getVideoPreViewImage:message.msgBody];
                imageSize = [image size];
            }else{
            
                imageSize = [[UIImage imageNamed:message.msgBody] size];
            }
            
            CGFloat rate = imageSize.width/imageSize.height;
            CGSize lastSize = CGSizeMake(kW*0.3 + JMTextPadding*2, kW*0.3/rate + JMTextPadding*2);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe)+10;
            CGFloat textX = kW - JMMargin*2 - CGRectGetWidth(_headerPhotoFrame)-lastSize.width;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
            
        }else if (message.msgType == MessageAudio){
            
            CGSize audioSize = CGSizeMake(100, CGRectGetHeight(_headerPhotoFrame));
            CGSize lastSize = CGSizeMake(audioSize.width + JMTextPadding*2, 44 + JMTextPadding);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe);
            CGFloat textX = kW - JMMargin*2 - CGRectGetWidth(_headerPhotoFrame)-lastSize.width;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
        }
        
    }else if (message.msgFrom == MessageFromOther){
    
        // headerPhotoFrame
        CGFloat iconX = JMMargin;
        _headerPhotoFrame = CGRectMake(iconX, CGRectGetMaxY(_timestampframe), 44, 44);
        
        // msgBody
        if (message.msgType == MessageText || message.msgType == MessageUrl) {
            
            CGSize textSize = [message.msgBody sizeWithFont:[UIFont systemFontOfSize:14.0] maxW:kW*0.6];
            CGSize lastSize = CGSizeMake(textSize.width + JMTextPadding*2, textSize.height + JMTextPadding*2);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe);
            CGFloat textX = CGRectGetWidth(_headerPhotoFrame)+2*JMMargin;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
            
        }else if (message.msgType == MessageVideo || message.msgType == MessageImage){
            
            CGSize imageSize;
            if (message.msgType == MessageVideo) {
                
                UIImage *image = [UIImage getVideoPreViewImage:message.msgBody];
                imageSize = [image size];
            }else{
                imageSize = [[UIImage imageNamed:message.msgBody] size];
            }
            
            CGFloat rate = imageSize.width/imageSize.height;
            CGSize lastSize = CGSizeMake(kW*0.3 + JMTextPadding*2, kW*0.3/rate + JMTextPadding*2);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe)+10;
            CGFloat textX = CGRectGetWidth(_headerPhotoFrame)+2*JMMargin;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
            
        }else if (message.msgType == MessageAudio){
            
            CGSize audioSize = CGSizeMake(100, CGRectGetHeight(_headerPhotoFrame));
            CGSize lastSize = CGSizeMake(audioSize.width + JMTextPadding*2, 44+JMTextPadding);
            
            CGFloat textY = CGRectGetMaxY(_timestampframe);
            CGFloat textX = CGRectGetWidth(_headerPhotoFrame)+2*JMMargin;
            _msgBodyFrame = (CGRect){{textX, textY}, lastSize};
        }
    }
    
    // cellHeight
    _cellHeight = CGRectGetMaxY(_msgBodyFrame)+JMMargin;
}

@end

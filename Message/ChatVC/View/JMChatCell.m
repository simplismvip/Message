//
//  JMChatCell.m
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMChatCell.h"
#import "JMChatModel.h"
#import "JMChatViewModel.h"
#import "NSString+Extension.h"
#import "UIImage+JMImage.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define JMColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define JMRandomColor JMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface JMChatCell()

@property (nonatomic, weak) UILabel *timeL;
@property (nonatomic, weak) UIImageView *iconV;
@property (nonatomic, weak) UIButton *textB;
@end


@implementation JMChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = JMColor(231, 231, 231);
        
        UILabel *timeL = [[UILabel alloc] init];
        timeL.textColor = [UIColor blackColor];
        timeL.textAlignment = 1;
        timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:timeL];
        self.timeL = timeL;
        
        UIButton *textB = [UIButton buttonWithType:(UIButtonTypeSystem)];
        textB.layer.cornerRadius = 15;
        textB.layer.masksToBounds = YES;
        [self.contentView addSubview:textB];
        [textB addTarget:self action:@selector(clickMessage:event:) forControlEvents:(UIControlEventTouchUpInside)];
        self.textB = textB;
        
        UIImageView *iconV = [[UIImageView alloc] init];
        [self.contentView addSubview:iconV];
        iconV.layer.cornerRadius = 22;
        iconV.layer.masksToBounds = YES;
        self.iconV = iconV;
//        self.backgroundColor = JMRandomColor;
    }
    
    return self;
}

// 设置frame大小
- (void)setMessageFrame:(JMChatViewModel *)messageFrame
{
    _messageFrame = messageFrame;
    
    // 1> 计算frame
    _textB.frame = _messageFrame.msgBodyFrame;
    _iconV.frame = _messageFrame.headerPhotoFrame;
    _timeL.frame = _messageFrame.timestampframe;
    
    // 2> 赋值
    [self messageModel:messageFrame.message];
}

- (void)messageModel:(JMChatModel *)model
{
    // 时间戳
    _timeL.text = model.timestamp;
    
    // 头像
    if (model.msgFrom == MessageFromMe) {
        
        _iconV.image = [UIImage imageNamed:@"me"];
        [_textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_send_nor"] forState:(UIControlStateNormal)];
        
        if (model.msgType == MessageText || model.msgType == MessageUrl) {
            
            _textB.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            _textB.titleLabel.numberOfLines = 0;//自动换行
            [_textB setTintColor:[UIColor blackColor]];
            [_textB setTitle:model.msgBody forState:(UIControlStateNormal)];
            
        }else if (model.msgType == MessageImage || model.msgType == MessageVideo){
            
            if (model.msgType == MessageVideo) {
                
                UIImage *image = [UIImage getVideoPreViewImage:model.msgBody];
                [_textB setBackgroundImage:[image resizeImageWithName] forState:(UIControlStateNormal)];
            }else{
                [_textB setBackgroundImage:[UIImage resizeImageWithName:model.msgBody] forState:(UIControlStateNormal)];
            }
            
            // [_textB setTitle:[NSString stringWithFormat:@"type == %d", model.msgType] forState:(UIControlStateNormal)];
            
        }else if (model.msgType == MessageAudio){
            
            [_textB setTitle:[NSString stringWithFormat:@"%d''", 12] forState:(UIControlStateNormal)];
        }
        
    }else if (model.msgFrom == MessageFromOther){
    
        _iconV.image = [UIImage imageNamed:@"other"];
        [_textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_recive_press_pic"] forState:(UIControlStateNormal)];
        
        if (model.msgType == MessageText || model.msgType == MessageUrl) {
            
            _textB.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            _textB.titleLabel.numberOfLines = 0;//自动换行
            [_textB setTintColor:[UIColor blackColor]];
            [_textB setTitle:model.msgBody forState:(UIControlStateNormal)];
            
        }else if (model.msgType == MessageImage || model.msgType == MessageVideo){
        
            if (model.msgType == MessageVideo) {
                
                UIImage *image = [UIImage getVideoPreViewImage:model.msgBody];
                [_textB setBackgroundImage:[image resizeImageWithName] forState:(UIControlStateNormal)];
            }else{
                [_textB setBackgroundImage:[UIImage resizeImageWithName:model.msgBody] forState:(UIControlStateNormal)];
            }
            
            // [_textB setTitle:[NSString stringWithFormat:@"type == %d", model.msgType] forState:(UIControlStateNormal)];
            
        }else if (model.msgType == MessageAudio){
        
            [_textB setTitle:[NSString stringWithFormat:@"%d''", 12] forState:(UIControlStateNormal)];
        }
    }
}

/*
- (void)textMessage:(JMChatModel *)model
{
    ECTextMessageBody *msgBody = (ECTextMessageBody *)model.jmMessage.messageBody;
    
    [_textB setTintColor:[UIColor blackColor]];
    _textB.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    _textB.titleLabel.numberOfLines = 0;//自动换行
    [self.textB setTitle:msgBody.text forState:(UIControlStateNormal)];
    
    // 这里需要做判断, 看是哪个人发过来的消息
    if (model.messageFrom==MessageFromOther) {
        
        self.iconV.image = [UIImage imageNamed:@"mine.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_recive_nor"] forState:(UIControlStateNormal)];
        
    }else{
        self.iconV.image = [UIImage imageNamed:@"he.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_send_nor"] forState:(UIControlStateNormal)];
    }
}

- (void)voiceMessage:(JMChatModel *)model
{
    ECVoiceMessageBody *msgBody = (ECVoiceMessageBody *)model.jmMessage.messageBody;
    [self.textB setTitle:[NSString stringWithFormat:@"%ld''", (long)msgBody.duration] forState:(UIControlStateNormal)];
    
    // 这里需要做判断, 看是哪个人发过来的消息
    if (model.messageFrom==MessageFromOther) {
        
        self.iconV.image = [UIImage imageNamed:@"mine.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_recive_nor"] forState:(UIControlStateNormal)];
        
    }else{
        self.iconV.image = [UIImage imageNamed:@"he.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:@"chat_send_nor"] forState:(UIControlStateNormal)];
    }
    
}

- (void)imageMessage:(JMChatModel *)model
{
    ECImageMessageBody *msgBody = (ECImageMessageBody *)model.jmMessage.messageBody;
    
    // 这里需要做判断, 看是哪个人发过来的消息
    if (model.messageFrom==MessageFromOther) {
        
        self.iconV.image = [UIImage imageNamed:@"mine.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:msgBody.localPath] forState:(UIControlStateNormal)];
        
    }else{
        self.iconV.image = [UIImage imageNamed:@"he.jpeg"];
        [self.textB setBackgroundImage:[UIImage resizeImageWithName:msgBody.localPath] forState:(UIControlStateNormal)];
    }
}
*/

- (void)clickMessage:(UIButton *)sender event:(id)event
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [sender convertRect: sender.bounds toView:window];
    
    UITouch *touch =[[event allTouches] anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    if ([self.delegate respondsToSelector:@selector(getsIndexPath:frame:)]) {[self.delegate getsIndexPath:[_tableView indexPathForRowAtPoint:currentTouchPosition] frame:rect];}
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  JMInputHeader.m
//  Message
//
//  Created by JM Zhao on 2017/6/29.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMInputHeader.h"
#import "JMCustomKeyBoardView.h"
#import "JMMoreInputView.h"
//#import "JMIMManger.h"
#import "NSString+Emoji.h"
#import "JMInputField.h"
#import "UIView+Extension.h"
#import "UIImage+JMImage.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define baseTag 200
@interface JMInputHeader ()<UITextFieldDelegate, JMCustomKeyBoardViewDelegate>

@property (nonatomic, weak) UIButton *send;
@property (nonatomic, weak) UIButton *emoji;
@property (nonatomic, weak) UIButton *voice;
@property (nonatomic, weak) UIButton *recordBtn;
@property (nonatomic, weak) JMInputField *textFied;

@property (nonatomic, assign) BOOL isEmoji;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) BOOL isVoice;

@property (nonatomic, strong) JMCustomKeyBoardView *keyView;
@property (nonatomic, strong) JMMoreInputView *moreImput;

@property (nonatomic, copy) keyBoardHeight tabHeight;
@property (nonatomic, copy) inputString contents;

// 语音
@property (nonatomic, copy) inputVoiceRecoing recording;
@property (nonatomic, copy) inputVoiceRecoingEnd recordingEnd;
@property (nonatomic, copy) inputVoiceCancle cancle;
@property (nonatomic, copy) secKeyBoardBlock secKeyBoard;

@end


@implementation JMInputHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // voice按钮
        UIButton *voice = [UIButton buttonWithType:(UIButtonTypeSystem)];
        voice.tag = baseTag + 12;
        [voice setImage:[UIImage imageWithRenderingName:@"keyboardInput"] forState:(UIControlStateNormal)];
        [voice addTarget:self action:@selector(emojiAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:voice];
        self.voice = voice;
        
        // 录音
        UIButton *record = [UIButton buttonWithType:(UIButtonTypeSystem)];
        record.layer.borderWidth = 1.0;
        record.layer.borderColor = JMColor(200, 200, 200).CGColor;
        record.layer.cornerRadius = 9;
        record.layer.masksToBounds = YES;
        [record setTintColor:[UIColor blackColor]];
        [record setTitle:@"按住 说话" forState:(UIControlStateNormal)];
        [record addTarget:self action:@selector(touchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
        [record addTarget:self action:@selector(touchDown:) forControlEvents:(UIControlEventTouchDown)];
        [record addTarget:self action:@selector(touchCancle:) forControlEvents:(UIControlEventTouchDragExit)];
        [self addSubview:record];
        self.recordBtn = record;
        
        // 输入框
        JMInputField *textFied = [[JMInputField alloc] init];
        textFied.reload = ^{
        
            [_textFied becomeFirstResponder];
            _textFied.inputView = nil;
            [_textFied reloadInputViews];
            [_emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
            
            _isEmoji = NO;
            _isMore = NO;
        };
        
        textFied.delegate = self;
        [self addSubview:textFied];
        self.textFied = textFied;
        
        // emoji按钮
        UIButton *emoji = [UIButton buttonWithType:(UIButtonTypeSystem)];
        emoji.tag = baseTag + 13;
        [emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
        [emoji addTarget:self action:@selector(emojiAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:emoji];
        self.emoji = emoji;
        
        // more按钮
        UIButton *send = [UIButton buttonWithType:(UIButtonTypeSystem)];
        send.tag = baseTag + 14;
        [send setImage:[UIImage imageWithRenderingName:@"moreInput"] forState:(UIControlStateNormal)];
        [send addTarget:self action:@selector(emojiAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:send];
        self.send = send;
        
        // 注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// 表情键盘
- (void)emojiAction:(UIButton *)emoji
{
    if (emoji.tag == baseTag+12) {
        
        if (!_isVoice) {
            
            _textFied.inputView = nil;
            [_textFied becomeFirstResponder];
            [_textFied reloadInputViews];
            [_emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
        }else{
        
            [_emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
            [self endEditing:YES];
        }
        
        _isEmoji = NO;
        _isMore = NO;
        
    }else if (emoji.tag == baseTag+13){
        
        if (!_isEmoji) {
            
            _textFied.inputView = self.keyView;
            [_textFied becomeFirstResponder];
            [_textFied reloadInputViews];
            [emoji setImage:[UIImage imageWithRenderingName:@"keyboardInput"] forState:(UIControlStateNormal)];
            
        }else{
        
            _textFied.inputView = nil;
            [_textFied becomeFirstResponder];
            [_textFied reloadInputViews];
            [emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
        }
        
        _isMore = NO;
        _isEmoji = !_isEmoji;
    
    }else if (emoji.tag == baseTag+14){
    
        if (!_isMore) {
            
            _textFied.inputView = self.moreImput;
            [_textFied becomeFirstResponder];
            [_textFied reloadInputViews];
        }else{
        
            [_textFied becomeFirstResponder];
            _textFied.inputView = nil;
            [_textFied reloadInputViews];
        }
        
        _isEmoji = NO;
        _isMore = !_isMore;
    }
}

// 弹出键盘
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger height = CGRectGetMinY(keyBoardFrame);
    
    [_voice setImage:[UIImage imageWithRenderingName:@"voiceInput"] forState:(UIControlStateNormal)];
    self.frame = CGRectMake(0, height-44, self.width, 44);
    if (self.tabHeight) {self.tabHeight(height-44, YES);}
    _textFied.hidden = NO;
    _recordBtn.hidden = YES;
    _isVoice = YES;
}

// 隐藏键盘
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger height = CGRectGetMinY(keyBoardFrame);
    
    [_emoji setImage:[UIImage imageWithRenderingName:@"emojiInput"] forState:(UIControlStateNormal)];
    [_voice setImage:[UIImage imageWithRenderingName:@"keyboardInput"] forState:(UIControlStateNormal)];
    self.frame = CGRectMake(0, height-44, self.width, 44);
    if (self.tabHeight) {self.tabHeight(height-44, NO);}
    _textFied.hidden = YES;
    _recordBtn.hidden = NO;
    _isMore = NO;
    _isVoice = NO;
    _isEmoji = NO;
}

#pragma mark -- 语音按钮
- (void)secBoardCallBack:(secKeyBoardBlock)block
{
    self.secKeyBoard = block;
}

// 松开
- (void)touchUpInside:(UIButton *)sender
{
    self.recordingEnd();
}

// 按下
- (void)touchDown:(UIButton *)sender
{
    self.recording();
}

// 上滑
- (void)touchCancle:(UIButton *)sender
{
    self.cancle();
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.textFied.text = textField.text;
    NSLog(@"%@", string);
    return YES;
}

// 点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.contents) {
        
        if (self.textFied.text.length>0) {
            
            self.contents(self.textFied.text);
            self.textFied.text = @"";
        }
    }
    
    return YES;
}

#pragma mark -- JMCustomKeyBoardViewDelegate
- (void)jmCustomKeyBoard:(NSDictionary *)dic
{
    self.textFied.text = [NSString stringWithFormat:@"%@%@", self.textFied.text, [NSString emojiWithStringCode:dic[@"code"]]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat edge = 5.0;
    CGFloat height = 34;
    _voice.frame = CGRectMake(edge, edge, height, height);
    _recordBtn.frame = CGRectMake(CGRectGetMaxX(_voice.frame)+edge, edge, self.width-127, height);
    _textFied.frame = CGRectMake(CGRectGetMaxX(_voice.frame)+edge, edge, self.width-127, height);
    _emoji.frame = CGRectMake(CGRectGetMaxX(_textFied.frame)+edge, edge, height, height);
    _send.frame = CGRectMake(CGRectGetMaxX(_emoji.frame)+edge, edge, height, height);
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 2.0;
    [bezier moveToPoint:CGPointMake(0, rect.size.height)];
    [bezier addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [JMColor(230, 230, 230) set];
    [bezier stroke];
}

// 移除通知中心
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)initWithKeyBoard:(UIView *)sView
{
    JMInputHeader *key = [[self alloc] initWithFrame:CGRectMake(0, sView.height-44, sView.width, 44)];
    key.backgroundColor = JMColor(245, 245, 245);
    [sView addSubview:key];
    return key;
}

#pragma mark -- block回调
- (void)getBase64Str:(NSString *)baseStr
{
    if (self.contents) {self.contents(baseStr);}
    NSLog(@"baseStr = %@", baseStr);
}

- (void)refreshTabHeight:(keyBoardHeight)height
{
    self.tabHeight = height;
}

- (void)refreshContents:(inputString)input
{
    self.contents = input;
}

- (void)inputVoiceRecording:(inputVoiceRecoing)recording
{
    self.recording = recording;
}

- (void)inputVoiceRecordingEnd:(inputVoiceRecoing)recordingEnd
{
    self.recordingEnd = recordingEnd;
}

- (void)inputVoiceCancle:(inputVoiceCancle)cancle
{
    self.cancle = cancle;
}

- (JMCustomKeyBoardView *)keyView
{
    if (!_keyView) {
        
        JMCustomKeyBoardView *keyView = [[JMCustomKeyBoardView alloc] initWithFrame:CGRectMake(0, 0, self.width, 258)];
        keyView.backgroundColor = JMColor(245, 245, 245);
        keyView.delegate = self;
        self.keyView = keyView;
    }
    
    return _keyView;
}

- (JMMoreInputView *)moreImput
{
    if (!_moreImput) {
        
        JMMoreInputView *moreImput = [[JMMoreInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 258)];
        moreImput.backgroundColor = JMColor(245, 245, 245);
        [moreImput callBack:^(ActionType actionType) {if (self.secKeyBoard) {self.secKeyBoard(actionType);}}];
        self.moreImput = moreImput;
    }
    
    return _moreImput;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

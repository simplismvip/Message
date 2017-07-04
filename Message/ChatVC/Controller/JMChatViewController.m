//
//  JMChatViewController.m
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMChatViewController.h"
#import "JMChatTableView.h"
#import "JMChatModel.h"
#import "JMInputHeader.h"
#import "UIView+Extension.h"
#import "JMImageView.h"
#import "JMBaseWebViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#define JMSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface JMChatViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) JMChatTableView *msgTable;
@property (nonatomic, weak) JMInputHeader *textView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMChatViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {self.dataSource = [NSMutableArray array];}
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatChatTableView];
    [self creatKeyBoard];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStyleDone) target:self action:@selector(addCell:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)addCell:(UIBarButtonItem *)sender
{
    NSArray *msgArr = [self getData];
    NSDictionary *dic = msgArr[arc4random()%10];
    JMChatModel *model = [[JMChatModel alloc] init];
    model.msgBody = dic[@"msgBody"];
    model.msgFrom = (MessageFrom)[dic[@"msgFrom"] integerValue];
    model.msgType = (MessageType)[dic[@"msgType"] integerValue];
    model.from = dic[@"from"];
    model.to = dic[@"to"];
    model.timestamp = dic[@"timestamp"];
    [self.msgTable refrashByModel:model];
}

#pragma mark -- 创建tableView
- (void)creatChatTableView
{
    for (NSDictionary *dic in [self getData]) {
        
        JMChatModel *model = [[JMChatModel alloc] init];
        model.msgBody = dic[@"msgBody"];
        model.msgFrom = (MessageFrom)[dic[@"msgFrom"] integerValue];
        model.msgType = (MessageType)[dic[@"msgType"] integerValue];
        model.from = dic[@"from"];
        model.to = dic[@"to"];
        model.timestamp = dic[@"timestamp"];
        [self.dataSource addObject:model];
    }
    
    JMChatTableView *msgTable = [JMChatTableView initMessageTableView:self];
    msgTable.modelArray = self.dataSource;
    self.msgTable = msgTable;
    
    [msgTable selectRowAtindexPath:^(JMChatModel *model ,CGRect rect) {
        
        if (model.msgType == MessageText) {
            
            NSLog(@"文字消息 == %@", model.msgBody);
            
        }else if (model.msgType == MessageVideo){
            
            NSLog(@"播放视频 == %@", model.msgBody);
            MPMoviePlayerController *moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:model.msgBody]];
            [moviePlayer.view setFrame:CGRectMake(40, 197, 240, 160)];
            [moviePlayer prepareToPlay];
            [moviePlayer setShouldAutoplay:NO]; // And other options you can look through the documentation.
            [self.view addSubview:moviePlayer.view];
            
        }else if (model.msgType == MessageAudio){
            
            NSLog(@"音频消息 == %@", model.msgBody);
            
        }else if (model.msgType == MessageImage){
            
            JMImageView *image = [[JMImageView alloc] initWithFrame:self.view.bounds];
            image.imageRect = rect;
            image.image = [UIImage imageNamed:model.msgBody];
            UIWindow *windows = [UIApplication sharedApplication].windows.firstObject;
            [windows addSubview:image];
            
        }else if (model.msgType == MessageUrl){
            
            JMBaseWebViewController *drawVC = [[JMBaseWebViewController alloc] init];
            drawVC.urlString = model.msgBody;
            [self.navigationController pushViewController:drawVC animated:YES];
        }
    }];
}

- (void)creatKeyBoard
{
    JMInputHeader *textView = [JMInputHeader initWithKeyBoard:self.view];
    self.textView = textView;
    
    JMSelf(js); // 改变键盘高度
    [textView refreshTabHeight:^(CGFloat height, BOOL isUp) {
        
        [js.msgTable refreshFrame:height isUp:isUp];
    }];
    
    // 1> 发送文字消息
    [textView refreshContents:^(NSString *input) {
        
        JMChatModel *model = [[JMChatModel alloc] init];
        model.msgBody = input;
        model.msgFrom = MessageFromMe;
        model.msgType = MessageText;
        model.from = @"张三";
        model.to = @"李四";
        model.timestamp = @"2017-07-09";
        [self.msgTable refrashByModel:model];
    }];
    
    // 1> 正在录音
    [textView inputVoiceRecording:^{
        
        NSString *fileName = [NSString stringWithFormat:@"%@.amr", [self timerString]];
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    }];
    
    // 2> 发送录音
    [textView inputVoiceRecordingEnd:^{
        
        
    }];
    
    // 3> 取消录音
    [textView inputVoiceCancle:^{
        
        NSLog(@"停止录音");
    }];
    
    // 第二键盘回调
    [textView secBoardCallBack:^(NSInteger type) {
        
        if (type == 0) {
            
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {[self initImagePicker:0];}
            
        }else if (type == 1){
            
            if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {[self initImagePicker:1];}
        }
    }];
}

#pragma mark -- 初始化图片选择器
- (void)initImagePicker:(NSInteger)number
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.view.frame = CGRectMake(0, 0, self.view.width, self.view.height - 64);
    picker.delegate = self;
    picker.sourceType = number;
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg", cache, [self timerString]];
    [data writeToFile:filePath atomically:YES];
    
    JMChatModel *model = [[JMChatModel alloc] init];
    model.msgBody = filePath;
    model.msgFrom = MessageFromMe;
    model.msgType = MessageImage;
    model.from = @"张三";
    model.to = @"李四";
    model.timestamp = @"2017-07-09";
    [self.msgTable refrashByModel:model];
}

- (NSString *)timerString
{
    NSTimeInterval tmp =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
    return [[NSString stringWithFormat:@"%f", tmp] componentsSeparatedByString:@"."].firstObject;
}

//添加代码，处理选中图像又取消的情况
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getData {
    
    NSString *audio1 = [[NSBundle mainBundle] pathForResource:@"call_incoming" ofType:@"wav"];
    NSString *audio2 = [[NSBundle mainBundle] pathForResource:@"call_ringback" ofType:@"wav"];
    NSString *video = [[NSBundle mainBundle] pathForResource:@"IMG_1877" ofType:@"MP4"];
    
    NSArray *msgArr = @[@{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.", @"msgFrom":@"0", @"msgType":@"0"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":video, @"msgFrom":@"1", @"msgType":@"1"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":audio1, @"msgFrom":@"0", @"msgType":@"2"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"photo", @"msgFrom":@"1", @"msgType":@"3"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"http://image.baidu.com", @"msgFrom":@"0", @"msgType":@"4"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.", @"msgFrom":@"1", @"msgType":@"0"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":video, @"msgFrom":@"0", @"msgType":@"1"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":audio2, @"msgFrom":@"1", @"msgType":@"2"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"photo", @"msgFrom":@"0", @"msgType":@"3"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"https://image.baidu.com/search/index?tn=baiduimage", @"msgFrom":@"1", @"msgType":@"4"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.", @"msgFrom":@"0", @"msgType":@"0"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":video, @"msgFrom":@"1", @"msgType":@"1"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":audio1, @"msgFrom":@"0", @"msgType":@"2"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"photo", @"msgFrom":@"1", @"msgType":@"3"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"http://image.baidu.com", @"msgFrom":@"0", @"msgType":@"4"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.", @"msgFrom":@"1", @"msgType":@"0"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":video, @"msgFrom":@"0", @"msgType":@"1"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":audio2, @"msgFrom":@"1", @"msgType":@"2"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"photo", @"msgFrom":@"0", @"msgType":@"3"},
                        
                        @{@"from":@"tony", @"to":@"jim", @"timestamp":@"2017-7-07", @"msgBody":@"https://image.baidu.com/search/index?tn=baiduimage", @"msgFrom":@"1", @"msgType":@"4"}
                        
                        ];
    return msgArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JMChatTableView.m
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "JMChatTableView.h"
#import "JMChatCell.h"
#import "JMChatModel.h"
#import "JMChatViewModel.h"
#import "UIView+Extension.h"

#define JMColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]

@interface JMChatTableView()<UITableViewDataSource, UITableViewDelegate, JMChatCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, copy) selectCell selectBlock;

@end
@implementation JMChatTableView

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        [self registerClass:[JMChatCell class] forCellReuseIdentifier:@"MessageCell"];
        self.allowsSelection = NO;
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = JMColor(231, 231, 231);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){self.cellLayoutMarginsFollowReadableWidth =NO;}
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MessageCell";
    JMChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {cell = [[JMChatCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.messageFrame = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.tableView = tableView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMChatViewModel *viewModel = self.dataArray[indexPath.row];
    return viewModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.transform = CGAffineTransformMakeTranslation(0, 30);
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -- IMageCell
- (void)getsIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame
{
    JMChatViewModel *viewModel = self.dataArray[indexPath.row];
    self.selectBlock(viewModel.message, frame);
}

- (void)selectRowAtindexPath:(selectCell)model
{
    self.selectBlock = model;
}

+ (instancetype)initMessageTableView:(UIViewController *)viewC
{
    JMChatTableView *base = [[JMChatTableView alloc] initWithFrame:CGRectMake(0, 0, viewC.view.bounds.size.width, viewC.view.bounds.size.height-44)];
    base.superVC = viewC;
    [viewC.view addSubview:base];
    return base;
}

// 给模型赋值
- (void)setModelArray:(NSMutableArray<JMChatModel *> *)modelArray
{
    _modelArray = modelArray;
    for (JMChatModel *model in modelArray) {
        
        JMChatViewModel *viewModel = [[JMChatViewModel alloc] init];
        viewModel.message = model;
        [self.dataArray addObject:viewModel];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.superVC.view endEditing:YES];
}

- (void)keyBoardRun
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationBottom)];
    [self scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
}

// 刷新界面
- (void)refrashByModel:(JMChatModel *)model
{
    JMChatViewModel *viewModel = [[JMChatViewModel alloc] init];
    viewModel.message = model;
    [self.dataArray addObject:viewModel];
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self insertRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationBottom)];
    [self scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
}

- (void)refreshFrame:(CGFloat)height isUp:(BOOL)isUp
{
    self.frame = CGRectMake(0, 0, self.width, height);
    if (isUp) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [self scrollToRowAtIndexPath:path atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}
@end

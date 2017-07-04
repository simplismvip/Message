//
//  JMChatTableView.h
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMChatModel;
typedef void(^selectCell)(JMChatModel *model ,CGRect rect);
@interface JMChatTableView : UITableView
@property (nonatomic, strong) NSMutableArray<JMChatModel *> *modelArray;

+ (instancetype)initMessageTableView:(UIViewController *)viewC;
- (void)refrashByModel:(JMChatModel *)model;
- (void)refreshFrame:(CGFloat)height isUp:(BOOL)isUp;
- (void)selectRowAtindexPath:(selectCell)model;
@end

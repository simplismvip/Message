//
//  JMChatCell.h
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMChatViewModel;
@protocol JMChatCellDelegate <NSObject>
- (void)getsIndexPath:(NSIndexPath *)indexPath frame:(CGRect)frame;
@end

@interface JMChatCell : UITableViewCell
@property (nonatomic, strong) JMChatViewModel *messageFrame;
@property (nonatomic, weak) id <JMChatCellDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;
@end

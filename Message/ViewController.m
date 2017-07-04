//
//  ViewController.m
//  Message
//
//  Created by JM Zhao on 2017/6/28.
//  Copyright © 2017年 奕甲智能 Oneplus Smartware. All rights reserved.
//

#import "ViewController.h"
#import "JMChatViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnAction = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btnAction.frame = CGRectMake(0, 0, 80, 80);
    btnAction.center = self.view.center;
    btnAction.titleLabel.font = [UIFont systemFontOfSize:10];
    btnAction.titleLabel.textColor = [UIColor redColor];
    btnAction.layer.cornerRadius = 10;
    btnAction.layer.borderWidth = 1;
    btnAction.layer.borderColor = [UIColor greenColor].CGColor;
    btnAction.backgroundColor = [UIColor cyanColor];
    [btnAction setTitle:@"测试" forState:(UIControlStateNormal)];
    [btnAction setImage:[UIImage imageNamed:@"navbar_video_black"] forState:(UIControlStateNormal)];
    btnAction.titleEdgeInsets = UIEdgeInsetsMake(50, -70, 0, -5);
//    btnAction.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 30, -5);
    btnAction.imageEdgeInsets = UIEdgeInsetsMake(0, 0 + (btnAction.center.x - btnAction.imageView.center.x), 30 ,0 - (btnAction.center.x - btnAction.imageView.center.x));
    [self.view addSubview:btnAction];
}

- (IBAction)chat:(id)sender {
    
    JMChatViewController *chat = [[JMChatViewController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

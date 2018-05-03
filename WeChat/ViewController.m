//
//  ViewController.m
//  WeChat
//
//  Created by Xiaogang on 2018/5/1.
//  Copyright © 2018年 Xiaogang. All rights reserved.
//

#import "ViewController.h"
#import "XG_SendWechatViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [centerButton setTitle:@"朋友圈" forState:UIControlStateNormal];
    [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    centerButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:centerButton];
    [centerButton makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.safeAreaLayoutGuideTop).offset(100);
        }else{
            make.top.equalTo(100);
        }
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(100);
    }];
}
-(void)centerButtonClick{
    XG_SendWechatViewController *sendVC = [[XG_SendWechatViewController alloc] init];
    UINavigationController *sendNC = [[UINavigationController alloc] initWithRootViewController:sendVC];
    [self presentViewController:sendNC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

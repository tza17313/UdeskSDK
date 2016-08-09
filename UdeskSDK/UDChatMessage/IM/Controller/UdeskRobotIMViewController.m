//
//  UdeskRobotIMViewController.m
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UdeskRobotIMViewController.h"
#import "UdeskChatViewController.h"
#import "UdeskFoundationMacro.h"
#import "UdeskUtils.h"
#import "UdeskManager.h"
#import "UdeskAlertController.h"
#import "UdeskAgentNavigationMenu.h"

@interface UdeskRobotIMViewController ()

@end

@implementation UdeskRobotIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [UdeskManager createServerCustomerCompletion:^(BOOL success, NSError *error) {
        
        if (success) {
            
            [UdeskManager getRobotURL:^(NSURL *robotUrl) {
                
                if (robotUrl) {
                    
                    CGRect webViewRect = self.navigationController.navigationBarHidden?CGRectMake(0, 64, UD_SCREEN_WIDTH, UD_SCREEN_HEIGHT-64):self.view.bounds;
                    UIWebView *intelligenceWeb = [[UIWebView alloc] initWithFrame:webViewRect];
                    intelligenceWeb.backgroundColor=[UIColor whiteColor];
                    
                    NSURL *ticketURL = robotUrl;
                    
                    [intelligenceWeb loadRequest:[NSURLRequest requestWithURL:ticketURL]];
                    
                    [self.view addSubview:intelligenceWeb];
                    
                    if ([UdeskManager supportTransfer]) {
                        
                        [self.udNavView showRightButtonWithName:getUDLocalizedString(@"转人工") withTextColor:UdeskUIConfig.robotTransferButtonColor];

                    }
                    
                } else {
                    
                    UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
                    
                    [self.navigationController pushViewController:chat animated:NO];
                }
                
            }];
            
        }
        
    }];
    
    //设置返回按钮文字（在A控制器写代码）
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = barButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    //设置导航栏
    [self.udNavView changeTitle:getUDLocalizedString(@"智能机器人对话") withChangeTitleColor:UdeskUIConfig.robotTitleColor];
    [self.udNavView setBackgroundColor:UdeskUIConfig.robotNavigationColor];
    [self.udNavView setBackButtonColor:UdeskUIConfig.robotBackButtonColor];
}

- (void)backButtonAction {

    [super backButtonAction];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction {

    [super rightButtonAction];
    
    [self transferButtonAction];
}

- (void)transferButtonAction {

    [UdeskManager getAgentNavigationMenu:^(id responseObject, NSError *error) {
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 1000) {
         
            NSArray *result = [responseObject objectForKey:@"result"];
            if (result.count) {
                
                UdeskAgentNavigationMenu *agentMenu = [[UdeskAgentNavigationMenu alloc] initWithMenuArray:result];
                [self.navigationController pushViewController:agentMenu animated:YES];
            }
            else {
            
                UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
                [self.navigationController pushViewController:chat animated:YES];
            }
        }
        
    }];

}

- (void)dealloc
{
    NSLog(@"%@销毁了",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

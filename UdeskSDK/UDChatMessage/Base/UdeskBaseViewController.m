//
//  UdeskBaseViewController.m
//  UdeskSDK
//
//  Created by xuchen on 16/6/15.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import "UdeskBaseViewController.h"
#import "UIImage+UdeskSDK.h"
#import "UdeskUtils.h"
#import "UdeskFoundationMacro.h"
#import "UIViewController+UdeskBackButtonHandler.h"

@interface UdeskBaseViewController()

@end

@implementation UdeskBaseViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    @udWeakify(self)
    self.navigationController.gestureBack = ^{
    
        @udStrongify(self);
        [self.udNavView removeFromSuperview];
        self.udNavView = nil;
    };
    
}

- (void)backButtonAction {

    [self.udNavView removeFromSuperview];
}

- (void)rightButtonAction {

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    self.navigationItem.hidesBackButton = YES;
    
    if (!_udNavView) {
    
        _udNavView = [[UdeskNavigationView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 64)];
        
        [self.navigationController.view addSubview:_udNavView];
        [self.navigationController.view bringSubviewToFront:_udNavView];
        
        @udWeakify(self);
        _udNavView.navigationBackBlcok = ^{
            
            @udStrongify(self);
            [self backButtonAction];
        };
        
        _udNavView.navigationRightBlcok = ^{
            
            @udStrongify(self);
            [self rightButtonAction];
        };
    }    
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.navigationItem.hidesBackButton = NO;
}

@end

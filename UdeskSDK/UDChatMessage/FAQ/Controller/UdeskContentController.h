//
//  UdeskContentController.h
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UdeskBaseViewController.h"

@interface UdeskContentController : UdeskBaseViewController<UIWebViewDelegate>

/**
 *  文章ID
 */
@property (nonatomic, strong  ) NSString   *Article_Id;
/**
 *  文章标题
 */
@property (nonatomic, strong  ) NSString   *ArticlesTitle;

@end
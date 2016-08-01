# UdeskSDK-iOS
Udesk为了让开发者更好的集成移动SDK,与企业业务结合更加紧密，我们开源了SDK的UI界面。用户可以根据自身业务以及APP不同风格重写页面。当然开发者也可以直接用我们提供的默认的界面。


## SDK工作流程


Udesk-SDK的工作流程如下图所示。

![udesk](http://7xr0de.com2.z0.glb.qiniucdn.com/ios-new-1.png)


## 导入SDK依赖的框架
```
libz.tbd
libxml2.tbd
libresolv.tbd
libsqlite3.tbd
```

把下载的文件夹中的UdeskSDK文件夹拖到你的工程里
```
点击的你工程targets->Build Settings 
搜索Other Linker Flags 加入 -lxml2 -ObjC，
搜索header search paths 加入/usr/include/libxml2。
```
## CocoaPods 导入
在 Podfile 中加入：

```
pod 'UdeskSDK'
```
在 控制器 中引入：
```
#import "Udesk.h"
```

**文件介绍**

| Demo中的文件      | 说明                |
| ------------- | :---------------- |
| UDChatMessage | Udesk提供的开源聊天界面    |
| SDK           | Udesk SDK的静态库和头文件 |
| Resource      | Udesk资源文件         |

## 快速集成SDK

#### 1）初始化Udesk，获取密钥和公司域名。
![udesk](http://7xr0de.com2.z0.glb.qiniucdn.com/ios3.png)
```
//初始化Udesk
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
// Override point for customization after application launch.
    [UdeskManager initWithAppkey:@"公司密钥" domianName:@"公司域名"];
    return YES;
}
```
#### 2）初始化用户信息
> 注意：若要在SDK中使用 用户自定义字段 需先在网页端设置添加用户自定义字字段。 用户字段包含了一名联系人的所用数据。目前Udesk完全支持自定义用户字段，您可以选择输入型字段和选择型字段。如果是选择型字段，需要提供多个自定义的选项供您的客户进行选择。如果是输入型字段，用户会看到一个文本输入框，在其中输入数据。

用户系统字段是Udesk已定义好的字段，开发者可以传入这些用户信息，供客服查看。
```
NSDictionary *parameters = @{
                                @"user": @{
                                            @"nick_name": @"小明",
                                            @"cellphone":@"18888888888",
                                            @"weixin_id":@"xiaoming888",
                                            @"weibo_name":@"xmwb888",
                                            @"qq":@"8888888",
                                            @"email":@"xiaoming@qq.com",
                                            @"description":@"用户描述",
                                            @"sdk_token":@"xxxxxxxxxxx"
                                        }
                            }

```

**字段说明：**

| key         | 是否必选 | 说明     |
| ----------- | :--- | ------ |
| sdk_token   | 必选   | 用户唯一标识 |
| cellphone   | 可选   | 用户手机号  |
| weixin_id   | 可选   | 微信号    |
| weibo_name  | 可选   | 微博ID   |
| qq          | 可选   | QQ号    |
| email       | 可选   | 邮箱账号   |
| description | 可选   | 用户描述   |


**用户自定义字段：**
用户自定义字段需要登录Udesk后台，进入“管理中心-用户字段”添加用户自定义字段。
![udesk](http://7xr0de.com2.z0.glb.qiniucdn.com/ios4.png)

**调用用户自定义字段函数：**
```
//获取用户自定义字段
[UdeskManager getCustomerFields:^(id responseObject, NSError *error) {

    //NSLog(@"用户自定义字段：%@",responseObject);
}];
```

返回信息：
```
fieldsDict:{
    message = success;
    status = 0;
    "user_fields" =     (
        {
            comment = “测试测试”;      
            "content_type" = droplist; 
            "field_label" = "测试";  
            "field_name" = “SelectField_109";   ——————用户自定义字段key
    options =             (    
        {
            0 = "测试用户自定义字段";
        }
    );
    permission = 0;
    requirment = 1;
    };
}
```
使用:添加key值"customer_field" 类型为字典，根据返回的信息field_name的value 作为key，value根据需求定义。把这个键值对添加到customer_field。最后把customer_field添加到用户信息参数的user字典里
  示例:
```
NSDictionary *parameters = @{
                                @"user": @{
                                            @"sdk_token": sdk_token,
                                            @"nick_name":nick_name,
                                            @"email":email,
                                            @"cellphone":cellphone,
                                            @"weixin_id":@"xiaoming888",
                                            @"weibo_name":@"xmwb888",
                                            @"qq":@"8888888",
                                            @"description":@"用户描述",
                                            @"customer_field":@{
                                                                    @"TextField_390":@"测试测试",
                                                                    @"SelectField_455":@[@"1"]
                                                            }

                                    }
                        };
```
**创建用户（此接口为必调用，否则无法使用SDK）**
```
[UdeskManager createCustomerWithCustomerInfo:parameters];

```
**更新用户信息（根据需求自定义，不调用不影响主流程）**
```
注意：
参数跟创建用户信息的结构体大致一样(不需要传sdk_token)  
用户自定义字段"customer_field"改为"custom_fields"其他不变
请不要使用已经存在的邮箱或者手机号进行更新，否则会更新失败！

NSDictionary *updateParameters = @{
                                    @"user" : @{
                                                @"nick_name":@"测试更新10",
                                                @"cellphone":@"323312110198754326231123",
                                                @"weixin_id":@"xiaoming91078543628818",
                                                @"weibo_name":@"xmwb81497810568328",
                                                @"qq":@"888818682843578910",
                                                @"description":@"用户10描述",
                                                @"email":@"889092340491087556233290111@163.com",
                                                @"custom_fields":@{
                                                                    @"TextField_390":@"测试测试",
                                                                    @"SelectField_455":@[@"1"]
                                                                }
                                            }
};

[UdeskManager updateUserInformation:updateParameters];
```
**添加咨询对象（根据需求自定义，不调用不影响主流程）**
```
在你push事件的时候调用UdeskChatViewController类的 showProductViewWithDictionary方法

UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
//咨询对象
NSDictionary *product =  @{
                            @"product_imageUrl":@"http://img.club.pchome.net/kdsarticle/2013/11small/21/fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
                            @"product_title":@"测试咨询对象标题测试咨询对象标题！",
                            @"product_detail":@"¥88888.0",
                            @"product_url":@"http://www.baidu.com"

                        };

[chat showProductViewWithDictionary:product];

[self.navigationController pushViewController:chat animated:YES];
```

SDK 咨询对象展示:

![udesk](http://7xr0de.com1.z0.glb.clouddn.com/%E5%92%A8%E8%AF%A2%E5%AF%B9%E8%B1%A1.png)

##### **指定分配客服或客服组**（只需要选择一个）


    UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];
    //指定客服组
    chat.group_id = @"1";
    //指定客服
    chat.agent_id = @"2";
    [self.navigationController pushViewController:chat animated:YES];
##### **获取客服和客服组ID**

使用管理员登陆Udesk系统

![udesk](http://7xr0de.com1.z0.glb.clouddn.com/%E8%8E%B7%E5%8F%96%E5%AE%A2%E6%9C%8Did.jpg)

#### 3）推出聊天页面

```
UdeskChatViewController *chat = [[UdeskChatViewController alloc] init];

[self.navigationController pushViewController:chat animated:YES];
```

#### 4）推出帮助中心
```
UdeskFaqController *faq = [[UdeskFaqController alloc] init];

[self.navigationController pushViewController:faq animated:YES];
```

#### 5）推出机器人页面
```
UdeskRobotIMViewController *robot = [[UdeskRobotIMViewController alloc] init];

[self.navigationController pushViewController:robot animated:YES];
```
至此，你已经为你的 APP 添加Udesk提供的客服服务。而Udesk SDK 还提供其他强大的功能，可以帮助提高服务效率，提升用户使用体验。接下来为你详细介绍如何使用其他功能

### 监听收到未读消息的广播

开发者可在合适的地方，监听收到消息的广播，用于提醒顾客有新消息。广播的名字为 `UD_RECEIVED_NEW_MESSAGES_NOTIFICATION`，定义在 UdeskManager.h 中。



## 其他接口说明

**注意：以下接口在Udesk开源UI里均有调用，如果你使用Udesk的开源UI则不需要调用以下任何接口**

获取用户的登录信息接口（请在用户创建成功后调用，参考开源UI）

    [UdeskManager getCustomerLoginInfo:^(BOOL success, NSError *error) {

    }];
获取后台分配的客服信息 （请在用户创建成功后调用，参考开源UI）

    [UdeskManager requestRandomAgent:^(id responseObject, NSError *error) {
      //返回客服信息
    }];
指定分配客服或客服组 （请在用户创建成功后调用，参考开源UI）

[获取客服和客服组ID](#获取客服和客服组ID)

    [UdeskManager assignAgentOrGroup:@"agentId" groupID:@"groupId" completion:^(id responseObject, 		NSError *error) {

    }];
接收消息代理

```
需要在当前Class里添加<UDManagerDelegate>
[UdeskManager receiveUdeskDelegate:self]; 
```

登录Udesk

    [UdeskManager loginUdesk:^(BOOL status) {
         NSLog(@"登录Udesk成功");
    }];
退出Udesk (切换用户时，需要调用此接口)

    [UdeskManager logoutUdesk];
设置客户离线 (在用户点击home键后调用此方法，如不调用此方法，可能会造成客服消息发送不出去)

```
[UdeskManager setCustomerOffline];
```

设置客户在线 (用户点击app进入页面时调用此方法)

```
[UdeskManager setCustomerOnline];
```

发送消息

    //message消息类型为 UdeskMessage
    [UdeskManager sendMessage:message completion:^(UdeskMessage *message,BOOL sendStatus) {    
        
    }];
预输入（将用户正在输入的内容，提供给客服查看。该接口没有调用限制，但每1秒内只会向服务器发送一次数据）

注意：需要在初始化成功后，且客服是在线状态时调用才有效

```
[UdeskManager sendClientInputtingWithContent:text];
```

获取机器人URL

    [UdeskManager getRobotURL:^(NSURL *robotUrl) {

    }];

获取客户本地聊天数据

```
[UdeskManager queryTabelWithSqlString:sql params:nil];
```

获取未读消息数量

```
[UdeskManager getLocalUnreadeMessagesCount];
```




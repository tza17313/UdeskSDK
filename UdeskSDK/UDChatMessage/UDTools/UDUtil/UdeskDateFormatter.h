//
//  UdeskDateFormatter.h
//  UdeskSDK
//
//  Created by xuchen on 16/6/3.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdeskDateFormatter : NSObject

@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

+ (UdeskDateFormatter *)sharedFormatter;

- (NSString *)ud_styleDateForDate:(NSDate *)date;

@end

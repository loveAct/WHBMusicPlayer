//
//  NSString+JSON.m
//  iMusicPlayer
//
//  Created by zhuwei on 16/4/25.
//  Copyright © 2016年 zhuwei. All rights reserved.
//

#import "NSString+JSON.h"
#import "NSData+JSON.h"

@implementation NSString (JSON)

/**
 *  字符串专程OC数据模型
 *
 *  @return 返回OC数据模型
 */
- (id)jsonValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if(data != nil) {
        return [data jsonValue];
    }
    return nil;
}

@end

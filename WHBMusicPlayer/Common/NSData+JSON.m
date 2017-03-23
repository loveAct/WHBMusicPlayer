//
//  NSData+JSON.m
//  iMusicPlayer
//
//  Created by zhuwei on 16/4/25.
//  Copyright © 2016年 zhuwei. All rights reserved.
//

#import "NSData+JSON.h"

@implementation NSData (JSON)

/**
 *  字符串专程OC数据模型
 *
 *  @return 返回OC数据模型
 */
- (id)jsonValue {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableLeaves error:nil];
}

@end

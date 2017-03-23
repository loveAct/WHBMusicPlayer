//
//  NSString+JSON.h
//  iMusicPlayer
//
//  Created by zhuwei on 16/4/25.
//  Copyright © 2016年 zhuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

/**
 *  字符串专程OC数据模型
 *
 *  @return 返回OC数据模型
 */
- (id)jsonValue;

@end

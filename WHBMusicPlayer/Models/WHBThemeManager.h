//
//  WHBThemeManager.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZWSingleton.h"

#define _ThemeMgr ([WHBThemeManager sharedInstance])


// 资源内容快捷宏
#define _I(__NAME__)    ([_ThemeMgr imageNamed:__NAME__])
#define _S(__KEY__)     ([_ThemeMgr localizedStringForKey:__KEY__])

@interface WHBThemeManager : NSObject
INTERFACE_SINGLETON(WHBThemeManager)

// 获取图片资源
- (UIImage *)imageNamed:(NSString *)name;

// 本地化字符串
- (NSString *)localizedStringForKey:(NSString *)key;

@end

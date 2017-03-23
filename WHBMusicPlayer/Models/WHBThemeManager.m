//
//  WHBThemeManager.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBThemeManager.h"

@implementation WHBThemeManager
IMPLEMENTATION_SINGLETON(WHBThemeManager)

- (UIImage *)imageNamed:(NSString *)name{
    return [UIImage imageNamed:name];
}

- (NSString *)localizedStringForKey:(NSString *)key{
    return NSLocalizedString(key, @"");
}
@end

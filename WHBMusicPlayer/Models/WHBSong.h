//
//  WHBSong.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHBLrc.h"
@interface WHBSong : NSObject

// 歌曲名称
@property (copy, nonatomic) NSString    *name;

// 歌手
@property (copy, nonatomic) NSString    *singer;

// 封面图片相对路径
@property (copy, nonatomic) NSString    *coverPath;

// 歌曲相对路径
@property (copy, nonatomic) NSString    *mp3Path;

// 歌词相对路径
@property (copy, nonatomic) NSString    *lrcPath;

@property(nonatomic,copy)WHBLrc *lrc;

@end

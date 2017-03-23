//
//  WHBPlaylist.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBPlaylist.h"

@implementation WHBPlaylist{
    NSMutableArray<WHBSong *> *_songs;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _songs = [NSMutableArray array];
    }
    return self;
}

// 获取播放列表的所有歌曲
- (NSArray<WHBSong *>*)allSongs{
    return _songs;
}

// 删除歌曲
- (void)removeSongAtIndex:(NSInteger)index{
    // 1. 判断参数有效性
    if (_songs.count == 0 || index >= _songs.count) {
        return ;
    }
    
    // 2. 具体业务逻辑

    [_songs removeObjectAtIndex:index];
}

// 添加歌曲
- (void)addSong:(WHBSong *)song{
    if (_songs == nil) {
        return ;
    }
    [_songs addObject:song];
}
@end

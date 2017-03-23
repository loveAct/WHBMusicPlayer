//
//  WHBPlaylist.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHBSong;
@interface WHBPlaylist : NSObject

#pragma mark - 属性 -
// 播放列表的名称
@property (copy, nonatomic)   NSString    *name;

#pragma mark - 方法 -

// 获取播放列表的所有歌曲
- (NSArray<WHBSong *>*)allSongs;

// 删除歌曲
- (void)removeSongAtIndex:(NSInteger)index;

// 添加歌曲
- (void)addSong:(WHBSong *)song;

@end

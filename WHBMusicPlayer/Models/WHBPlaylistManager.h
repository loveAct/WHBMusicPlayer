//
//  WHBPlaylistManager.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWSingleton.h"
#define _PlaylistMgr ([WHBPlaylistManager sharedInstance])

@class WHBPlaylist;
@interface WHBPlaylistManager : NSObject
INTERFACE_SINGLETON(WHBPlaylistManager)

// 获取所有的播放列表
- (NSArray<WHBPlaylist *>*)allPlaylists;

// 添加播放列表
- (void)addPlaylist:(WHBPlaylist *)playlist;

// 删除播放列表通过索引
- (void)removePlaylistAtIndex:(NSInteger)index;



@end

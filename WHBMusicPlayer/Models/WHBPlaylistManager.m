//
//  WHBPlaylistManager.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBPlaylistManager.h"
#import "NSString+Path.h"
#import "NSString+JSON.h"
#import "WHBSong.h"
#import "WHBPlaylist.h"
@implementation WHBPlaylistManager{
    NSMutableArray <WHBPlaylist *> *_playlists;
}
IMPLEMENTATION_SINGLETON(WHBPlaylistManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _playlists = [NSMutableArray array];
        
        // 测试代码,添加本地的播放列表对象
        
        // 1. 解析本地测试配置文件,将配置文件转化成nsstring需要utf8编码
        NSString *jsonString = [NSString stringWithContentsOfFile:[NSString bundlePathWithRelativePath:@"/music/playlists.json"] encoding:NSUTF8StringEncoding error:nil];
        // 2. 解析成苹果的数据结构
        NSArray *playlistsDictionary = [jsonString jsonValue];
        
        NSString *bundlePath = [NSString bundlePath];
        // 3. 把苹果数据结构 -> 模型数据结构 (简单的方案:使用第三方数据转模型)
        for (NSDictionary *playlistDictionary in playlistsDictionary) {
            WHBPlaylist *playlist = [WHBPlaylist new];
            NSArray *songsArray = playlistDictionary[@"songs"];
            
            for (NSDictionary *songDictionary in songsArray) {
                WHBSong *song = [WHBSong new];
                song.name = songDictionary[@"name"];
                song.singer = songDictionary[@"singer"];
                song.coverPath = [NSString stringWithFormat:@"%@/%@",bundlePath,songDictionary[@"cover"]];
                song.mp3Path =  [NSString stringWithFormat:@"%@/%@",bundlePath,songDictionary[@"mp3"]];
                song.lrcPath = [NSString stringWithFormat:@"%@/%@",bundlePath,songDictionary[@"lrc"]];
                [playlist addSong:song];

            }
            [_playlists addObject:playlist];
        }
        
    }
    return self;
}


// 获取所有的播放列表
- (NSArray<WHBPlaylist *>*)allPlaylists{
    return _playlists;
}

// 添加播放列表
- (void)addPlaylist:(WHBPlaylist *)playlist{
    if (_playlists == nil) {
        return;
    }
    [_playlists addObject:playlist];
}

// 删除播放列表通过索引
- (void)removePlaylistAtIndex:(NSInteger)index{
    if (_playlists.count == 0 || index >= _playlists.count) {
        return;
    }
    [_playlists removeObjectAtIndex:index];
}


@end

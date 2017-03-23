//
//  WHBMusicPlayer.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWSingleton.h"
// 当前播放歌曲的进度发生变化时回调
#define kCurrentTime                                    @"kCurrentTime"
#define kTotalTime                                      @"kTotalTime"
#define WHBMusicPlayerCurrentTimeDidChangedNotification  @"WHBMusicPlayerCurrentTimeDidChangedNotification"


// 歌曲播放状态发生变化通知
#define kMusicPlayerStatus                          @"kMusicPlayerStatus"
#define WHBMusicPlayerStatusDidChangedNotificatio   @"WHBMusicPlayerStatusDidChangedNotification"

// 正在播放的歌曲发生变化通知
#define kMusicPlayerPlayingSong                         @"kMusicPlayerPlayingSong"
#define WHBusicPlayerPlayingSongDidChangedNotification  @"WHBusicPlayerPlayingSongDidChangedNotification"


// 播放器状态枚举
typedef NS_ENUM(NSUInteger, WHBMusicPlayerStatus) {
    WHBMusicPlayerStatusPlaying, // 正在播放
    WHBMusicPlayerStatusPaused   // 当前暂停状态
};



#define _Player ([WHBMusicPlayer sharedInstance])

@class WHBSong;

@interface WHBMusicPlayer : NSObject
// 2. 根据上面的关键词实现头文件单例宏
INTERFACE_SINGLETON(WHBMusicPlayer)


#pragma mark - 属性 -
// 正在播放的歌曲
@property (strong, nonatomic) WHBSong    *playingSong;

// 当前循环播放的歌曲列表
@property (strong, nonatomic) NSArray<WHBSong *> *songs;

@property(nonatomic,assign) WHBMusicPlayerStatus status;

// 当前播放歌曲的总时间
@property (readonly, nonatomic) float       totalTime;
@property(nonatomic,assign) float currentTime;
#pragma mark - 控制 -
- (void)setCurrentTime:(float)currentTime ;
// 播放音乐
- (void)play;

// 暂停音乐
- (void)pause;

// 下一曲
- (void)next;

// 上一曲
- (void)prev;



@end

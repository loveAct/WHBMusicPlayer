//
//  WHBMusicPlayer.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "WHBSong.h"
#import <MediaPlayer/MediaPlayer.h>


@interface WHBMusicPlayer ()<AVAudioPlayerDelegate>
@property(nonatomic,assign)  NSInteger selectedIndex;
@end

@implementation WHBMusicPlayer{
    AVAudioPlayer *_player;
    NSTimer         *_observeTimer;

}
IMPLEMENTATION_SINGLETON(WHBMusicPlayer)
- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = nil;
        _observeTimer = nil;
        self.status = WHBMusicPlayerStatusPaused;
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
        
        // 自我实现歌曲状态发生改变的时候回调
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:WHBMusicPlayerStatusDidChangedNotificatio object:self];
        
        
        [[AVAudioSession sharedInstance]setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 属性 -
// 当前播放歌曲对象
- (WHBSong *)playingSong {
    if(self.songs == nil || _selectedIndex >= self.songs.count) {
        return nil;
    }
    return [self.songs objectAtIndex:_selectedIndex];
}

- (float)totalTime {
    if(_player) {
        return _player.duration;
    }
    return 0.0;
}
#pragma mark - 通知回调 -
// 歌曲状态发生改变会带哦
- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    WHBMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] integerValue];
    if (status == WHBMusicPlayerStatusPlaying) {
        [self startObserveCurrentTime];
    }else{
        [self stopObserveCurrentTime];
    }
    
}
// 开始监视当前时间发生改变回调
- (void)startObserveCurrentTime {
    [self stopObserveCurrentTime];
    _observeTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(doObserveCurrentTime) userInfo:nil repeats:YES];
}
// 结束监视当前时间发生改变回调
- (void)stopObserveCurrentTime {
    if(_observeTimer != nil) {
        if([_observeTimer isValid]) [_observeTimer invalidate];
        _observeTimer = nil;
    }
}
-(void)doObserveCurrentTime{
    [[NSNotificationCenter defaultCenter]postNotificationName:WHBMusicPlayerCurrentTimeDidChangedNotification
                                                    object:nil
                                                     userInfo:@{
                                kCurrentTime : @(_player.currentTime),
                                kTotalTime : @(_player.duration)
                                }];
    [self updateLockedScreenInfo];

}
-(void)updateLockedScreenInfo{
    // 重新通过歌词生成图片 -> 设置到 MPMediaItemPropertyArtwork
    
    
    // 如何更新系统的音频信息
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    center.nowPlayingInfo = @{
                              MPMediaItemPropertyAlbumTitle : self.playingSong.name,
//                              MPMediaItemPropertyPlaybackDuration : @(self.totalTime),
                              MPNowPlayingInfoPropertyElapsedPlaybackTime:@(self.currentTime),
                              MPMediaItemPropertyArtist:self.playingSong.singer,
                              
                              MPMediaItemPropertyPlaybackDuration:@(self.totalTime),
                              MPMediaItemPropertyArtwork:[[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeZero requestHandler:^UIImage * _Nonnull(CGSize size) {
                                  return [UIImage imageWithContentsOfFile:self.playingSong.coverPath];
                              }]
                              };
    
}

#pragma mark - 控制 -
// 设置当前播放时间
- (void)setCurrentTime:(float)currentTime {
    if(_player) {
        [_player setCurrentTime:currentTime];
    }
}

// 播放音乐
- (void)play{
    [self playAtIndex:self.selectedIndex];
}

// 暂停音乐
- (void)pause{
    [_player pause];
    self.status = WHBMusicPlayerStatusPaused;
}

// 下一曲
- (void)next{
    [self playAtIndex:self.selectedIndex + 1];
}

// 上一曲
- (void)prev{
    [self playAtIndex:self.selectedIndex - 1];
}
- (void)playAtIndex:(NSInteger)index {
    if (self.songs == nil || self.songs.count == 0) {
        return ;
    }
    if (_selectedIndex == index && _player) {
        [_player play];
        self.status = WHBMusicPlayerStatusPlaying;
        return;
    }
    
    if (index < 0) {
        index = self.songs.count - 1;
    }
    if (index > self.songs.count - 1) {
        index = 0 ;
    }
    
    WHBSong *song = self.songs[index];
    
    NSURL *url = [NSURL URLWithString:song.mp3Path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player play];
    self.status = WHBMusicPlayerStatusPlaying;
    self.selectedIndex = index;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",keyPath);
    if ([keyPath isEqualToString:@"status"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:WHBMusicPlayerStatusDidChangedNotificatio object:self userInfo:@{kMusicPlayerStatus : @(self.status)}];
    }else if([keyPath isEqualToString:@"selectedIndex"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WHBusicPlayerPlayingSongDidChangedNotification object:self userInfo:@{kMusicPlayerPlayingSong:self.playingSong}];
  
    
    }

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self next];
}

@end

//
//  WHBPlayerViewController.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBPlayerViewController.h"
#import "WHBSong.h"
#import "WHBLrcView.h"
@interface WHBPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet WHBLrcView *lrcView;

@end

@implementation WHBPlayerViewController
- (IBAction)beginOrPause:(UIButton *)sender {
//    [_Player play];
    if (_Player.status != WHBMusicPlayerStatusPlaying) {
        [_Player play];
    }else{
        [_Player pause];
    }
}
- (IBAction)prevBtn:(UIButton *)sender {
    [_Player prev];
}
- (IBAction)nextBtn:(UIButton *)sender {
    [_Player next];
    
}
- (IBAction)actionChangeProgress:(UISlider *)sender {
    [_Player setCurrentTime:sender.value * _Player.totalTime];
    
}


-(void)setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:WHBMusicPlayerStatusDidChangedNotificatio object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicPlayerPlayingSongDidChangedNotification:) name:WHBusicPlayerPlayingSongDidChangedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musicPlayerCurrentTimeDidChangedNotification:) name:WHBMusicPlayerCurrentTimeDidChangedNotification object:nil];

}

#pragma mark - 通知处理回调
- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    // 获取当前播放状态
    WHBMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] integerValue];
    
    // 绑定播放状态和界面之间的关系
    [self refreshUIWithStatus:status];
}
- (void)musicPlayerPlayingSongDidChangedNotification:(NSNotification *)notification {
    WHBSong *playingSong = notification.userInfo[kMusicPlayerPlayingSong];
    [self refreshUIWithSong:playingSong];
}
- (void)musicPlayerCurrentTimeDidChangedNotification:(NSNotification *)notification {
    NSTimeInterval currentTime = [notification.userInfo[kCurrentTime] floatValue];
    NSTimeInterval totalTime = [notification.userInfo[kTotalTime] floatValue];
    
    // 更新UI
    NSDateFormatter *dateFmt = [NSDateFormatter new];
    dateFmt.dateFormat = @"mm:ss";
    
    self.currentTimeLabel.text = [dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    self.totalTimeLabel.text = [dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalTime]];
    self.progressSlider.value = currentTime / totalTime;
    [self.lrcView setCurrentTime:currentTime * 1000];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUIWithSong:_Player.playingSong];
    [self refreshUIWithStatus:_Player.status];

    [self setupNotification];
}
// 播放状态和界面之间的关系
- (void)refreshUIWithStatus:(WHBMusicPlayerStatus)status {
    // 告诉播放按钮状态和播放器内部的状态之间的关系
    self.playOrPauseButton.selected = status == WHBMusicPlayerStatusPlaying;
}
-(void)refreshUIWithSong:(WHBSong*)song{
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:song.coverPath];
    self.coverImageView.image = [UIImage imageWithContentsOfFile:song.coverPath];
    self.title = song.name;

    [self.lrcView setLrc:song.lrc];
    
}


-(void)dealloc{
    [self teardownNotifications];

}
// 卸载通知
- (void)teardownNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

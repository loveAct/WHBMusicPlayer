//
//  ViewController.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "WHBLabel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet WHBLabel *lbl;

@end

@implementation ViewController
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

-(void)setupNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayerStatusDidChangedNotification:) name:WHBMusicPlayerStatusDidChangedNotificatio object:nil];
    
}

#pragma mark - 通知处理回调
- (void)musicPlayerStatusDidChangedNotification:(NSNotification *)notification {
    // 获取当前播放状态
    WHBMusicPlayerStatus status = [notification.userInfo[kMusicPlayerStatus] integerValue];
    
    // 绑定播放状态和界面之间的关系
    [self refreshUIWithStatus:status];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshUIWithStatus:_Player.status];
    self.lbl.highlightWidth = 40;
    [self setupNotification];
}
// 播放状态和界面之间的关系
- (void)refreshUIWithStatus:(WHBMusicPlayerStatus)status {
    // 告诉播放按钮状态和播放器内部的状态之间的关系
    self.playOrPauseButton.selected = status == WHBMusicPlayerStatusPlaying;
}


-(void)dealloc{
    [self teardownNotifications];
    
}
// 卸载通知
- (void)teardownNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end

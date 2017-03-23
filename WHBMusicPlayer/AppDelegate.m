//
//  AppDelegate.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "WHBPlaylist.h"
#import "WHBSong.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(_S(@"China"));
    WHBPlaylist *playlist = _PlaylistMgr.allPlaylists.firstObject;
    _Player.songs = playlist.allSongs;
//    NSLog(@"%@",_Player.songs.lastObject);
//    NSLog(@"%@",lrc.lrc);
    
    [[UIApplication sharedApplication]becomeFirstResponder];
    
    // 开启可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return YES;
}
-(BOOL)becomeFirstResponder{
    return YES;
}
// 系统远程事件
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [_Player play];
            break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop:
            [_Player pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [_Player next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [_Player prev];
            break;
        default:
            break;
    }
    
}


@end

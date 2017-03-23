//
//  WHBSong.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBSong.h"

@implementation WHBSong

-(WHBLrc *)lrc{
    return [[WHBLrc alloc]initWithLrcPath:self.lrcPath];
}

@end

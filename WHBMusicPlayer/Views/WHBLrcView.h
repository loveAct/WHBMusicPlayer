//
//  WHBLrcView.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHBLrc.h"
@interface WHBLrcView : UIView
@property (strong, nonatomic) UIColor   *highlightColor;

- (void)setLrc:(WHBLrc *)lrc;
- (void)setCurrentTime:(float)currentTime;
@end

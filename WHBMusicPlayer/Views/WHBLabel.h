//
//  WHBLabel.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHBLrc.h"
@interface WHBLabel : UILabel
@property(nonatomic,assign) float highlightWidth;

@property(nonatomic,strong) UIColor *highlightColor;

@property (assign, nonatomic) BOOL  isHighlight;

@property(nonatomic,strong) WHBLrcLine *line;

- (instancetype)initWithFont:(CGFloat)font line:(WHBLrcLine *)line highlightColor:(UIColor *)highlightColor;
@end

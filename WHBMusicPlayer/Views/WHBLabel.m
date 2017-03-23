//
//  WHBLabel.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBLabel.h"

@implementation WHBLabel

- (instancetype)initWithFont:(CGFloat)font line:(WHBLrcLine *)line highlightColor:(UIColor *)highlightColor
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:font];
        self.text = line.lineText;
        self.line = line;
        self.highlightColor = highlightColor;

    }
    return self;
}


- (void)setHighlightWidth:(float)highlightWidth {
    _highlightWidth = highlightWidth;
    [self setNeedsDisplay];
}



- (void)setIsHighlight:(BOOL)isHighlight {
    _isHighlight = isHighlight;
    [self setNeedsDisplay];
}




-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if (self.isHighlight) {
        
    UIColor *highlightColor = self.highlightColor;
    if (highlightColor == nil) {
        highlightColor = [UIColor redColor];
    }
    
    [highlightColor set];
    // 通过图层混合绘制矩形
    // 1. 调试谁是 S,谁是 D,使用 kCGBlendModeCopy: R = S
    // 2. 确定 S 矩形 ,D 文本
    // 3. 选择正确的混合算法

    UIRectFillUsingBlendMode(CGRectMake(0, 0, self.highlightWidth, rect.size.height), kCGBlendModeSourceIn);
    
    }
}

@end

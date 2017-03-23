//
//  WHBLrcView.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBLrcView.h"
#import "WHBLabel.h"
// 对行标签对象进行布局
static float topMargin = 5;
static float bottomMargin = 5;
static float space = 8;
static float labelHeight = 30.0;

@interface WHBLrcView ()
@property(nonatomic,strong)     WHBLabel *selectedLabel;
@end

@implementation WHBLrcView{
    UIScrollView *_scrollview;

}

// 通过时间寻找已经创建好的label
- (WHBLabel *)lineLabelWithCurrentTime:(float)currentTime {
    NSArray *lineLabels = _scrollview.subviews;
    for (WHBLabel *linelabel in lineLabels) {
        if (![linelabel isKindOfClass:[WHBLabel class]]) {
            continue;
        }
        if (currentTime >= linelabel.line.beginTime && currentTime <= linelabel.line.beginTime + linelabel.line.duration) {
            return  linelabel;
        }

    }
    return nil;
}
// 设置当前时间,通过当前时间定位高亮label,并且切换行的自动滚动
- (void)setCurrentTime:(float)currentTime {
    WHBLabel *currentLabel = [self lineLabelWithCurrentTime:currentTime];
    if (currentLabel == nil) {
        return;
    }
    if (_selectedLabel != nil && _selectedLabel != currentLabel) {
        self.selectedLabel.font = [UIFont systemFontOfSize:16];
        self.selectedLabel.isHighlight = NO;
        [_scrollview setContentOffset:CGPointMake(0, currentLabel.frame.origin.y - _scrollview.contentInset.top) animated:YES];
    }
    _selectedLabel = currentLabel;
    self.selectedLabel.font = [UIFont systemFontOfSize:20];
    self.selectedLabel.isHighlight = YES;
    
    // 解决高亮
    // 3000
    //               (当前时间 - 开始时间)
    // [410,2755](0,350)庄(0,250)心(0,300)妍(0,250)-(0,355)后(0,300)来(0,350)才(0,250)发(0,350)现
    // 算法的思路:
    
    // 行的流失时间
    float lapsedTime = currentTime - currentLabel.line.beginTime;

    // 具体应该高亮的宽度
    float selectedPartWidth = 0;
    
    NSMutableString *highlightString = [NSMutableString string];

    for (WHBLrcLinePart *part in currentLabel.line.parts) {
        if(lapsedTime - part.duration < 0) {
            // 选中part比率
            // 处理当前正好唱到哪个部分
            // 当前唱的部分高亮的百分比
            float percent = lapsedTime / part.duration;
            // 当前唱的部分的字符串所占的总体宽度
            CGSize size = [part.text sizeWithAttributes:@{
                                                NSFontAttributeName:_selectedLabel.font
                                                          }];
            // 具体应该高亮的宽度
            selectedPartWidth = size.width * percent;
            break;
        }else{
            [highlightString appendString:part.text];
            // 经过一个字又流失时间
            lapsedTime -= part.duration;
        }
    }
    
    
    // 之前的完成字的选中
    CGSize highlightSize = [highlightString sizeWithAttributes:@{
                                     NSFontAttributeName:_selectedLabel.font
                                                                 }];
    selectedPartWidth = highlightSize.width + selectedPartWidth;
    _selectedLabel.highlightWidth = selectedPartWidth;
    
}

// 设置歌词对象,通过歌词对象来生成自定义View
- (void)setLrc:(WHBLrc *)lrc {
    // 思路: 内部ScrollView 上下滚动 随着歌词行决定
    // ScrollView 内部 很多 行(HMLabel)
    // 通过歌词对象可以生成 HMLabel
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]init];
        [self addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    // 清空之前的所有的歌词行的标签
    [self removeAllSubViews:_scrollview];
    
    NSMutableArray *lineLabels = [NSMutableArray array];

    // 创建所需要的行标签对象
    for (WHBLrcLine *line in lrc.lines) {
        WHBLabel *lineLabel = [[WHBLabel alloc]initWithFont:16 line:line highlightColor:self.highlightColor];
        [_scrollview addSubview:lineLabel];
        [lineLabels addObject:lineLabel];
    }
    
    [self makeLayoutLineLabels:lineLabels];
    
//    UIView *lineView = [UIView new];
//    lineView.backgroundColor = [UIColor redColor];
//    [self addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self);
//        make.height.mas_equalTo(0.5);
//        make.center.equalTo(self);
//    }];
    
    _scrollview.contentInset = UIEdgeInsetsMake(_scrollview.bounds.size.height/2 - labelHeight/2 - topMargin, 0, _scrollview.bounds.size.height/2 - labelHeight/2 - bottomMargin, 0);
    _scrollview.contentOffset =CGPointMake(0, -_scrollview.contentInset.top);

}

// 对行标签对象进行布局
-(void)makeLayoutLineLabels:(NSArray*)lineLabels{
    
    for (int i = 0; i < lineLabels.count; i++) {
        WHBLabel *lineLabel = lineLabels[i];
        WHBLabel *nextLabel = nil;
        if (i > 0) {
        nextLabel = lineLabels[i - 1];
        }
    if (i == 0) {
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scrollview.mas_top).offset(topMargin);
            make.height.mas_equalTo(labelHeight);
            make.centerX.equalTo(_scrollview);
        }];
    }else if (i == lineLabels.count - 1){
        if (i == 0) {
            return;
        }
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nextLabel.mas_bottom).offset(space);
            make.height.mas_equalTo(labelHeight);
            make.centerX.equalTo(_scrollview);
            make.bottom.equalTo(_scrollview).offset(-bottomMargin);
        }];
    }else{
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nextLabel.mas_bottom).offset(space);
            make.height.mas_equalTo(labelHeight);
            make.centerX.equalTo(_scrollview);
        }];
    }
    }
    [self layoutIfNeeded];

}

-(void)removeAllSubViews:(UIView *)view{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

@end

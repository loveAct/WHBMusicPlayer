//
//  WHBLrc.m
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHBLrc.h"
#import "NSString+Substring.h"

@implementation WHBLrcLinePart

- (instancetype)initWithLinePartString:(NSString *)linePartString
{
    self = [super init];
    if (self) {
//        (0,7828)看
        NSString *timeString = [linePartString substringWithinBoundsLeft:@"(" right:@")"];
        NSRange rangeleft = [linePartString rangeOfString:@")"];
        NSRange range = [timeString rangeOfString:@","];
        self.duration = [[timeString substringFromIndex:range.location + 1] floatValue];
        self.unknown = [[timeString substringToIndex:range.location] floatValue];
        self.text = [linePartString substringFromIndex:rangeleft.location + 1];
    }
    return self;
}

@end

@implementation WHBLrcLine

- (instancetype)initWithLineString:(NSString *)lineString
{
    self = [super init];
    if (self) {
        //[19725,8377](0,7828)看(0,203)着(0,152)时(0,194)间
        NSString *timeString = [lineString substringWithinBoundsLeft:@"[" right:@"]"];
        NSRange range = [timeString rangeOfString:@","];
        self.beginTime = [[timeString substringToIndex:range.location] floatValue];
        self.duration = [[timeString substringFromIndex:range.location + 1] floatValue];
       
        NSString *pattern = @"\\(\\d+,\\d+\\)[\\w\\-\\s*]+";//\\s*
        NSRegularExpression *regularExp = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
      NSArray<NSTextCheckingResult*>* results = [regularExp matchesInString:lineString options:NSMatchingReportProgress range:NSMakeRange(0, lineString.length)];
        
        NSMutableArray<WHBLrcLinePart *> *parts = [NSMutableArray array];
        NSMutableString *strs = [NSMutableString string];
        for (NSTextCheckingResult *result in results) {
            
            NSString *linePartString = [lineString substringWithRange:result.range];
            WHBLrcLinePart *linePart = [[WHBLrcLinePart alloc]initWithLinePartString:linePartString];
            [parts addObject:linePart];
            [strs appendString:linePart.text];
        }
        self.lineText = strs.copy;
        self.parts = parts.copy;
        
    }
    return self;
}
- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    
    [desc appendFormat:@"开始时间:%f,时长:%f\n",self.beginTime,self.duration];
    [desc appendString:@"部分列表:\n"];
    
    for (WHBLrcLinePart *part in self.parts) {
        [desc appendFormat:@"内容:%@,时长:%f\n",part.text,part.duration];
    }
    
    return desc;
}
@end

@implementation WHBLrc

- (instancetype)initWithLrcPath:(NSString *)lrcPath
{
    self = [super init];
    if (self) {
       NSString *str = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lineArr = [str componentsSeparatedByString:@"\n"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *lineString in lineArr) {
            WHBLrcLine *line = [[WHBLrcLine alloc]initWithLineString:lineString];
            [arr addObject:line];
        }
        self.lines = arr;
    }
    return self;
}
-(NSString *)description{
    NSMutableString *str = [NSMutableString string];
    for (WHBLrcLine *line in self.lines) {
        [str appendFormat:@"%@",line];
    }
    return str;
}


@end

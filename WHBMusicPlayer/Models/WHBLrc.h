//
//  WHBLrc.h
//  WHBMusicPlayer
//
//  Created by apple on 2016/12/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHBLrcLinePart : NSObject

@property(nonatomic,copy) NSString *text;

@property(nonatomic,assign) float duration;

@property(nonatomic,assign) float unknown;

@end

@interface WHBLrcLine : NSObject

@property(nonatomic,copy) NSArray<WHBLrcLinePart*> *parts;

@property(nonatomic,assign) float duration;

@property(nonatomic,assign) float beginTime;

@property(nonatomic,copy) NSString *lineText;

@end


//歌词类
@interface WHBLrc : NSObject

@property(nonatomic,copy) NSArray<WHBLrcLine *> *lines;

- (instancetype)initWithLrcPath:(NSString *)lrcPath;

@end

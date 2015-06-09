//
//  MusicTool.h
//  MusicLamp
//
//  Created by yubinyang on 15/2/8.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "MusicTool.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MediaPlayer.h>

@class SongModel;

@protocol MusicToolDelegate <NSObject>

@optional
- (void)nextWithRepace:(BOOL)isPepace;

@end

@interface MusicTool : NSObject

@property (nonatomic,assign) NSInteger selectRow; // 选中行
@property (nonatomic,strong) SongModel *songModel; // 歌曲模型
@property (nonatomic,strong) NSMutableArray *songList; // 歌曲列表

@property (nonatomic,assign,getter=isRepace) BOOL repace;

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,weak) id<MusicToolDelegate> delegate;


// 单例
+ (MusicTool *)getInstance;

// 播放
- (void)updatePlayerWithRow:(NSInteger)selectRow;

// 继续播放
- (void)play;

// 暂停
- (void)pause;


@end

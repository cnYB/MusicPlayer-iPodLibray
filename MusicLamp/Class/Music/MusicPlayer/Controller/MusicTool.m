//
//  MusicTool.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/8.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "MusicTool.h"
#import "SongModel.h"

@interface MusicTool ()

@property (nonatomic,assign) NSInteger currentRow;
@property (nonatomic,assign) NSInteger lastRow;
@property (nonatomic,assign) NSInteger rateValue;

@property (nonatomic,strong)  CADisplayLink *link;

@end

@implementation MusicTool

- (CADisplayLink *)link
{
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateUI)];
        // 设置刷新频率
        _link.frameInterval = 60;
    }
    return _link ;
}

- (void)updateUI
{
    
    NSNumber *duration = [NSNumber numberWithDouble:CMTimeGetSeconds(self.player.currentItem.duration)];
    NSNumber *currentTime = [NSNumber numberWithDouble:CMTimeGetSeconds(self.player.currentItem.currentTime)];
    
    if ([duration floatValue] - [currentTime floatValue] <= 0.1) {
        
        [self.link invalidate];
        self.link = nil;
        
        [self next];
        
        if ([self.delegate respondsToSelector:@selector(nextWithRepace:)]) {
            [self.delegate nextWithRepace:self.isRepace];
        }
        
        if (self.isRepace) {
            [self play];
        }

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_PLAYER_UI_NOTIFICATION" object:currentTime];
}

- (void)updateTime:(NSNotification *)notification
{
    [[self player] seekToTime:CMTimeMakeWithSeconds([notification.object floatValue], 1)];
}

+ (MusicTool *)getInstance
{
    static MusicTool *singleton = nil;
    if (singleton == nil) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            singleton = [[MusicTool alloc]init];
            singleton.player = [[AVPlayer alloc]init];
            
            singleton.currentRow = -1; // 初始化
            
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"play pressed" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"pause pressed" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"stop pressed" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"forward pressed" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"backward pressed" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:singleton selector:@selector(handleNotification:) name:@"other pressed" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:singleton selector:@selector(updateTime:) name:@"REFRESH_PLAYER_CURRENTTIME_NOTIFICATION" object:nil];
            
        });
    }
    return singleton;
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"play pressed"]) {
        [self play];
        
    } else  if ([notification.name isEqualToString:@"pause pressed"]) {
        [self pause];
        
    } else if ([notification.name isEqualToString:@"stop pressed"]) {
        [self pause];
        
    } else if ([notification.name isEqualToString:@"forward pressed"]) {
        [self next];
        
    } else if ([notification.name isEqualToString:@"backward pressed"]) {
        [self previous];
        
    }
    
}

- (void)playSong:(SongModel *)song row:(NSInteger)row url:(NSURL *)url
{
    if ((self.lastRow = row) == self.currentRow) return;
    
    self.player = [AVPlayer playerWithURL:url];
    
    self.currentRow = row;
    
    [self play];
}

- (void)configPlayingInfoWithRow:(NSInteger)row
{
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    
    MPMediaItem *item = mediaQueue.items[row];
    
    NSString *title = item.title;
    NSString *artist = item.artist;
    NSTimeInterval duration = item.playbackDuration;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (item.artwork) {
        [dict setObject:item.artwork forKey:MPMediaItemPropertyArtwork];//专辑图片设置
    }
    
    [dict setObject:title ? title : @"" forKey:MPMediaItemPropertyTitle];
    [dict setObject:artist ? artist : @"" forKey:MPMediaItemPropertyAlbumTitle];
    [dict setObject:@(duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [dict setObject:[NSNumber numberWithDouble:CMTimeGetSeconds(self.player.currentItem.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [dict setObject:[NSNumber numberWithFloat:self.rateValue] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

- (void)updatePlayerWithRow:(NSInteger)selectRow
{
    SongModel *songModel = self.songList[selectRow];
    
    [self playSong:songModel row:selectRow url:songModel.songUrl];
}

- (void)play
{
    [self playWithRow:self.currentRow];
    
    [self.link invalidate];
    self.link = nil;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)playWithRow:(NSInteger)row
{
    [self.player play];
    self.rateValue = 1;
    [self configPlayingInfoWithRow:row];
}

- (void)pause
{
    [self pauseWithRow:self.currentRow];
    
    [self.link invalidate];
    self.link = nil;
}

- (void)pauseWithRow:(NSInteger)row
{
    [self.player pause];
    self.rateValue = 0.00001;
    [self configPlayingInfoWithRow:row];
}

- (void)previous
{
    [self updatePlayerWithRow:(_selectRow == 0 ? _selectRow = self.songList.count - 1 : --_selectRow )];
    self.rateValue = 1;
    [self configPlayingInfoWithRow:_selectRow];
}

- (void)next
{
    [self updatePlayerWithRow:(_selectRow == self.songList.count - 1 ? _selectRow = 0 : ++_selectRow )];
    self.rateValue = 1;
    [self configPlayingInfoWithRow:_selectRow];
}

@end

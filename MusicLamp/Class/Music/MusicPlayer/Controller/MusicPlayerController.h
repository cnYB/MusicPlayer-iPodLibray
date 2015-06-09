//
//  MusicPlayerController.h
//  MusicLamp
//
//  Created by yubinyang on 15/2/8.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongModel;

@interface MusicPlayerController : UIViewController

@property (nonatomic,assign) NSInteger selectRow;
@property (nonatomic,strong) SongModel *songModel;
@property (nonatomic,strong) NSMutableArray *songList;

@end

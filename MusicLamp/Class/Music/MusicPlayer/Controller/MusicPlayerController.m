//
//  MusicPlayerController.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/8.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "MusicPlayerController.h"
#import "SongModel.h"
#import "MusicTool.h"
#import "Notifications.h"
#import "MusicQueueController.h"
#import "UIImage+BlurredFrame.h"
#import <MediaPlayer/MediaPlayer.h>

extern NSString *remoteControlPlayButtonTapped;
extern NSString *remoteControlPauseButtonTapped;
extern NSString *remoteControlStopButtonTapped;
extern NSString *remoteControlForwardButtonTapped;
extern NSString *remoteControlBackwardButtonTapped;
extern NSString *remoteControlOtherButtonTapped;

@interface MusicPlayerController () <MusicToolDelegate>

@property (weak, nonatomic ) IBOutlet UILabel              *titleLabel;// 歌名label
@property (weak, nonatomic ) IBOutlet UILabel              *artistLabel;// 歌手label
@property (weak, nonatomic ) IBOutlet UIImageView          *backgroundView;//模糊背景
@property (weak, nonatomic ) IBOutlet UIImageView          *iconView;// 专辑封面
@property (weak, nonatomic ) IBOutlet UIButton             *playAndPauseBtn;// 播放暂停
@property (weak, nonatomic ) IBOutlet UISlider             *sliderBar;// 进度条
@property (weak, nonatomic ) IBOutlet UILabel              *currentLabel;// 当前时间label
@property (weak, nonatomic ) IBOutlet UILabel              *overLabel;// 剩余时间label
@property (nonatomic,assign) int                  duration;// 歌曲总长度
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint   *queueListViewBottom;// 歌单下边距
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint   *queueListTop;// 歌单上边距
@property (weak, nonatomic ) IBOutlet UIView               *queueListView;//歌单view
@property (weak, nonatomic ) IBOutlet UIView               *queueListTableView;// 歌单表格
@property (weak, nonatomic ) IBOutlet UIButton             *repaceBtn;// 循环播放按钮

@property (weak, nonatomic ) IBOutlet UIView               *functionView;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint   *functionViewBottom;
@property (weak, nonatomic) IBOutlet UIView *volumeView;
@property (nonatomic,assign) BOOL functionBtnSelected;
@property (nonatomic,assign) BOOL queueListVisable;

@property (nonatomic,strong) MusicQueueController *musicQueueVc;// 歌单控制器

- (IBAction)playAndPauseClick:(UIButton *)sender; // 播放暂停事件
- (IBAction)previousClick:(UIButton *)sender; // 上一首事件
- (IBAction)nextClick:(UIButton *)sender; // 下一首事件
- (IBAction)queueClick:(UIButton *)sender; // 歌单列表开启
- (IBAction)queueClose:(UIButton *)sender; // 歌单列表关闭
- (IBAction)repaceClick:(UIButton *)sender; // 循环列表事件
- (IBAction)sliderValueChange:(UISlider *)sender; // 进度条事件
- (IBAction)functionClick:(UIButton *)sender; // 功能界面事件


@end

@implementation MusicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MusicTool getInstance].delegate = self; // 设置代理
    
    [self AddNotification]; //添加广播
    
    [self updatePlayerUIWithRow:(_selectRow)]; // 播放
    
    [self setupQueueList]; // 设置播放队列
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap:)];
    [self.backgroundView addGestureRecognizer:tap];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    volumeView.frame = CGRectMake(0, 0, self.volumeView.bounds.size.width, 30);
    
    [self.volumeView addSubview:volumeView];
}

- (void)setupQueueList
{
    self.musicQueueVc = [[MusicQueueController alloc]init];
    UITableView *tableView = self.musicQueueVc.tableView;
    tableView.frame = self.queueListTableView.bounds;
    [self.queueListTableView addSubview:tableView];
}

- (void)AddNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPlayButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlPauseButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlStopButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlForwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlBackwardButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:remoteControlOtherButtonTapped object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"REFRESH_PLAYER_UI_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"REFRESH_PLAYER_QUEUE_NOTIFICATION" object:nil];
}

- (void)handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:remoteControlPlayButtonTapped]) {
        [[MusicTool getInstance]play];
        self.playAndPauseBtn.selected = YES;
    } else  if ([notification.name isEqualToString:remoteControlPauseButtonTapped]) {
        [[MusicTool getInstance]pause];
        self.playAndPauseBtn.selected = NO;
    } else if ([notification.name isEqualToString:remoteControlStopButtonTapped]) {
        [[MusicTool getInstance]pause];
        self.playAndPauseBtn.selected = NO;
    } else if ([notification.name isEqualToString:remoteControlForwardButtonTapped]) {
        [self nextClick:nil];
    } else if ([notification.name isEqualToString:remoteControlBackwardButtonTapped]) {
        [self previousClick:nil];
    } else if ([notification.name isEqualToString:@"REFRESH_PLAYER_UI_NOTIFICATION"]) {
        self.sliderBar.value = [notification.object floatValue];
        self.currentLabel.text = [NSString stringWithFormat:@"%02d:%02d",[notification.object intValue] / 60,[notification.object intValue] % 60];
        self.overLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.duration / 60, self.duration % 60];
    } else if ([notification.name isEqualToString:@"REFRESH_PLAYER_QUEUE_NOTIFICATION"]) {
        SongModel *songModel = notification.object;
        [self updatePlayerUIWithRow:songModel.selectRow];
    }
    
}

- (IBAction)sliderValueChange:(UISlider *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_PLAYER_CURRENTTIME_NOTIFICATION" object:[NSNumber numberWithFloat:sender.value]];
}

- (IBAction)playAndPauseClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [[MusicTool getInstance]play];
    } else {
        [[MusicTool getInstance]pause];
    }
}

#pragma mark Tool 代理方法
- (void)nextWithRepace:(BOOL)isPepace
{
    if (isPepace) {
        [self updatePlayerUIWithRow:(_selectRow)];
    } else {
        [self nextClick:nil];
    }
}

- (IBAction)previousClick:(UIButton *)sender
{
    [self updatePlayerUIWithRow:(_selectRow == 0 ? _selectRow = self.songList.count - 1 : --_selectRow )];
}

- (IBAction)nextClick:(UIButton *)sender
{
    [self updatePlayerUIWithRow:(_selectRow == self.songList.count - 1 ? _selectRow = 0 : ++_selectRow )];
}

- (void)updatePlayerUIWithRow:(NSInteger)selectRow
{
    self.playAndPauseBtn.selected = YES;
    
    SongModel *songModel = [MusicTool getInstance].songList[selectRow];
    
    UIImage *img = songModel.artwork ? songModel.artwork : nil;
    CGRect frame = CGRectMake(0, 0, img.size.width, img.size.height);
    img = [img applyLightEffectAtFrame:frame];
    self.backgroundView.image = img;
    
    self.iconView.layer.cornerRadius = (self.iconView.bounds.size.width) * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
    self.iconView.layer.borderWidth = songModel.artwork ? 5 : 0;
    
    self.iconView.image = songModel.artwork ? songModel.artwork : [UIImage imageNamed:@"artwork_holder"];
    self.titleLabel.text = songModel.title;
    self.artistLabel.text = songModel.artist;
    self.sliderBar.maximumValue = (float)songModel.duration;
    self.duration = (int)songModel.duration;
    
    [[MusicTool getInstance] updatePlayerWithRow:selectRow];
}

- (void)backgroundTap:(UITapGestureRecognizer *)gesture
{
    [self functionClick:nil];
    
    if (self.queueListVisable) {
        [self queueCloseAction];
    }
}

- (IBAction)queueClick:(UIButton *)sender // 打开列表
{
    self.queueListVisable = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.iconView.alpha = 0;
        
        self.queueListTop.constant = 150;
        self.queueListViewBottom.constant = 0;
        [self.queueListView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.queueListTop.constant = 160;
            self.queueListViewBottom.constant = 0;
            [self.queueListView layoutIfNeeded];
        }];
    }];
}

- (IBAction)queueClose:(UIButton *)sender // 关闭列表
{
    [self queueCloseAction];
}

- (void)queueCloseAction // 关闭列表动画
{
    self.queueListVisable = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.iconView.alpha = 1;
        
        self.queueListViewBottom.constant -= self.queueListView.bounds.size.height;
        self.queueListTop.constant += self.queueListView.bounds.size.height;
        [self.queueListView layoutIfNeeded];
    }];
}

- (IBAction)functionClick:(UIButton *)sender // 打开关闭功能界面
{
    if (self.queueListVisable) return;
    
    self.functionBtnSelected = !self.functionBtnSelected;
    
    if (!self.functionBtnSelected) { // 关
        [UIView animateWithDuration:0.2 animations:^{
            self.functionView.alpha = 0;
            
            self.functionViewBottom.constant -= self.functionView.bounds.size.height;
            [self.functionView layoutIfNeeded];
        }];
    } else { // 开
        [UIView animateWithDuration:0.2 animations:^{
            self.functionView.alpha = 1;
            
            self.functionViewBottom.constant = 0;
            [self.functionView layoutIfNeeded];
        }];
    }
}

- (IBAction)repaceClick:(UIButton *)sender // 循环模式
{
    sender.selected = !sender.selected;
    [MusicTool getInstance].repace = sender.selected;
}


@end

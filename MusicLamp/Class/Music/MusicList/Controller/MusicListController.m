//
//  MusicListController.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/6.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "MusicListController.h"
#import "MusicPlayerController.h"

#import "MusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

#import "SongModel.h"
#import "SongCell.h"

#define kSongList @"songList"

@interface MusicListController () <MPMediaPickerControllerDelegate>

// 音乐列表
- (IBAction)reloadClick:(UIButton *)sender;

@end


@implementation MusicListController

#pragma mark - 懒加载

#pragma mark  -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 64;
}

- (IBAction)reloadClick:(UIButton *)sender
{
    if ([MPMediaQuery songsQuery].items.count != [MusicTool getInstance].songList.count || [MusicTool getInstance].songList.count == 0) {
        [self getLocalMediaQuery];
        [self.tableView reloadData];
    }
}

/**
 *  取得媒体队列
 */
- (void)getLocalMediaQuery
{
    
    [[MusicTool getInstance].songList removeAllObjects];
    
    MPMediaQuery *mediaQueue=[MPMediaQuery songsQuery];
    
    for (MPMediaItem *item in mediaQueue.items) {
        
        SongModel *song = [[SongModel alloc]init];
        song.title = item.title;
        song.artist = item.artist;
        song.albumTitle = item.albumTitle;
        song.songUrl = [item valueForProperty:MPMediaItemPropertyAssetURL];
        song.duration = item.playbackDuration;
        
        MPMediaItemArtwork *artwork = item.artwork;
        song.artwork =  [artwork imageWithSize: CGSizeMake(200, 200)];
        
        [[MusicTool getInstance].songList addObject:song];
    }
    
    NSData *encodedSceneList = [NSKeyedArchiver archivedDataWithRootObject:[MusicTool getInstance].songList];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedSceneList forKey:kSongList];
}

-(void)initializeDefaultDataList{
    //restore data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedEncodedData = [defaults objectForKey:kSongList];
    if(savedEncodedData == nil)
    {
        NSMutableArray *songList = [[NSMutableArray alloc] init];
        [MusicTool getInstance].songList = songList;
    }
    else{
        [MusicTool getInstance].songList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:savedEncodedData];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self initializeDefaultDataList];
    return [MusicTool getInstance].songList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongCell *cell = [SongCell cellWithTableView:tableView];
    
    cell.song = [MusicTool getInstance].songList[indexPath.row];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MusicPlayerController *playVc = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    playVc.selectRow = indexPath.row;
    playVc.songList = [MusicTool getInstance].songList;
    
    [MusicTool getInstance].selectRow = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

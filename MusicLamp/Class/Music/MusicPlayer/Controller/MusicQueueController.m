//
//  MusicQueryController.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/10.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "MusicQueueController.h"
#import "MusicTool.h"
#import "SongModel.h"
#import "QueueCell.h"

@interface MusicQueueController ()

@property (nonatomic,strong) NSMutableArray *songList;

@end

@implementation MusicQueueController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 55;
}

- (NSMutableArray *)songList
{
    if (!_songList) {
        _songList = [MusicTool getInstance].songList;
    }
    return _songList;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    QueueCell *cell = [QueueCell cellWithTableView:tableView];
    
    cell.song = self.songList[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SongModel *songModel = self.songList[indexPath.row];
    songModel.selectRow = indexPath.row;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESH_PLAYER_QUEUE_NOTIFICATION" object:songModel];
}
@end

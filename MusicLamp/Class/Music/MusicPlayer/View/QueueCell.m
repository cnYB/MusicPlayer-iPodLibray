//
//  QueueCell.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/11.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "QueueCell.h"
#import "SongModel.h"

@implementation QueueCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"queueList";
    
    QueueCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QueueCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}

- (void)setSong:(SongModel *)song
{
    _song = song;
    
    self.titleLabel.text = song.title;
    self.artistLabel.text = song.artist;
}

@end

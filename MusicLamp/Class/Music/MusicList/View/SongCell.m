//
//  SongCell.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/6.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "SongCell.h"
#import "SongModel.h"

@implementation SongCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"songList";
    return [tableView dequeueReusableCellWithIdentifier:ID];
}

- (UIImageView *)iconView
{
    _iconView.layer.cornerRadius = _iconView.frame.size.width * 0.5;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.borderWidth = 1;
    _iconView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;

    return _iconView;
}

- (void)setSong:(SongModel *)song
{
    _song = song;
    
    self.titleView.text = song.title;
    self.artistView.text = song.artist;
    if (song.artwork) {
        self.iconView.image = song.artwork;
    } else {
        self.iconView.image = [UIImage imageNamed:@"song_holder"];
    }
    
}

@end

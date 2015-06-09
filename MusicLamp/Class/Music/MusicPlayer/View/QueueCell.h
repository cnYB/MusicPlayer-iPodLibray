//
//  QueueCell.h
//  MusicLamp
//
//  Created by yubinyang on 15/2/11.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongModel;

@interface QueueCell : UITableViewCell

@property (nonatomic,strong) SongModel *song;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

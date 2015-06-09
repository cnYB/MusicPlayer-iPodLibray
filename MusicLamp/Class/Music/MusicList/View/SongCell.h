//
//  SongCell.h
//  MusicLamp
//
//  Created by yubinyang on 15/2/6.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongModel;

@interface SongCell : UITableViewCell

@property (nonatomic,strong) SongModel *song;

@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *artistView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

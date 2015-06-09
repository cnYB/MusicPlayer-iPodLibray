//
//  SongModel.h
//  MusicLamp
//
//  Created by yubinyang on 15/2/6.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SongModel : NSObject

@property (nonatomic,copy  ) NSString *title;
@property (nonatomic,copy  ) NSString *artist;
@property (nonatomic,copy  ) NSString *albumTitle;
@property (nonatomic,copy  ) NSURL    *songUrl;
@property (nonatomic,strong) UIImage  *artwork;
@property (nonatomic,assign) NSTimeInterval duration;



@property (nonatomic,assign) NSInteger selectRow;


@end

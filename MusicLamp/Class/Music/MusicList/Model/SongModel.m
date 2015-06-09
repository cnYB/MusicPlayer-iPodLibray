//
//  SongModel.m
//  MusicLamp
//
//  Created by yubinyang on 15/2/6.
//  Copyright (c) 2015年 IMT. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title          forKey:@"title"];
    [aCoder encodeObject:self.artist            forKey:@"artist"];
    [aCoder encodeObject:self.albumTitle       forKey:@"albumTitle"];
    [aCoder encodeObject:self.songUrl    forKey:@"songUrl"];
    [aCoder encodeObject:self.artwork       forKey:@"artwork"];
    [aCoder encodeDouble:self.duration    forKey:@"duration"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])) {
        self.title               = [aDecoder decodeObjectForKey:@"title"];
        self.artist              = [aDecoder decodeObjectForKey:@"artist"];
        self.albumTitle         = [aDecoder decodeObjectForKey:@"albumTitle"];
        self.songUrl      = [aDecoder decodeObjectForKey:@"songUrl"];
        self.artwork      = [aDecoder decodeObjectForKey:@"artwork"];
        self.duration      = [aDecoder decodeDoubleForKey:@"duration"];
    }
    
    return self;
}

@end

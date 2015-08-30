//
//  PBGAudioPlayer.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPipeline.h"

@class PBGAudioPlayer;

@protocol PBGAudioPlayerDelegate <NSObject>

- (void) audioPlayerFinished:(PBGAudioPlayer *) audioPlayer;

@end

@interface PBGAudioPlayer : NSObject

@property (nonatomic) id<AudioReader> audioReader;
@property (nonatomic, weak) id<PBGAudioPlayerDelegate> delegate;

- (void) start;
- (void) stop;

@end

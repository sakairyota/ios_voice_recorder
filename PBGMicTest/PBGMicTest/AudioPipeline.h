//
//  AudioPipeline.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol AudioReader <NSObject>

- (BOOL) audioPipelineRead: (AudioQueueBuffer *)buffer;

@end


@protocol AudioWriter <NSObject>

- (void) audioPipelineWrite: (AudioQueueBuffer)buffer;

@end
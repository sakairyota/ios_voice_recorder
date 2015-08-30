//
//  AudioPipeline.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct RawAudioData {
    UInt32 mLength;
    void * mAudioData;
    
} RawAudioData;

typedef RawAudioData *RawAudioDataRef;


@protocol AudioReader <NSObject>

- (BOOL) audioPipelineRead: (RawAudioDataRef)data;

@end


@protocol AudioWriter <NSObject>

- (void) audioPipelineWrite: (RawAudioDataRef)data;

@end
//
//  AudioStore.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "AudioStore.h"
#import "AudioUtil.h"

#define BUFFER_ALLOC_SIZE 100

@implementation AudioStore
{
    RawAudioData *_data;
    NSInteger _bufferSize;
    NSInteger _bufferPointerSize;
    NSInteger _bufferReadPointer;
}


-(id) init
{
    if (self = [super init]) {
        _bufferSize = 0;
        _bufferPointerSize = BUFFER_ALLOC_SIZE;
        _bufferReadPointer = 0;
        _data = calloc(_bufferPointerSize, sizeof(RawAudioData));
    }
    return self;
}

- (void)dealloc {
    free(_data);
}

- (void) readFromFirst {
    _bufferReadPointer = 0;
}

// AudioPipeline
- (void) audioPipelineWrite: (RawAudioDataRef)data {
    NSInteger bufferPointer = _bufferSize;

    _bufferSize++;
    if (_bufferSize > _bufferPointerSize) {
        _bufferPointerSize += BUFFER_ALLOC_SIZE;
        _data = realloc(_data, _bufferPointerSize * sizeof(RawAudioData));

        NSLog(@"AudioStore.push : realloc");
    }

    [AudioUtil copyFromRaw:data toRaw:&_data[bufferPointer]];

    //NSLog(@"audioPipelineWrite : %ld", bufferPointer);
}

- (BOOL) audioPipelineRead: (RawAudioDataRef)data {
    if (_bufferReadPointer >= _bufferSize) {
        return NO;
    }

    [AudioUtil copyFromRaw:&_data[_bufferReadPointer] toRaw:data];

    //NSLog(@"audioPipelineRead : %ld", _bufferReadPointer);
    _bufferReadPointer++;
    return YES;
}

@end

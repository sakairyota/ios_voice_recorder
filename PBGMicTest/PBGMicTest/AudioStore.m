//
//  AudioStore.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "AudioStore.h"
#define BUFFER_ALLOC_SIZE 100

@implementation AudioStore
{
    AudioQueueBuffer *_buffers;
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
        _buffers = malloc(_bufferPointerSize * sizeof(AudioQueueBuffer));
    }
    return self;
}

- (void)dealloc {
    free(_buffers);
}

- (void) readFromFirst {
    _bufferReadPointer = 0;
}

// AudioPipeline
- (void) audioPipelineWrite: (AudioQueueBuffer)buffer {
    NSLog(@"AudioStore.push called");

    NSInteger bufferPointer = _bufferSize;

    _bufferSize++;
    if (_bufferSize > _bufferPointerSize) {
        _bufferPointerSize += BUFFER_ALLOC_SIZE;
        _buffers = realloc(_buffers, _bufferPointerSize * sizeof(AudioQueueBuffer));

        NSLog(@"AudioStore.push : realloc");
    }

    _buffers[bufferPointer] = buffer;
}

- (BOOL) audioPipelineRead: (AudioQueueBuffer *)buffer {
    if (_bufferReadPointer >= _bufferSize) {
        return NO;
    }

    *buffer = _buffers[_bufferReadPointer];
    _bufferReadPointer++;
    return YES;
}

@end

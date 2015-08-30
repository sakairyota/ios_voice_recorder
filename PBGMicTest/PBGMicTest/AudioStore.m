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
}


-(id) init
{
    if (self = [super init]) {
        _bufferSize = 0;
        _bufferPointerSize = BUFFER_ALLOC_SIZE;
        _buffers = malloc(_bufferPointerSize * sizeof(AudioQueueBuffer));
    }
    return self;
}

- (void)dealloc {
    free(_buffers);
}

- (void) push: (AudioQueueBuffer)buffer {
    NSLog(@"AudioStore.push called");

    NSInteger bufferPointer = _bufferPointerSize;

    _bufferSize++;
    if (_bufferSize > _bufferPointerSize) {
        _bufferPointerSize += BUFFER_ALLOC_SIZE;
        _buffers = realloc(_buffers, _bufferPointerSize * sizeof(AudioQueueBuffer));

        NSLog(@"AudioStore.push : realloc");
    }

    _buffers[bufferPointer] = buffer;
}

@end

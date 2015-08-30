//
//  PBGAudioPlayer.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "PBGAudioPlayer.h"

#define NUM_BUFFERS 3

@implementation PBGAudioPlayer
{
    AudioStreamBasicDescription _format;
    AudioQueueRef _queue;
    AudioQueueBufferRef _buffers[NUM_BUFFERS];
}

static void AudioOutputCallback(void *inUserData,
                                AudioQueueRef inAQ,
                                AudioQueueBufferRef audioQueueBufferRef
                                ) {

    NSLog(@"audioOutputCallback");

    PBGAudioPlayer* player = (__bridge PBGAudioPlayer*) inUserData;
    [player enqueueBuffer: audioQueueBufferRef];
}

-(id) init
{
    if (self = [super init]) {
        _format.mSampleRate = 44100.0f;
        _format.mFormatID = kAudioFormatLinearPCM;
        _format.mFramesPerPacket = 1;
        _format.mChannelsPerFrame = 1;
        _format.mBytesPerFrame = 2;
        _format.mBytesPerPacket = 2;
        _format.mBitsPerChannel = 16;
        _format.mReserved = 0;
        _format.mFormatFlags =
        kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    }
    return self;
}

- (void) start {
    AudioQueueNewOutput(
            &_format,
            AudioOutputCallback,
            (__bridge void *)(self),
            CFRunLoopGetCurrent(),
            kCFRunLoopCommonModes,
            0,
            &_queue);


    for(int i=0; i < NUM_BUFFERS; i++)
    {
        AudioQueueAllocateBuffer(_queue, (_format.mSampleRate / 10.0f) * _format.mBytesPerFrame, &_buffers[i]);
        [self enqueueBuffer: _buffers[i]];
    }

    OSStatus status = AudioQueueStart(_queue, nil);

    NSLog(@"player start (status: %d)", status);
}

- (void) stop {
    AudioQueueFlush(_queue);
    AudioQueueStop(_queue, NO);
    AudioQueueDispose(_queue, YES);
}

- (void) finish {
    [self stop];
    if (self.delegate) {
        [self.delegate audioPlayerFinished:self];
    }
}

- (void)enqueueBuffer:(AudioQueueBufferRef)audioQueueBufferRef {
    if (self.audioReader) {
        NSLog(@"enqueueBuffer");
        AudioQueueBuffer buffer;
        BOOL result = [self.audioReader audioPipelineRead:&buffer];
        if (!result) {
            [self finish];
            return;
        }
        *audioQueueBufferRef = buffer;

        AudioQueueEnqueueBuffer(_queue, audioQueueBufferRef, 0, nil);
    }
}

@end

//
//  PBGAudioPlayer.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "PBGAudioPlayer.h"
#import "AudioUtil.h"

#define NUM_BUFFERS 3

#define SAMPLE_RATE 44100.0f
#define FRAMES_PER_BUFFER 4410

@implementation PBGAudioPlayer
{
    AudioStreamBasicDescription _format;
    AudioQueueRef _queue;
    AudioQueueBufferRef _buffers[NUM_BUFFERS];

    NSInteger _frameIndex;
}

static void AudioOutputCallback(void *inUserData,
                                AudioQueueRef inAQ,
                                AudioQueueBufferRef audioQueueBufferRef
                                ) {
    PBGAudioPlayer* player = (__bridge PBGAudioPlayer*) inUserData;
    [player enqueueBuffer: audioQueueBufferRef];
}

-(id) init
{
    if (self = [super init]) {
        _format.mSampleRate = SAMPLE_RATE;
        _format.mFormatID = kAudioFormatLinearPCM;
        _format.mFramesPerPacket = 1;
        _format.mChannelsPerFrame = 1;
        _format.mBytesPerFrame = 2;
        _format.mBytesPerPacket = 2;
        _format.mBitsPerChannel = 16;
        _format.mReserved = 0;
        _format.mFormatFlags =
            kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;

        _frameIndex = 0;
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
        AudioQueueAllocateBuffer(_queue, FRAMES_PER_BUFFER * _format.mBytesPerFrame, &_buffers[i]);
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
        RawAudioDataRef raw = [AudioUtil createRawZero];
        BOOL result = [self.audioReader audioPipelineRead:raw];
        if (!result) {
            [self finish];
            return;
        }

        [AudioUtil copyFromRaw:raw toBuffer:audioQueueBufferRef];

        AudioQueueEnqueueBuffer(_queue, audioQueueBufferRef, 0, nil);
        NSLog(@"enqueue");
    }
}

@end

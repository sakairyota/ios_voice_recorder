//
//  PBGAudioRecorder.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "PBGAudioRecorder.h"
#import <AudioToolbox/AudioToolbox.h>

#define NUM_BUFFERS 3

@interface PBGAudioRecorder()
{
    AudioStreamBasicDescription _format;
    AudioQueueRef _queue;
    AudioQueueBufferRef _buffers[NUM_BUFFERS];
}
@end

@implementation PBGAudioRecorder

static void audioInputCallback(void* inUserData,
                               AudioQueueRef inAQ,
                               AudioQueueBufferRef inBuffer,
                               const AudioTimeStamp *inStartTime,
                               UInt32 inNumberPacketDescriptions,
                               const AudioStreamPacketDescription *inPacketDescs)
{
    PBGAudioRecorder* recorder = (__bridge PBGAudioRecorder*) inUserData;
    AudioQueueEnqueueBuffer(recorder->_queue, inBuffer, 0, nil);
    NSLog(@"hoge");
}


-(id) init
{
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
    return self;
}

- (void) start {
    AudioQueueNewInput(&_format, audioInputCallback, (__bridge void *)(self), CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue);

    for(int i=0; i < NUM_BUFFERS; i++)
    {
        AudioQueueAllocateBuffer(_queue, (_format.mSampleRate / 100.0f) * _format.mBytesPerFrame, &_buffers[i]);
        AudioQueueEnqueueBuffer(_queue, _buffers[i], 0, nil);
    }

    AudioQueueStart(_queue, NULL);
}

- (void) stop {
    AudioQueueFlush(_queue);
    AudioQueueStop(_queue, NO);
    AudioQueueDispose(_queue, YES);
}

@end
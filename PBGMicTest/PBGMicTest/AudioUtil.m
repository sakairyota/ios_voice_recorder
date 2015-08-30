//
//  AudioUtil.m
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import "AudioUtil.h"

@implementation AudioUtil

+ (RawAudioDataRef)createRawZero {
    RawAudioDataRef data = calloc(1, sizeof(RawAudioData));
    data->mLength = 0;
    return data;
}

+ (RawAudioDataRef)createRawFromBuffer:(AudioQueueBufferRef) buffer {
    RawAudioDataRef data = calloc(1, sizeof(RawAudioData));
    UInt32 length = buffer->mAudioDataByteSize;

    data->mLength = length;
    data->mAudioData = malloc(length);
    memcpy(data->mAudioData, buffer->mAudioData, length);

    return data;
}

+ (void)copyFromRaw:(RawAudioDataRef) raw
           toBuffer:(AudioQueueBufferRef) buffer {
    UInt32 sizeToCopy = MIN(raw->mLength, buffer->mAudioDataBytesCapacity);

    buffer->mAudioDataByteSize = sizeToCopy;
    memcpy(buffer->mAudioData, raw->mAudioData, sizeToCopy);
}

+ (void)copyFromRaw:(RawAudioDataRef)fromData
              toRaw:(RawAudioDataRef)toData{
    if (toData == NULL) {
        assert(@"toData is NULL");
    }
    [self freeContentData:toData];

    UInt32 length = fromData->mLength;
    toData->mLength = length;

    toData->mAudioData = malloc(fromData->mLength);
    memcpy(toData->mAudioData, fromData->mAudioData, length);
}

+ (void)freeContentData:(RawAudioDataRef)rawData {
    free(rawData->mAudioData);
}

@end

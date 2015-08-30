//
//  AudioUtil.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPipeline.h"

@interface AudioUtil : NSObject

+ (RawAudioDataRef)createRawZero;
+ (RawAudioDataRef)createRawFromBuffer:(AudioQueueBufferRef) buffer;
+ (void)copyFromRaw:(RawAudioDataRef) raw
           toBuffer:(AudioQueueBufferRef) buffer;
+ (void)copyFromRaw:(RawAudioDataRef)fromData
              toRaw:(RawAudioDataRef)toData;

@end

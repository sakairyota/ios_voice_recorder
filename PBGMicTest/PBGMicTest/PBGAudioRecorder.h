//
//  PBGAudioRecorder.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPipeline.h"

@interface PBGAudioRecorder : NSObject

@property id<AudioWriter> audioWriter;

- (void) start;
- (void) stop;

@end

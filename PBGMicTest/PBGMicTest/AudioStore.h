//
//  AudioStore.h
//  PBGMicTest
//
//  Created by 境 良太 on 2015/08/30.
//  Copyright (c) 2015年 PBGreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPipeline.h"

@interface AudioStore : NSObject <AudioReader, AudioWriter>

- (void) readFromFirst;
@end

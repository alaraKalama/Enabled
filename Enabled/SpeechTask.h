//
//  SpeechTask.h
//  Enabled
//
//  Created by Bianka on 2/6/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeechTask : NSObject

@property (strong, nonatomic) NSString *textToSpeak;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

-(id)init;
-(id)initWithText:(NSString*) text;
-(void)speakText:(NSString*)text;
-(void)speak;
@end

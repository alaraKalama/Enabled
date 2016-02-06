//
//  SpeechTask.m
//  Enabled
//
//  Created by Bianka on 2/6/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

#import "SpeechTask.h"
#import <AVFoundation/AVFoundation.h>

@implementation SpeechTask

@synthesize textToSpeak, synthesizer;

-(id) init{
    self = [super init];
    if(self) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return self;
}

-(id)initWithText:(NSString*) text {
    self = [super init];
    if (self) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        self.textToSpeak = text;
    }
    return self;
}

-(void)speakText:(NSString*)text {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.textToSpeak];
    //utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    [self.synthesizer speakUtterance:utterance];
}

-(void)speak {
    if(self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:self.textToSpeak];
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        NSLog(@"%@", utterance);
        [self.synthesizer speakUtterance:utterance];
    }
}
@end

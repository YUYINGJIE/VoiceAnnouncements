//
//  NotificationService.m
//  Voice
//
//  Created by huahaniOSCode on 2019/1/14.
//  Copyright © 2019年 HuaHan. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
   // self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    NSDictionary*dataDic = self.bestAttemptContent.userInfo;
     [self playMsg:dataDic[@"aps"][@"alert"]];

    NSLog(@"-----%@------%@--",dataDic,self.bestAttemptContent);
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

//文字--语音播报
- (void)playMsg:(NSString *)msg
{
    //NSLog(@"语音播报：%@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //后台播报
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            //
            AVSpeechSynthesizer *avSpeech = [[AVSpeechSynthesizer alloc] init];
            AVSpeechUtterance *avSpeechterance = [AVSpeechUtterance speechUtteranceWithString:msg];
            AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//中文发音
            avSpeechterance.voice = voiceType;
            avSpeechterance.pitchMultiplier = 0.1;//声调
            avSpeechterance.volume = 1;//音量
            avSpeechterance.rate = 0.5;//语速
            avSpeechterance.pitchMultiplier = 1.1;
            [avSpeech speakUtterance:avSpeechterance];
        });
    });
}
//rate属性指定播放语音时的速率,最小值和最大值分别是AVSpeechUtteranceMinimumSpeechRate和AVSpeechUtteranceMaximumSpeechRate,(0- 1)
//pitchMultiplier属性设置声调,属性值介于0.5(低音调)~2.0(高音调)之间,
//postUtteranceDelay告诉synthesizer本句朗读结束后要延迟多少秒再接着朗读下一秒,对应的属性还有preUtteranceDelay
@end

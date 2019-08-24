//
//  MyopiaPlugin.m
//  Runner
//
//  Created by yeah017 on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "MyopiaPlugin.h"
#import "AudioToolbox/AudioToolbox.h"
#import "AppDelegate.h"

static NSString *const CHANNEL_NAME = @"com.myopia.flutter_myopia_ai/record";

@implementation MyopiaPlugin {
    FlutterResult _result;
    NSTimer *counterTimer;
    long _myTimerecord;
    bool _timerRunning;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    MyopiaPlugin* instance = [[MyopiaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)init {
    self = [super init];
    return self;
}

- (void)startTime {
    if (_timerRunning) return;
    if (counterTimer == nil) {
        _timerRunning = true;
        _myTimerecord = 0;
        counterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}

- (void)timerFired {
    if (_timerRunning) {
        _myTimerecord++;
        [AppDelegate updateTimer:[NSNumber numberWithLong:_myTimerecord]];
    }
}

- (void)stopTimer {
    _timerRunning = false;
}

- (void) continueTimer {
    _timerRunning = true;
}

- (void) endTimer {
    _timerRunning = false;
    if (counterTimer) {
        [counterTimer invalidate];
        counterTimer = nil;
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"startRecord" isEqualToString:call.method]) {
        
        [self startTime];
        result(@"Success");
        
    } else if ([@"stopRecord" isEqualToString:call.method]) {
        
        [self stopTimer];
        result(@"Success");
        
    } else if ([@"endRecord" isEqualToString:call.method]) {
        
        [self endTimer];
        result(@"Success");
        
    } else if ([@"continueRecord" isEqualToString:call.method]) {
        
        [self continueTimer];
        result(@"Success");
        
    } else if ([@"playVibrate" isEqualToString:call.method]) {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        result(@"Success");
        
    } else if ([@"hasLightSensor" isEqualToString:call.method]) {
        
        result(@(NO));
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end


//
//  SettingsPlugin.m
//  Runner
//
//  Created by yeah017 on 2019/8/23.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsPlugin.h"

static NSString *const CHANNEL_NAME = @"com.myopia.flutter_myopia_ai/settings";

@implementation SettingsPlugin {
    FlutterResult _result;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    SettingsPlugin* instance = [[SettingsPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (id)init {
    self = [super init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"rateUs" isEqualToString:call.method]) {
        [self rateUs];
        result(@"Success");
    } else if ([@"checkUpdate" isEqualToString:call.method]) {
        [self rateUs];
        result(@"Success");
    } else if ([@"feedback" isEqualToString:call.method]) {
        [self sendEmail];
        result(@"Success");
    }
}

- (void)rateUs {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"MyoipiAIAppId"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (void)sendEmail {
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    
    NSArray *toRecipients = @[@"myopiai.tech@gmail.com"];
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow(CFBridgingRetain(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *subject = [NSString stringWithFormat:@"?subject=[Version: %@]MyopiAI Feedback", app_Version];
    [mailUrl appendString:subject];
    
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
}

@end

//
//  MyopiaToFlutterPlugin.m
//  Runner
//
//  Created by yeah017 on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyopiaToFlutterPlugin.h"

@implementation MyopiaToFlutterPlugin{
    
}

+ (MyopiaToFlutterPlugin* _Nullable)registChannel:(NSString*)name binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    FlutterEventChannel* chargingChannel = [FlutterEventChannel
                                            eventChannelWithName:name
                                            binaryMessenger:messenger];
    MyopiaToFlutterPlugin* instance = [[MyopiaToFlutterPlugin alloc] init];
    [chargingChannel setStreamHandler:instance];
    return instance;
}

- (id)init {
    self = [super init];
    return self;
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

@end

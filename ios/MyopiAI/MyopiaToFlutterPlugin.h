//
//  MyopiaToFlutterPlugin.h
//  Runner
//
//  Created by yeah017 on 2019/8/22.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
#import <Flutter/Flutter.h>

@interface MyopiaToFlutterPlugin : NSObject<FlutterStreamHandler>

@property(strong, nonatomic) FlutterEventSink _Nullable eventSink;

+ (MyopiaToFlutterPlugin* _Nullable)registChannel:(NSString*_Nonnull)name binaryMessenger:(NSObject<FlutterBinaryMessenger>*_Nonnull)messenger;
@end

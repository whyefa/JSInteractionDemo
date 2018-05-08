//
//  JSObject.h
//  Demo
//
//  Created by dow-np-162 on 2018/5/3.
//  Copyright © 2018年 yefa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

//添加了JSExport协议的协议，所规定的方法变量等，就会对js开放，我们可以通过js调用到
@protocol MyExport<JSExport>
    
    // 对应 js 调用 function share
- (void)share;
    // 对应 js 调用 function   shareWeb('参数 a', '参数 b')
- (void)shareWeb:(NSDictionary *)webInfo :(NSString *)platform;
    // 对应 js 调用 function name  shareImagePlatform('参数 a', '参数 b')
- (void)shareImage:(NSDictionary *)imageInfo Platform:(NSString *)platform;

@end

@interface JSObject : NSObject<MyExport>

@end

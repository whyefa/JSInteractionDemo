
//
//  JSObject.m
//  Demo
//
//  Created by dow-np-162 on 2018/5/3.
//  Copyright © 2018年 yefa. All rights reserved.
//

#import "JSObject.h"
#import <UIKit/UIKit.h>


@implementation JSObject
    
- (void)share {
    NSLog(@"JS 调用了 share 方法");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"通过 JSExport 调用原生方法" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    });
}
    
- (void)shareWeb:(NSDictionary *)webInfo :(NSString *)platform {
    NSLog(@"webInfo: %@ \n platform: %@", [webInfo description], platform);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"通过 JSExport 调用原生 多参数方法" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    });
    
}
    
- (void)shareImage:(NSDictionary *)imageInfo Platform:(NSString *)platform {
    NSLog(@"imageInfo: %@ \n platform: %@", [imageInfo description], platform);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"通过 JSExport 调用原生 多参数方法" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    });
}
    
    @end

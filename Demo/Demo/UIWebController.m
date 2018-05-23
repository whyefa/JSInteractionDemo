//
//  UIWebController.m
//  Demo
//
//  Created by dow-np-162 on 2018/5/3.
//  Copyright © 2018年 yefa. All rights reserved.
//  

#import "UIWebController.h"

#import "JSObject.h"

@interface UIWebController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * web;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, assign) int a;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation UIWebController

#pragma mark - LifeCycle
- (void)dealloc {
    NSLog(@"UIWebController dealloc");
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setSubViews];
}

#pragma mark - UI

-  (void)setSubViews {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.web];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ui.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
}

#pragma mark - CustomerDelegate

#pragma mark - webview Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak UIWebController *weakSelf = self;
    
    self.jsContext[@"login"] = ^(){
        [weakSelf login];
    };
    
    self.jsContext[@"native"] = [[JSObject alloc] init];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"请求地址 : %@",request.URL.absoluteString);
    NSString *requestString = request.URL.absoluteString;
    
    //  iframe
    NSArray *components = [requestString componentsSeparatedByString:@"/"];
    if ([components count] > 2 ) {//过滤请求是否是我们需要的.不需要的请求不进入条件
        NSString *lastComponent = [components lastObject];
        NSArray *cmd = [lastComponent componentsSeparatedByString:@"?"];
        NSString *func = [cmd firstObject];
        
        if ([func isEqualToString:@"load"]) {
            [self load];
            return NO;
        }
    }
    
    // document.location
    NSArray *components2 = [requestString componentsSeparatedByString:@":"];//提交请求时候分割参数的分隔符
    if ([components2 count] > 1 && [(NSString *)[components2 objectAtIndex:0]isEqualToString:@"iosapp"]) {
        //过滤请求是否是我们需要的.不需要的请求不进入条件
        if([(NSString *)[components2 objectAtIndex:1]isEqualToString:@"setData"])
        {
            [self setData:[components2 objectAtIndex:2]];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - Private
- (void)load {
    NSLog(@"JS 通过 iframe 调用原生 load 方法");
    [self showAlertWithTitle:@"通过iframe调用原生 load 方法"];
}

- (void)setData:(NSString *)aData {
    NSLog(@"JS 调用了 setData 方法");
    [self showAlertWithTitle:@"通过 document.location 调用原生 setData 方法"];
}

- (void)login {
    NSLog(@"JS 调用了 login 方法");
    [self showAlertWithTitle:@"通过JSContext调用原生 login 方法"];
}

- (void)callJS {
    _a += 1;
    if (_a == 1) {
        [self.web stringByEvaluatingJavaScriptFromString:@"alertText('Hello world')"];
    } else if(_a == 2) {
        JSValue *callBack = self.jsContext[@"alertText"];
        [callBack callWithArguments:@[@"Hello JSValue"]];
    } else if (_a == 3) {
        [self.jsContext evaluateScript:@"alertText('Hello JSContext')"];
        _a = 0;
    }
}
    
- (void)showAlertWithTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

#pragma mark - Getter && Setter
- (UIWebView *)web {
    if(!_web) {
        _web = [[UIWebView alloc] initWithFrame:self.view.frame];
        _web.delegate = self;
    }
    return _web;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"调用 JS" style:UIBarButtonItemStylePlain target:self action:@selector(callJS)];
        
    }
    return _rightItem;
}

@end

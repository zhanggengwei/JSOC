//
//  ViewController.m
//  JSOC
//
//  Created by Donald on 16/12/23.
//  Copyright © 2016年 Susu. All rights reserved.
//

/*
 oc  js 交互的问题
*/

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView  = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self loadFileName:@"html2"];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)loadFileName:(NSString *)fileName
{
    NSString * path = [[NSBundle mainBundle]pathForResource:fileName ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
- (void)jsClick {
    [self.webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function myFunction() { "   //定义myFunction方法
     "var field = document.getElementsByName('word')[0];"
     "field.value='WWDC2014';"
     "document.forms[0].submit();"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];  //添加到head标签中
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadUrl:(NSString *)urlStr {
    NSLog(@"接收到参数: %@", urlStr);
    
    //跳转到指定的URL--->urlStr
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", urlStr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString); //可以直接拿到发送请求的网址
    NSString *urlStr = request.URL.absoluteString;
    
    // 格式 neng://loadUrl/blog.csdn.net  协议/方法/网址
    //判断链接中的协议头,如果是neng://, 则进行相关操作
    if ([urlStr hasPrefix:@"neng://"]) {
        //拿到除去协议头的后部
        NSString *urlContent = [urlStr substringFromIndex:[@"neng://" length]];
        NSLog(@"%@", urlContent);
        
        //用/来拆分字符串
        NSArray *urls = [urlContent componentsSeparatedByString:@"/"];
        NSLog(@"拆分的结果为:%@", urls);
        
        //取出方法名
        if (urls.count != 2) {
            return NO;
        }
        NSString *funName = [NSString stringWithFormat:@"%@:", urls[0]]; //带参数的方法,加冒号
        
        SEL callFun = NSSelectorFromString(funName);
        //取消警告
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:callFun withObject:urls[1]]; //将blog.csdn.net作为参数传入
# pragma clang diagnostic pop
        NSLog(@"方法名为%@, 传入参数为%@", funName, urls[1]);
        
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end

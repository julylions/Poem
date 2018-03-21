//
//  YMWebController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMWebController.h"
#import <WebKit/WebKit.h>


@interface YMWebController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation YMWebController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _progressLayer = [YMWebProgressLayer new];
    _progressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
    [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    //加载界面
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit = YES;
    if([self.urlStr hasPrefix:@"http"]){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }else{
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //同意用户协议
    if (self.agreeBlock) {
        self.agreeBlock(@"1");
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DDLog(@"开始加载数据 request == %@",request);
    NSString *completeString = [request.URL absoluteString];
    //第一步:检测链接中的特殊字段
    NSString *needCheckStr = @"https://dk.youmeng.com/Msg/zmxy";
    NSRange jumpRange = [completeString rangeOfString:needCheckStr];
    if (jumpRange.location != NSNotFound) {
        /*
         1.检测到链接中包含有特殊字段，客户端要接受响应并做后续处理
         这就相当于js调起了iOS，
         2.在真实的使用时，客户端需要和h5协调，双方需要统一监听的字段
         3.参数问题：如果此时的交互需要传递参数，参数也可以放在链接里，
         同样通过识别字符串的方法来获取
         */
        //第二步：拿到链接字符串的后续部分，然后分割字符串得到参数数据
        //        NSMutableString *linkmStr = [NSMutableString stringWithString:completeString];
        //        NSRange deleteRange = {0,needCheckStr.length};
        //        [linkmStr deleteCharactersInRange:deleteRange];
        //        NSArray *params = [linkmStr componentsSeparatedByString:@"&&"];
        //        //取出第一个参数：与h5协商好的方法名
        //        NSString *funcName = [params[0] componentsSeparatedByString:@"="][1];
        //        //取出第二个参数：信息字符串
        //        NSString *info = [params[1] componentsSeparatedByString:@"="][1];
        //
        //第三步：调起ios原生方法
        //        SEL ocFunc = NSSelectorFromString(funcName);
        //        if ([self respondsToSelector:ocFunc]) {
        //            //使用编译预处理，不显示警告提示
        //#pragma clang diagnostic push
        //#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        //            [self performSelector:ocFunc withObject:info];
        //#pragma clang diagnostic pop
        //
        //        }
        
        [self ocFunc];
        //
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    DDLog(@"开始加载数据");
    [_progressLayer startLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_progressLayer finishedLoad];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}
- (void)dealloc {
    [_progressLayer closeTimer];
    [_progressLayer removeFromSuperlayer];
    _progressLayer = nil;
    DDLog(@"i am dealloc");
}
-(void)ocFunc{
    DDLog(@"执行了监听");
    //返回NO是为了不再执行点击原链接的跳转
    [MBProgressHUD showSuccess:@"芝麻信用授权成功！" view:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.agreeBlock) {
            self.agreeBlock(@"1");
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}


@end

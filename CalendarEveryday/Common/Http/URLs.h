//
//  URLs.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef URLs_h
#define URLs_h


#define SUCCESS         @"200"
#define FAILURE         @"0"
#define TOKEN_TIMEOUT   @"-999999"
#define FAILURE_TOKEN   @"API_FAILURE_TOKEN"

#define Version          [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]

#define  BaseApi         @"http://zm.youmeng.com/Calendar/" //@"http://apiyzt.youmeng.com/"  //

//请求首页数据
#define HomeDataURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Index/getIndexList"]
//获取新闻导航菜单
#define NewsHeadListURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"News/getTableList"]
//获取新闻
#define  NewsListURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"News/getNewsList"]
//获取宜忌
#define  AlmanacURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Almanac/getAlmanac"]


//
#define MessageReadURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/message_read"]

#endif /* URLs_h */

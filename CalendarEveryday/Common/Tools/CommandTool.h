//
//  CommandTool.h
//  jikedai
//
//  Created by jikedai on 2018/1/2.
//  Copyright © 2018年 jikedai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandTool : NSObject

@property (nonatomic, strong)RACCommand *command_Audit; // 检查是否审核
//@property (nonatomic, strong)RACCommand *command_getIdCard; // 获取实名信息
//@property (nonatomic, strong)RACCommand *command_getInformation;// 获取消息列表
//@property (nonatomic, strong)RACCommand *command_getRecommendProduct;// 获取推荐贷款列表
//@property (nonatomic, strong)RACCommand *command_getRecommendCreditCard;// 获取推荐信用卡数据
//
//@property (nonatomic, strong)RACCommand *command_haveNewVersion; // 检查新版本
//@property (nonatomic, strong)RACCommand *command_startAdURL; // 获取广告
//
//@property (nonatomic, strong)RACCommand *command_updateEvent;// 上传点击产品信息信息到后台
//@property (nonatomic, strong)RACCommand *command_getCodeImage;// 获取图形验证码

@end

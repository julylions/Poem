//
//  FileManager.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath;

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string;

//将字符串数组按照元素首字母顺序进行排序分组
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array;


@end

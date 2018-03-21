//
//  UIImage+Extension.h
//  HappyToSend
//
//  Created by rujia chen on 15/9/15.


#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)imageWithColor:(UIColor *)color;

+(UIImage *)originarImageNamed:(NSString *)name ;

+(UIImage *)hk_originarImageNamed:(NSString *)name NS_DEPRECATED_IOS(2_0, 3_0,"哥么过期了,用hk_方法") __TVOS_PROHIBITED;

-(UIImage *)hk_resizableImage;

/**
 *  圆型图片
 */
-(UIImage *)circleImage;

/** 取消searchBar背景色 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;
//根据图片的尺寸 和屏幕的 尺寸 和 比例 ，得到新的 压缩 size  屏幕一般大小
+ (CGSize )comressSizeByImage:(UIImage* )image ;
//图片的二进制数据
+ (NSData* )imgDataByImage:(UIImage* )image;

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

//全屏截图
+ (UIImage *)shotScreen;

#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;
#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;
//调整图片饱和度、亮度、对比度
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;
@end

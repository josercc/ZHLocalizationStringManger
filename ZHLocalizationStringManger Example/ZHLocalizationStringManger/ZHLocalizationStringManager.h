//
//  RGLocalizationString.h
//  Yoshop
//
//  Created by 张行 on 16/5/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHLocalizationStringConfiguration;

FOUNDATION_EXTERN NSString *const ZHLocalizationStringDidChanged; //语言切换的通知
// 管理国际化的类
@interface ZHLocalizationStringManager : NSObject
/**
 * 获取工程支持的多语言的数组
 */
@property (nonatomic, strong,readonly) NSArray *localizableNames;
/**
 * 默认的语言 默认为英语
 */
@property (nonatomic, copy) NSString *nomarLocalizable;
/**
 * 是否支持APP内部进行切换语言 默认支持 强行设置nomarLocalizable 属性会退出程序
 */
@property (nonatomic, assign) BOOL isSuppoutAppSettingLocalizable;
/**
 * 用户自己设置的语言代码 和nomarLocalizable不同的是 nomarLocalizable如果设置的不支持就切换成基础语言baseLocalizeable(用于后台)
 */
@property (nonatomic, copy, readonly) NSString *userCustomLanguageCode;

/**
 * 初始化基础语言 默认为 en

 @param baseLocalizeable 基础语言
 */
+ (void)setupBaseLocalizeable:(NSString *)baseLocalizeable __deprecated_msg("使用 setupConfigurationBlock:方法初始化");

/**
 * 对工具进行初始化

 @return ZHLocalizationStringManager
 */
+ (instancetype)shareLocalizable; //对类初始化单例

- (instancetype)initWithCustomConfiguration:(nullable ZHLocalizationStringConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 初始化配置

 @param configurationBlock 自定义配置回调
 */
+ (void)setupConfigurationBlock:(void(^)(ZHLocalizationStringConfiguration *configuration))configurationBlock;

/**
 * 根据键值对设置的语言进行取值 如果设置的语言存在对应值就返回 不存在就返回 key

 @param translationKey 取值的 key
 @return NSString
 */
- (NSString *)localizedString:(NSString *)translationKey;

/**
 * 根据键值对设置的语言进行取值 如果设置了语言存在就返回对应的值 不存在就返回默认值

 @param translationKey 取值的 key
 @param comment 默认值
 @return NSString
 */
- (NSString *)localizedString:(NSString *)translationKey comment:(NSString *)comment;


@end


@interface ZHLocalizationStringConfiguration : NSObject

/**
 lproj文件夹所在的目录 默认为 MainBundle
 */
@property (nonatomic, strong) NSBundle *lprojBundle;

/**
 基本的语言编码 默认英语
 */
@property (nonatomic, copy) NSString *baseLocalizeable;

@end

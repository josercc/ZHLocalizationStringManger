//
//  RGLocalizationString.h
//  Yoshop
//
//  Created by 张行 on 16/5/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#undef NSLocalizedString
#define NSLocalizedString(key,comment) [[ZHLocalizationStringManger shareLocalizable]localizedString:key]

FOUNDATION_EXTERN NSString *const YSLocalizationStringDidChanged; //语言切换的通知
@interface ZHLocalizationStringManger : NSObject // 管理国际化的类
@property (nonatomic, strong,readonly) NSArray *localizableNames; //获取工程支持的多语言的数组
@property (nonatomic, copy) NSString *nomarLocalizable;// 默认的语言 默认为英语
@property (nonatomic, assign) BOOL isSuppoutAppSettingLocalizable; // 是否支持APP内部进行切换语言 默认不支持 强行设置nomarLocalizable 属性会退出程序
+(instancetype)shareLocalizable; //对类初始化单例
-(NSString *)localizedString:(NSString *)translationKey; // 用NSLocalizedString宏进行调用国际化
@end


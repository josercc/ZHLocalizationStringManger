//
//  RGLocalizationString.m
//  Yoshop
//
//  Created by 张行 on 16/5/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZHLocalizationStringManger.h"
#import <objc/runtime.h>

NSString *const ZHLocalizationStringDidChanged = @"YSLocalizationStringDidChanged";

NSString *const KLocalizableSetting = @"KLocalizableSetting"; // 本地储存的国际化设置

static NSString *ZHBaseLocalizeable = @"en"; // 静态储存基础语言 默认为 en

@implementation ZHLocalizationStringManger {
    NSString *_currentLocalizable;
    NSString *_userCustomLanguageCode;
}

@synthesize localizableNames = _localizableNames;

+ (instancetype)shareLocalizable {
   static ZHLocalizationStringManger *localizable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizable = [[ZHLocalizationStringManger alloc]init];
    });
    return localizable;
}

- (instancetype)init {
    if (self = [super init]) {
        [self getlocalizableNames];
        [self settingParment];
    }
    return self;
}

+ (void)setupBaseLocalizeable:(NSString *)baseLocalizeable {
    ZHBaseLocalizeable = baseLocalizeable;
}

- (void)settingParment{
    /// 是否本地存在设置的语言
    if (![self isExitLocalLocalizable]) {
        // 不存在取默认的基础语言
        _nomarLocalizable = ZHBaseLocalizeable;
    } else {
        // 存在取本地储存的语言
        _nomarLocalizable = [[NSUserDefaults standardUserDefaults] objectForKey:KLocalizableSetting];
        /// 如果设置的不支持 取默认语言
        if (![self currentLocalizable:_nomarLocalizable]) {
            _nomarLocalizable = ZHBaseLocalizeable;
        }
    }
}

- (void)setNomarLocalizable:(NSString *)nomarLocalizable {
    _userCustomLanguageCode = nomarLocalizable;
    // 设置的语言是否支持 不支持恢复默认语言
    if (![self currentLocalizable:nomarLocalizable]) {
        nomarLocalizable = ZHBaseLocalizeable;
    }
    _nomarLocalizable = nomarLocalizable;
    [[NSUserDefaults standardUserDefaults] setObject:nomarLocalizable forKey:KLocalizableSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 如果支持系统设置语言就发通知 否则就退出
    if(self.isSuppoutAppSettingLocalizable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ZHLocalizationStringDidChanged object:nil];
    }else {
        exit(0);
    }
}

- (NSString *)localizedString:(NSString *)translationKey {
    return [self localizedString:translationKey comment:translationKey];
}

- (NSString *)localizedString:(NSString *)translationKey comment:(NSString *)comment{
    
    NSBundle *languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:_nomarLocalizable ofType:@"lproj"]];
    // 获取语言表里面的对应字段
    NSString * s = NSLocalizedStringFromTableInBundle(translationKey, nil, languageBundle, comment);
    if ([s isEqualToString:translationKey] || s.length == 0) {
        // 如果列表没有对应的值 或者取出来为空 就取 comment
        s = comment;
    }
    s = s ?: translationKey; // 如果comment也没有就用原值
    return s;
}

/**
 * 获取本地所有支持多语言的数组
 */
- (void)getlocalizableNames{
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"lproj" inDirectory:nil];
    NSMutableArray *filltArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [obj stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].resourcePath] withString:@""];
        obj =[obj stringByReplacingOccurrencesOfString:@".lproj" withString:@""];
        [filltArray addObject:obj];
    }];
    _localizableNames = filltArray;
}

/**
 * 判断语言是否被支持国际化 如果是 YES 代表支持 如果是 NO 代表不支持

 @param locallizable 判断的语言简码
 @return BOOL
 */
- (BOOL)currentLocalizable:(NSString *)locallizable{
   __block BOOL isExit = NO;
    [_localizableNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:locallizable]) {
            isExit = YES;
            *stop = YES;
        }
    }];
    return isExit;
}

- (BOOL)isExitLocalLocalizable {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:KLocalizableSetting] ? YES : NO;
}

- (NSString *)userCustomLanguageCode {
    return _userCustomLanguageCode ?: ZHBaseLocalizeable;
}

@end


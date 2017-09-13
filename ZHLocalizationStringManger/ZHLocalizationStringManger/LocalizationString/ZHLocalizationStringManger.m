//
//  RGLocalizationString.m
//  Yoshop
//
//  Created by 张行 on 16/5/27.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZHLocalizationStringManger.h"
#import <objc/runtime.h>

NSString *const YSLocalizationStringDidChanged = @"YSLocalizationStringDidChanged";
NSString *const KLocalizableSetting = @"KLocalizableSetting";


static NSString *ZHBaseLocalizeable = @"en"; // 静态储存基础语言

@implementation ZHLocalizationStringManger {
    NSString *_currentLocalizable;
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
    }
}

- (void)setNomarLocalizable:(NSString *)nomarLocalizable {
    // 设置的语言是否支持 不支持恢复默认语言
    if (![self currentLocalizable:nomarLocalizable]) {
        nomarLocalizable = ZHBaseLocalizeable;
    }
    _nomarLocalizable = nomarLocalizable;
    [[NSUserDefaults standardUserDefaults] setObject:nomarLocalizable forKey:KLocalizableSetting];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // 如果支持系统设置语言就发通知 否则就退出
    if(self.isSuppoutAppSettingLocalizable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YSLocalizationStringDidChanged object:nil];
    }else {
        exit(0);
    }
}

- (NSString *)localizedString:(NSString *)translationKey {
    return [self localizedString:translationKey comment:translationKey];
}

- (NSString *)localizedString:(NSString *)translationKey comment:(NSString *)comment{
    // 获取语言表里面的对应字段
    NSString * s = NSLocalizedStringFromTable(translationKey, nil, comment);
    // 是否不存在当前语言 设置为系统的语言
    if (!_currentLocalizable) {
        _currentLocalizable = [[NSLocale preferredLanguages] objectAtIndex:0];
    }
    if (![self currentLocalizable:_currentLocalizable] || [self isExitLocalLocalizable]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:_nomarLocalizable ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translationKey value:translationKey table:nil];
    }
    s = s ?: comment;
    s = s ?: translationKey;
    return s;
}

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

- (BOOL)currentLocalizable:(NSString *)locallizable{
   __block BOOL isExit = NO;
    [_localizableNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj rangeOfString:locallizable].length !=NSNotFound) {
            isExit = YES;
            *stop = YES;
        }
    }];
    return isExit;
}

- (BOOL)isExitLocalLocalizable {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:KLocalizableSetting] ? YES:NO;
}

@end


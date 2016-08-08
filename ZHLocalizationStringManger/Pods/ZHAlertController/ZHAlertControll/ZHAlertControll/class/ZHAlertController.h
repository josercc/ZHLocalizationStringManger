//
//  ZHAlertController.h
//  HuiXin
//
//  Created by 张行 on 15/11/10.
//  Copyright © 2015年 惠卡世纪. All rights reserved.
//

/*
 example1:
 如果只想提示错误信息
 ZHAlertControllerShow(text,controller) text代表错误信息 controller代表所在的UIViewController
 example2:
 只想有标题 详情信息 并且按钮最多两个的可以这个 不用实现代理方法
 [[ZHAlertController   alertControllerWithTitle:(NSString *)title
                     message:(NSString *)message
                     delegate:(id<ZHAlertControllerDelegate>)delegate
                     cannelButton:(NSString *)cannelButton
                     otherButton:(NSString *)otherButton]showInController:controller]
 
 example3:
 如果带有输入框 多个按钮 或者是UIActionSheet
 [[ZHAlertController alloc]initWithdDelegate:(id<ZHAlertControllerDelegate>)delegate
                          type:(ZHAlertControllerType)type
                          title:(NSString *)title
                          message:(NSString *)message]showInController:controller]
 
 
 
 */

#import <UIKit/UIKit.h>

@protocol ZHAlertControllerDelegate;

typedef NS_ENUM(NSUInteger,ZHAlertControllerType) {

    ZHAlertControllerTypeAlertView,
    ZHAlertControllerTypeActionSheet
};

///封装系统的UIAlertView UIActionSheet
@interface ZHAlertController : NSObject

- (instancetype)initWithdDelegate:(id<ZHAlertControllerDelegate>)delegate
                             type:(ZHAlertControllerType)type
                            title:(NSString *)title
                          message:(NSString *)message;

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                                delegate:(id<ZHAlertControllerDelegate>)delegate
                            cannelButton:(NSString *)cannelButton
                             otherButton:(NSString *)otherButton;


@property (nonatomic, assign) UIAlertViewStyle alertViewStyle;
@property (nonatomic, assign) UIActionSheetStyle actionSheetStyle;

@property (nonatomic, assign,readonly) ZHAlertControllerType type;

- (void)showInController:(UIViewController *)controller;

@end

@protocol ZHAlertControllerDelegate <NSObject>
@required
- (NSArray<NSString *> *)buttonNamesWithAlertController:(ZHAlertController *)alertController;

@optional
- (NSUInteger)textFiledsWithAlertController:(ZHAlertController *)alertController;

- (void)alertControllerDidSelectButtonIndex:(NSUInteger)buttonIndex;

@end

@interface UIAlertAction (Tag)
@property (nonatomic, assign) NSUInteger tag;
@end

NS_INLINE void
ZHArrayAddObject(id object,NSMutableArray *array) {

    if (object)
    [array addObject:object];
    
}

NS_INLINE BOOL ISIOS8()
{

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        return YES;
    }
    return NO;
}
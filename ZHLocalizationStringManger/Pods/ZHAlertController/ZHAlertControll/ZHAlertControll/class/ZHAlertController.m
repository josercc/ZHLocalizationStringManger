//
//  ZHAlertController.m
//  HuiXin
//
//  Created by 张行 on 15/11/10.
//  Copyright © 2015年 惠卡世纪. All rights reserved.
//

#import "ZHAlertController.h"
#import <objc/runtime.h>

@interface ZHAlertController ()<UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSArray<NSString *> *buttonArray;
@end
@implementation ZHAlertController {

    id<ZHAlertControllerDelegate> _delegate;
    ZHAlertControllerType _type;
    NSString *_title;
    NSString *_message;
    UIAlertView *_alertView;
    UIActionSheet *_actionSheet;
    UIAlertController *_alertController;
    NSArray *_buttonArray;
    NSUInteger _textFiledNumber;
}

-(instancetype)initWithdDelegate:(id<ZHAlertControllerDelegate>)delegate
                            type:(ZHAlertControllerType)type
                           title:(NSString *)title
                         message:(NSString *)message {

    NSAssert(title, @"title connot nil");
    NSAssert(message, @"message connot nil");
    _delegate = delegate;
    _type = type;
    _title = title;
    _message = message;
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

-(instancetype)initWithdDelegate:(id<ZHAlertControllerDelegate>)delegate
                            type:(ZHAlertControllerType)type
                           title:(NSString *)title
                         message:(NSString *)message
                          buttons:(NSArray *)buttons{
    
    NSAssert(title, @"title connot nil");
    NSAssert(message, @"message connot nil");
    _delegate = delegate;
    _type = type;
    _title = title;
    _message = message;
    self = [super init];
    if (self) {
        self.buttonArray = buttons;
        [self _init];
    }
    return self;
}

+(instancetype)alertControllerWithTitle:(NSString *)title
                                message:(NSString *)message
                               delegate:(id<ZHAlertControllerDelegate>)delegate
                           cannelButton:(NSString *)cannelButton
                            otherButton:(NSString *)otherButton {
    
    NSMutableArray *buttons = [NSMutableArray array];
    ZHArrayAddObject(otherButton, buttons);
    ZHArrayAddObject(cannelButton, buttons);
    ZHAlertController *alertController = [[ZHAlertController alloc]
                                          initWithdDelegate:delegate
                                          type:ZHAlertControllerTypeAlertView
                                          title:title
                                          message:message
                                          buttons:buttons];
    return alertController;

}
-(ZHAlertControllerType)type {

    return _type;
}
- (void)_init {

    
    if (!self.buttonArray) {
        self.buttonArray = [_delegate buttonNamesWithAlertController:self];
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(textFiledsWithAlertController:)]) {
        _textFiledNumber = [_delegate textFiledsWithAlertController:self];
    }
    if (_type == ZHAlertControllerTypeAlertView) {
        [self _initAlertView];
    }else {
        [self _initAlertSheet];
    }
}

- (void)_initAlertView {
    
    
    
    if (ISIOS8()) {
        
        _alertController = [UIAlertController
                                              alertControllerWithTitle:_title
                                              message:_message
                                              preferredStyle:UIAlertControllerStyleAlert];
        for (NSUInteger i = 0 ; i<_buttonArray.count; i ++) {
            UIAlertActionStyle style = UIAlertActionStyleDefault;
            if (i == _buttonArray.count - 1) {
                style = UIAlertActionStyleCancel;
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle:_buttonArray[i]
                                                   style:style
            handler:^(UIAlertAction * _Nonnull action) {
                [self didSelectButtonAtIndex:action.tag];
            }];
            action.tag = i;
            [_alertController addAction:action];
        }
        
        for (NSUInteger i = 0; i< _textFiledNumber; i++) {
            [_alertController addTextFieldWithConfigurationHandler:nil];
        }
        
    }else {
    
        _alertView = [[UIAlertView alloc]init];
        _alertView.delegate = self;
        _alertView.title = _title;
        _alertView.message = _message;
        for (NSUInteger i = 0 ; i<_buttonArray.count; i ++) {
            [_alertView addButtonWithTitle:_buttonArray[i]];
        }
        _alertView.cancelButtonIndex = _buttonArray.count-1;
        _alertView.alertViewStyle = self.alertViewStyle;
    
    }

}
- (void)_initAlertSheet {

    if (ISIOS8()) {
        
        _alertController = [UIAlertController
                            alertControllerWithTitle:_title
                            message:_message
                            preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSUInteger i = 0 ; i<_buttonArray.count; i ++) {
            UIAlertActionStyle style = UIAlertActionStyleDefault;
            if (i == _buttonArray.count - 1) {
                style = UIAlertActionStyleCancel;
            }
            __weak typeof(self) weakSelf = self;
            UIAlertAction *action = [UIAlertAction actionWithTitle:_buttonArray[i]
                                                             style:style
                                                           handler:
            ^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                 [strongSelf didSelectButtonAtIndex:action.tag];
            }];
            action.tag = i;
            [_alertController addAction:action];
            for (NSUInteger i = 0; i< _textFiledNumber; i++) {
                [_alertController addTextFieldWithConfigurationHandler:nil];
            }
        }
        
    }else {
        
        _actionSheet = [[UIActionSheet alloc]init];
        _actionSheet.title = _title;
        _actionSheet.delegate = self;
        for (NSUInteger i = 0 ; i<_buttonArray.count; i ++) {
            [_actionSheet addButtonWithTitle:_buttonArray[i]];
        }
        _actionSheet.cancelButtonIndex = _buttonArray.count-1;
        _actionSheet.actionSheetStyle = self.actionSheetStyle;
        
    }

}

-(void)showInController:(UIViewController *)controller {

    if (_alertController) {
        [controller presentViewController:_alertController animated:YES completion:nil];
    }else {
    
        if (_type == ZHAlertControllerTypeAlertView) {
            [_alertView show];
        }else {
            [_actionSheet showInView:controller.view];
        }
    }
    
}

- (void)didSelectButtonAtIndex:(NSUInteger)buttonIndex {

    if (_delegate && [_delegate respondsToSelector:@selector(alertControllerDidSelectButtonIndex:)]) {
        [_delegate alertControllerDidSelectButtonIndex:buttonIndex];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self didSelectButtonAtIndex:buttonIndex];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self didSelectButtonAtIndex:buttonIndex];
    
}

@end

@implementation UIAlertAction (Tag)

-(void)setTag:(NSUInteger)tag {
    objc_setAssociatedObject(self, @selector(tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSUInteger)tag {
    return [objc_getAssociatedObject(self, @selector(tag)) unsignedIntegerValue];
}
@end

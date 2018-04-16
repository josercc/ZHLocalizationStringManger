//
//  ViewController.m
//  ZHLocalizationStringManager
//
//  Created by 张行 on 16/8/8.
//  Copyright © 2016年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHLocalizationStringManager.h"
#import <ZHAlertController/ZHAlertController.h>
@interface ViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewController {
    NSArray *_localizationStrings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [NSString stringWithFormat:@"Current Localization:%@  -  %@",[ZHLocalizationStringManager shareLocalizable].nomarLocalizable,NSLocalizedString(@"Hello", @"HELLO")];
//    self.titleLabel.text = @"dssaddsa";


    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)changeLocalization:(id)sender {

    _localizationStrings = [ZHLocalizationStringManager shareLocalizable].localizableNames;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.title = @"Localization List";
    [actionSheet addButtonWithTitle:@"Cannel"];
    for (int i = 0; i < _localizationStrings.count; i ++) {
        [actionSheet addButtonWithTitle:_localizationStrings[i]];
    }
    actionSheet.delegate = self;
    actionSheet.cancelButtonIndex = 0;
    [actionSheet showInView:self.view];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [ZHLocalizationStringManager shareLocalizable].nomarLocalizable = _localizationStrings[buttonIndex - 1];
}

@end

//
//  ViewController.m
//  JFEncrypt
//
//  Created by JiangfanZhan on 2017/2/4.
//  Copyright © 2017年 Jeffrey. All rights reserved.
//

#import "ViewController.h"
#import "JFDESEncrypt.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *plainTextField;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 * 加密按钮
 * @param sender 按钮对象
 */
- (IBAction)encrypt:(id)sender {
    
    [self encryptMyText];
}

//加密明文
- (void)encryptMyText{
    
    if (_plainTextField.text.length) {
        
        _cipherTextField.text = [JFDESEncrypt encrypt:_plainTextField.text key:KDESEncryptKey];
        return;
    }
    
    [self showStandardAlertViewWithMsg:@"请输入待加密的明文" WithTitle:@"提示"];
}

//显示 AlertView
- (void)showStandardAlertViewWithMsg:(NSString *)msg WithTitle:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, nil)
                                                                             message:NSLocalizedString(msg, nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          
                                                          
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}


@end

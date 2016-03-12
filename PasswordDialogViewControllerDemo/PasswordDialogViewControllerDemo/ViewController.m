//
//  ViewController.m
//  https://github.com/TakayoshiMiyamoto/PasswordDialogViewController.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import "ViewController.h"

#import "PasswordDialogViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pressShowPasswordDialogButton:(id)sender {
    // Master password
    NSString *password = @"test";
    
    PasswordDialogViewController *viewController;
    viewController = [[PasswordDialogViewController alloc] initWithPassword:password useSecureSwitch:YES];

    viewController.delegate = self;

    viewController.titleText = @"This is Title";
    viewController.messageText = @"This is message.This is message.This is message.This is message.This is message.";
    viewController.passwordPlaceholder = @"Enter Password";
    viewController.retypeMessageText = @"Please retype";

    viewController.retypeMessageTextColor = [UIColor redColor];
    
    [viewController show:^(BOOL isOK) {
        if (isOK) {
            NSLog(@"Succeed");
        }
        else {
            NSLog(@"Cancel");
        }
    }];
}

@end

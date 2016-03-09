//
//  PasswordDialogViewController.h
//  https://github.com/TakayoshiMiyamoto/PasswordDialogViewController.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordDialogViewController : UIViewController

@property (nonatomic, weak) id delegate;

// Text
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *retypeMessageText;
@property (nonatomic, copy) NSString *passwordPlaceholder;

// Color
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *messageTextColor;
@property (nonatomic, strong) UIColor *retypeMessageTextColor;
@property (nonatomic, strong) UIColor *bkColor;

@property (nonatomic, assign) BOOL useSecureSwitch;

@property (nonatomic, setter=setMasterPassword:) NSString *password;

- (instancetype)initWithPassword:(NSString *)password;
- (instancetype)initWithPassword:(NSString *)password useSecureSwitch:(BOOL)useSecureSwitch;

- (void)show:(void (^)(BOOL isOK))completion;
- (void)show:(void (^)(BOOL isOK))completion delegate:(__weak id)sender;

@end

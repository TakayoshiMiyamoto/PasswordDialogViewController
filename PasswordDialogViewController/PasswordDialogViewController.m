//
//  PasswordDialogViewController.m
//  https://github.com/TakayoshiMiyamoto/PasswordDialogViewController.git
//
//  Copyright (c) 2015 Takayoshi Miyamoto. All rights reserved.
//

#import "PasswordDialogViewController.h"

// Duration
static const CGFloat kShowDuration = .1f;
static const CGFloat kShakeDuration = .08f;

// Size
static const NSInteger kShakeWidth = 20;
static const NSInteger kMainViewWidth = 280;
static const NSInteger kMainViewHeight = 200;
static const NSInteger kPasswordFontSize = 16;
static const NSInteger kTextFieldMargin = 30;

// Completion block
typedef void (^completion)(BOOL isOK);
typedef void (^completionNoCheck)(NSString * pwd);

@interface PasswordDialogViewController()<UITextFieldDelegate>

@property (nonatomic, copy) completion completion;
@property (nonatomic, copy) completionNoCheck completionNoCheck;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UISwitch *secureSwitch;

@property (nonatomic, copy) NSString *masterPassword;

@end

@implementation PasswordDialogViewController {
    dispatch_once_t _onceToken;
}

#pragma mark - Lifecycle

- (instancetype)initWithPassword:(NSString *)password {
    self = [super init];
    if (!self) {
        return nil;
    }
    _masterPassword = password;
    return self;
}

- (instancetype)initWithPassword:(NSString *)password useSecureSwitch:(BOOL)useSecureSwitch {
    self = [super init];
    if (!self) {
        return nil;
    }
    _masterPassword = password;
    _useSecureSwitch = useSecureSwitch;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initialize];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_once(&_onceToken, ^(void) {
        [UIView animateWithDuration:kShowDuration animations:^(void) {
            _mainView.alpha = 1.f;
        } completion:nil];
    });
}

#pragma mark - Public instance methods

- (void)setMasterPassword:(NSString *)password {
    _masterPassword = password;
}

- (void)show:(void (^)(BOOL isOK))completion {
    if (![self delegate] || !_masterPassword) {
        completion(NO);
        return;
    }
    
    _completion = completion;
    [self showDialog];
}

-(void) showDialog{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;

    if ([UIViewController instancesRespondToSelector:@selector(modalPresentationStyle)]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [((UIViewController *)[self delegate]) presentViewController:self animated:NO completion:nil];
}

- (void)showNoCheck:(void (^)(NSString * pwd))completion delegate:(__weak id)sender{
    _delegate = sender;
    
    _completionNoCheck = completion;
    [self showDialog];
}

- (void)show:(void (^)(BOOL isOK))completion delegate:(__weak id)sender {
    _delegate = sender;
    
    [self show:completion];
}

#pragma mark - Private instance methods

- (void)_initialize {
    CGFloat textFieldWidth = kMainViewWidth - (kTextFieldMargin * 2);
    CGFloat textFieldHeight = 26;
    
    NSInteger viewMargin = 1;
    NSInteger buttonHeight = 50;
    
    NSInteger switchHeight = [self useSecureSwitch] ? 35 : 0;
    
    // Frames
    CGRect mainViewFrame = CGRectMake(0,
                                      0,
                                      kMainViewWidth,
                                      kMainViewHeight + switchHeight);
    CGRect topViewFrame = CGRectMake(0,
                                     0,
                                     kMainViewWidth,
                                     mainViewFrame.size.height - buttonHeight);
    CGRect leftViewFrame = CGRectMake(0,
                                      topViewFrame.size.height + viewMargin,
                                      (kMainViewWidth / 2) - (viewMargin / 2),
                                      buttonHeight - viewMargin);
    CGRect rightViewFrame = CGRectMake(leftViewFrame.size.width + viewMargin,
                                       topViewFrame.size.height + viewMargin,
                                       leftViewFrame.size.width,
                                       leftViewFrame.size.height);
    CGRect titleLabelFrame = CGRectMake(0,
                                        13,
                                        topViewFrame.size.width,
                                        28);
    CGRect messageLabelFrame = CGRectMake(10,
                                          13 + titleLabelFrame.size.height + 5,
                                          topViewFrame.size.width - 20, 50);
    CGRect textFieldFrame = CGRectMake(kTextFieldMargin,
                                       13 + titleLabelFrame.size.height + 5 + messageLabelFrame.size.height + 7,
                                       textFieldWidth,
                                       textFieldHeight);
    CGRect cancelButtonFrame = CGRectMake(0,
                                          0,
                                          leftViewFrame.size.width,
                                          leftViewFrame.size.height);
    CGRect okButtonFrame = CGRectMake(0,
                                      0,
                                      rightViewFrame.size.width,
                                      rightViewFrame.size.height);
    
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];

    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];
    mainView.backgroundColor = [PasswordDialogViewController colorFromHexString:@"#dddce1" alpha:0.8];
    mainView.center = self.view.center;
    mainView.layer.cornerRadius = 4;
    mainView.layer.masksToBounds = YES;
    mainView.alpha = 0;
    
    UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
    topView.backgroundColor = [self bkColor] ?
        [self bkColor] : [PasswordDialogViewController colorFromHexString:@"#ededed" alpha:.9];
    
    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
    leftView.backgroundColor = [self bkColor] ?
        [self bkColor] : [PasswordDialogViewController colorFromHexString:@"#ededed" alpha:.9];
    
    UIView *rightView = [[UIView alloc] initWithFrame:rightViewFrame];
    rightView.backgroundColor = [self bkColor] ?
        [self bkColor] : [PasswordDialogViewController colorFromHexString:@"#ededed" alpha:.9];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    if ([self titleText]) {
        titleLabel.text = [self titleText];
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [self titleTextColor] ? [self titleTextColor] : [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = NO;
    [topView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageLabelFrame];
    if ([self messageText]) {
        messageLabel.text = [self messageText];
    }
    messageLabel.font = [UIFont fontWithName:@"Arial" size:15];
    messageLabel.textColor = [self messageTextColor] ? [self messageTextColor] : [UIColor blackColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    messageLabel.numberOfLines = 2;
    messageLabel.adjustsFontSizeToFitWidth = NO;
    [topView addSubview:messageLabel];
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    passwordTextField.font = [UIFont fontWithName:@"Arial" size:kPasswordFontSize];
    passwordTextField.textColor = [UIColor blackColor];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.textAlignment = NSTextAlignmentLeft;
    if ([self passwordPlaceholder]) {
        passwordTextField.placeholder = [self passwordPlaceholder];
    }
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    [topView addSubview:passwordTextField];
    
    if ([self useSecureSwitch]) {
        UISwitch *secureSwitch = [[UISwitch alloc] init];
        secureSwitch.center = CGPointMake(40, topViewFrame.size.height - 26);
        secureSwitch.on = YES;
        [secureSwitch addTarget:self
                         action:@selector(valueChangedSecureSwitch:)
               forControlEvents:UIControlEventValueChanged];
        [topView addSubview:secureSwitch];
        _secureSwitch = secureSwitch;
        
        CGRect secureSwitchLabelFrame = CGRectMake(secureSwitch.frame.size.width + 30,
                                                   topViewFrame.size.height - 36,
                                                   topViewFrame.size.width - secureSwitch.frame.size.width + 50,
                                                   20);
        
        UILabel *secureSwitchLabel = [[UILabel alloc] initWithFrame:secureSwitchLabelFrame];
        secureSwitchLabel.text = NSLocalizedString(@"Secure character.", @"Secure character.");
        secureSwitchLabel.textAlignment = NSTextAlignmentLeft;
        secureSwitchLabel.textColor = [UIColor blackColor];
        secureSwitchLabel.font = [UIFont fontWithName:@"Arial" size:16];
        secureSwitchLabel.numberOfLines = 1;
        [topView addSubview:secureSwitchLabel];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = cancelButtonFrame;
    [cancelButton addTarget:self action:@selector(pressCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[PasswordDialogViewController colorFromHexString:@"#1e56fe" alpha:1]
                       forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [leftView addSubview:cancelButton];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame = okButtonFrame;
    [okButton addTarget:self action:@selector(pressOKButton:) forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:NSLocalizedString(@"OK", @"OK") forState:UIControlStateNormal];
    [okButton setTitleColor:[PasswordDialogViewController colorFromHexString:@"#1e56fe" alpha:1]
                   forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [rightView addSubview:okButton];
    
    [mainView addSubview:topView];
    [mainView addSubview:leftView];
    [mainView addSubview:rightView];
    
    [[self view] addSubview:mainView];
    
    _mainView = mainView;
    _titleLabel = titleLabel;
    _messageLabel = messageLabel;
    _passwordTextField = passwordTextField;
}

- (void)_notEqualAction:(void (^)(void))finishedShake {
    CGRect frame = _mainView.frame;

    [UIView animateWithDuration:kShakeDuration animations:^(void) {
        _mainView.frame = CGRectMake(frame.origin.x + kShakeWidth, frame.origin.y,
                                     frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kShakeDuration animations:^(void) {
            _mainView.frame = CGRectMake(frame.origin.x - kShakeWidth, frame.origin.y,
                                         frame.size.width, frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kShakeDuration animations:^(void) {
                _mainView.frame = CGRectMake(frame.origin.x + kShakeWidth, frame.origin.y,
                                             frame.size.width, frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:kShakeDuration animations:^(void) {
                    _mainView.frame = CGRectMake(frame.origin.x, frame.origin.y,
                                                 frame.size.width, frame.size.height);
                } completion:^(BOOL finished) {
                    finishedShake();
                }];
            }];
        }];
    }];
}

- (void)_retypeMessage {
    if ([self retypeMessageText]) {
        _messageLabel.text = [self retypeMessageText];
    }
    if ([self retypeMessageTextColor]) {
        _messageLabel.textColor = [self retypeMessageTextColor];
    }
}

#pragma mark - Action methods

- (void)valueChangedSecureSwitch:(UISwitch *)sender {
    _passwordTextField.secureTextEntry = sender.on;
}

- (void)pressOKButton:(id)sender {
    if (_completionNoCheck){
        _completionNoCheck(self.passwordTextField.text);
    }

    if (_masterPassword){
        if (![_passwordTextField.text isEqualToString:_masterPassword]) {
            __weak __typeof__(self) weakSelf = self;
            [self _notEqualAction:^() {
                __typeof__(weakSelf) strongSelf = weakSelf;
                [strongSelf _retypeMessage];
            }];
            return;
        }
        
        if (_completion) {
            _completion(YES);
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)pressCloseButton:(id)sender {
    if (_completion) {
        _completion(NO);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Utilities

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    scanner.scanLocation = 1;
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:alpha];
}

@end

# PasswordDialogViewController

[![CocoaPods](https://img.shields.io/cocoapods/v/PasswordDialogViewController.svg)](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/LICENSE)

PasswordDialogViewController is a simple password dialog UIViewController class.

## Screens

![Normal](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/normal.gif)
![Switch](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/switch.gif)

## Requirements

- iOS7.1

## Install

Passworddialogviewcontroller is available on cocoapods.

```
pod 'PasswordDialogViewController'
```

or include the PasswordDialogViewController class in your project.

## Usage

```
#import "PasswordDialogViewController.h"
```

```
@implementation ViewController

- (IBAction)pressAlertButton:(id)sender {
    // Master password
    NSString *password = @"password";

    PasswordDialogViewController *viewController;
    viewController = [[PasswordDialogViewController alloc] initWithPassword:password];

    [viewController setDelegate:self];

    [viewController setTitleText:@"Title"];
    [viewController setMessageText:@"This is message."];

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
```

## License

This PasswordDialogViewController is released under the MIT License.
See [LICENSE](/LICENSE) for details.


# PasswordDialogViewController

[![CocoaPods](https://img.shields.io/cocoapods/v/PasswordDialogViewController.svg)](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController)

PasswordDialogViewController is a simple password dialog UIViewController class.

## Screens

![Normal](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/normal.gif)
![Switch](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/switch.gif)

## Requirements

- iOS7.1+

## Install

PasswordDialogViewController is available on cocoapods.

```ruby
pod 'PasswordDialogViewController'
```

or include the PasswordDialogViewController class in your project.

## Usage

``` objective-c
#import "PasswordDialogViewController.h"
```

``` objective-c
@implementation ViewController

- (IBAction)pressPasswordDialogButton:(id)sender {
    NSString *masterPassword = @"password";

    PasswordDialogViewController *viewController;
    viewController = [[PasswordDialogViewController alloc] initWithPassword:masterPassword];

    viewController.delegate = self;

    viewController.titleText = @"Title";
    viewController.messageText = @"This is message.";

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

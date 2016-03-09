About
========

PasswordDialogViewController is a simple password dialog UIViewController class.
iOS7 later.

![Normal](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/normal.gif)
![Switch](https://github.com/TakayoshiMiyamoto/PasswordDialogViewController/blob/master/images/switch.gif)

Usage
========

Include the PasswordDialogViewController class in your project.

```` objective-c
#import "PasswordDialogViewController.h"
````

```` objective-c
@implementation ViewController

- (IBAction)pressAlertButton:(id)sender {
    NSString *password = @"test"; // Master password.

    PasswordDialogViewController *viewController;
    viewController = [[PasswordDialogViewController alloc] initWithPassword:password];
    [viewController setDelegate:self];
    [viewController setTitleText:@"Title"];
    [viewController setMessageText:@"This is message.This is message.This is message.This is message.This is message."];
    [viewController show:^(BOOL isOK) { // callback.
        if (isOK) {
            NSLog(@"Succeed");
        }
        else {
            NSLog(@"Cancel");
        }
    }];
}

@end
````

License
========

This PasswordDialogViewController is released under the MIT License.
See [LICENSE](/LICENSE) for details.


//
//  ViewController.m
//  EventTrackerApp
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userName;

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    if ([userName.text isEqualToString:@""] || userName.text==nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert title" message:@"Please enter username" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:userName.text
                                                  forKey:@"userName"];
    }
}


@end

//
//  SignUpViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender
{
    PFUser *newUser = [PFUser user];

    newUser.username = self.userName.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error)
    {
         if (error != nil)
         {
             NSLog(@"Error: %@", error.localizedDescription);
         }
         else
         {
             NSLog(@"User registered successfully");
         }
     }];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

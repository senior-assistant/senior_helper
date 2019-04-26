//
//  loginViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/26/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "loginViewController.h"
#import "Parse/Parse.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapSignUp:(id)sender
{
    [self performSegueWithIdentifier:@"createAccountSegue" sender:nil];
}

- (IBAction)didTapLogin:(id)sender
{
    [self loginUser];
}

-(void)loginUser
{
    NSString *username = self.loginUserNameField.text;
    NSString *password = self.loginPasswordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error)
    {
        if (error)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error logging in!" message:error.localizedDescription preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            NSLog(@"error logging in user: %@", error.localizedDescription);
        }
        else
        {
            NSLog(@"%@", user[@"role"]);
            if ( [user[@"role"] isEqualToString:@"AssistantSeeker"])
            {
                [self performSegueWithIdentifier:@"loginSeekerSegue" sender:nil];
            }
            else if ([user[@"role"] isEqualToString:@"AssistantProvider"])
            {
                [self performSegueWithIdentifier:@"loginProviderSegue" sender:nil];
            }
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

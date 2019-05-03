//
//  SignUpViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "MessgingViewController.h"
#import "AssistantSeekerViewController.h"
#import "AssistantProviderViewController.h"

@interface SignUpViewController ()
@property(strong, nonatomic) SignUpViewController * signIn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roleSegment;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signIn = [[SignUpViewController alloc] init];
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
        NSArray * arrayForRole = @[@"AssistantSeeker", @"AssistantProvider"];
        NSString * role = arrayForRole[self.roleSegment.selectedSegmentIndex];
        newUser[@"role"] = role;
        newUser[@"location"] = @"0.1miles";
    
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error)
         {
             if (error != nil)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error signing up!" message:((void)(@"%@"),error.localizedDescription) preferredStyle:(UIAlertControllerStyleAlert)];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action)
                 {
                     
                 }];
                 [alert addAction:okAction];
                 
                 [self presentViewController:alert animated:YES completion:^
                 {
                     
                 }];
                 NSLog(@"Error: %@", error.localizedDescription);
             }
             else
             {
                 NSLog(@"User registered successfully");
                 PFUser *registerUser = [PFUser currentUser];
                 PFRelation *relation = [registerUser relationForKey:@"texts"];
//                 [registerUser save];
//
//                 if ([role isEqualToString:@"AssistantSeeker"])
//                 {
//                     [self performSegueWithIdentifier:@"seekerSegue" sender:nil];
//                 }
//                 else
//                 {
//                     [self performSegueWithIdentifier:@"providerSegue" sender:nil];
//                 }
////                 [messages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
////                  {
////                      if (succeeded)
////                      {
////                          NSLog(@"Object saved!");
////                      }
////                      else
////                      {
////                          NSLog(@"Error: %@", error.description);
////                      }
////                  }];
//
                 [registerUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                 {
                      if (succeeded)
                      {
                             if ([role isEqualToString:@"AssistantSeeker"])
                             {
                                 [self performSegueWithIdentifier:@"seekerSegue" sender:nil];
                             }
                             else
                             {
                                 [self performSegueWithIdentifier:@"providerSegue" sender:nil];
                             }
                      }
                      else
                      {
                          // There was a problem, check error.description
                          NSLog(@"error");
                      }
                  }];
             }
         }];
}

- (IBAction)onTap:(id)sender
{
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"seekerSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];;
        AssistantSeekerViewController * messgingViewController = (AssistantSeekerViewController*) navigationController.topViewController;
        //messgingViewController.currentUserName = self.userName.text;
    }
    else
    {
        UINavigationController *navigationController = [segue destinationViewController];;
        AssistantProviderViewController * providerViewController = (AssistantProviderViewController*) navigationController.topViewController;
        //messgingViewController.currentUserName = self.userName.text;
    }
}


@end

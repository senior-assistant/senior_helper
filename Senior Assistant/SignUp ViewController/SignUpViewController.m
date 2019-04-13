//
//  SignUpViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "AssistantSeekerViewController.h"

@interface SignUpViewController ()
@property(strong, nonatomic) SignUpViewController * signIn;
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
- (void) userRegister
{

}

-(void) registerUsers
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
             PFObject *messages = [PFObject objectWithClassName:@"Messages"];
             messages[@"score"] = @1337;
             messages[@"playerName"] = @"Sean Plott";
             messages[@"cheatMode"] = @NO;
             [messages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (succeeded)
                  {
                      NSLog(@"Object saved!");
                  }
                  else
                  {
                      NSLog(@"Error: %@", error.description);
                  }
              }];
             
             PFUser *registerUser = [PFUser currentUser];
             PFRelation *relation = [registerUser relationForKey:@"texts"];
             [relation addObject:messages];
             [registerUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  if (succeeded)
                  {
                      // The post has been added to the user's likes relation.
                      NSLog(@"succeeded");
                  }
                  else
                  {
                      // There was a problem, check error.description
                      NSLog(@"error");
                  }
              }];
              //[self performSegueWithIdentifier:@"seekerViewSegue" sender:nil];
//             [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//              {
//                  if (error)
//                  {
//                      // There was an error
//                      NSLog(@"Error: %@", error.description);
//                  }
//                  else
//                  {
//                      NSLog(@"%@", objects);
//                  }
//              }];
         }
     }];
}

- (IBAction)registerUser:(id)sender
{
    SignUpViewController *signInPassData = self.signIn;
    signInPassData.userName = self.userName;
    signInPassData.emailField = self.emailField;
    signInPassData.passwordField = self.passwordField;
    [self.signIn registerUsers];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"seekerViewSegue"])
//    {
//        AssistantSeekerViewController * assistantSeekerViewController =[segue destinationViewController];
//        assistantSeekerViewController.currentUserName = self.userName.text;
//    }
}


@end

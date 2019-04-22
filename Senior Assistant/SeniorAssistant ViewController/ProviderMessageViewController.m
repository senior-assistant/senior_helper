//
//  ProviderMessageViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/21/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "ProviderMessageViewController.h"
#import "ProviderMessageViewCell.h"
#import "Parse/Parse.h"
#import "AssistantSeekerViewController.h"
#import "MessgingViewController.h"

@interface ProviderMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray * providerMessageCount;
-(void) updateMessageForProvider:(PFObject *) result;
@end

@implementation ProviderMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.providerMessageTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) updateMessageForProvider:(PFObject *) result;
{
//    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
//    [query getObjectInBackgroundWithId:result.objectId block:^(PFObject * message, NSError * error)
//     {
         [result addObject:self.providerTextField.text forKey:@"textMessages"];
         [result saveInBackground];
         [self.providerMessageTableView reloadData];
    
         AssistantSeekerViewController * assistantSeekersView = [[AssistantSeekerViewController alloc] init];
         [assistantSeekersView.recentMessages reloadData];
    
         MessgingViewController * messageView = [[MessgingViewController alloc] init];
         [messageView.messageTableView reloadData];
     //}];
    
    //    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    //    {
    //
    //    }];
}

- (IBAction)seningProviderMessage:(id)sender
{
    PFUser * user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"sender" equalTo:self.messageSenderName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
     {
         PFObject * object;
         BOOL found = false;
         
         for (int i = 0; i < objects.count && !found; i++)
         {
             if (objects[i][@"sender"] == self.messageSenderName && objects[i][@"receiver"] == user.username)
             {
                 found = true;
                 object = objects[i];
             }
         }
         
         if (found)
         {
             [self updateMessageForProvider:object];
         }
     }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ProviderMessageViewCell * providercell = [tableView dequeueReusableCellWithIdentifier:@"providerMessageCell" forIndexPath:indexPath];

    PFUser * user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"sender" equalTo:self.messageSenderName];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        PFObject * object;
        BOOL found = false;

        for (int i = 0; i < objects.count && !found; i++)
        {
            if (objects[i][@"sender"] == self.messageSenderName && objects[i][@"receiver"] == user.username)
            {
                found = true;
                object = objects[i];
            }
        }
        
        if (found)
        {
            providercell.providerMessageTextView.text = object[@"textMessages"][indexPath.row];
        }
    }];

    return providercell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFUser * user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"sender" equalTo:self.messageSenderName];

    NSArray * tempArray = [query findObjects];

    PFObject * object;
    BOOL found = false;

    for (int i = 0; i < tempArray.count && !found; i++)
    {
         if (tempArray[i][@"sender"] == self.messageSenderName && tempArray[i][@"receiver"] == user.username)
         {
             found = true;
             object = tempArray[i];
         }
    }

    if (found)
    {
        self.providerMessageCount = object[@"textMessages"];
    }

    return self.providerMessageCount.count;
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
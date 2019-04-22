//
//  AssistantProviderViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "AssistantProviderViewController.h"
#import "ProviderMessageViewController.h"
#import "RecentMessagesCell.h"
#import "Parse/Parse.h"

@interface AssistantProviderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString * senderName;
@end

@implementation AssistantProviderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recentMessages.dataSource = self;
    self.recentMessages.delegate = self;
    [self.recentMessages reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"receiver" equalTo:user.username];
    NSArray * temp = [query findObjects];
    
    return temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentMessagesCell" forIndexPath:indexPath];
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"receiver" equalTo:user.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        PFObject * tempObject =  objects[indexPath.row];
        cell.nameLabelAP.text = tempObject[@"sender"];
        NSArray * arrayForTextMessages = tempObject[@"textMessages"];
        cell.messageLabelAP.text = tempObject[@"textMessages"][arrayForTextMessages.count - 1];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"receiver" equalTo:user.username];
    NSArray * arrayOfSenders = [query findObjects];
    self.senderName = arrayOfSenders[indexPath.row][@"sender"];
    [self performSegueWithIdentifier:@"providerMessageSegue" sender:nil];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"providerMessageSegue"])
    {
        UINavigationController * navigationController = [segue destinationViewController];;
        ProviderMessageViewController * providerViewController = (ProviderMessageViewController
                                                                  *) navigationController.topViewController;
        providerViewController.messageSenderName = self.senderName;
    }
}

@end

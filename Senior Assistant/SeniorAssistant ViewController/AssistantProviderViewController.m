//
//  AssistantProviderViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "AssistantProviderViewController.h"
#import "RecentMessagesCell.h"
#import "Parse/Parse.h"

@interface AssistantProviderViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AssistantProviderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recentMessages.dataSource = self;
    self.recentMessages.delegate = self;
    [self.recentMessages reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end

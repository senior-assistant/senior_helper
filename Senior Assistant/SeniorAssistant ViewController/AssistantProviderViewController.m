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
#import "AppDelegate.h"
#import "loginViewController.h"

@interface AssistantProviderViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString * senderName;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray * temp;
-(void) dataFetcher;
@end

@implementation AssistantProviderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recentMessages.dataSource = self;
    self.recentMessages.delegate = self;
    self.temp = [[NSArray alloc] init];
    
    [self dataFetcher];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(dataFetcher) forControlEvents:UIControlEventValueChanged];
    [self.recentMessages addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dataFetcher
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"receiver" equalTo:user.username];
    self.temp = [query findObjects];
    [self.recentMessages reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.temp.count;
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
        
        NSString * temp = tempObject[@"textMessages"][arrayForTextMessages.count - 1];
        temp = [temp substringToIndex:temp.length - 1];
        cell.messageLabelAP.text = temp;
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

- (IBAction)didTapLogout:(id)sender
{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
        loginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
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

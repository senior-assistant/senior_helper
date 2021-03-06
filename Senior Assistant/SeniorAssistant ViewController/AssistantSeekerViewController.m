//
//  AssistantSeekerViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "AssistantSeekerViewController.h"
#import "RecentMessagesCell.h"
#import "MessgingViewController.h"
#import "AvailableAssistantsViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "loginViewController.h"

@interface AssistantSeekerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString* receiverName;
@property (nonatomic, assign) NSInteger numberOfRows;
-(void) dataFetcher;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation AssistantSeekerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recentMessages.dataSource = self;
    self.recentMessages.delegate = self;
    [self dataFetcher];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(dataFetcher) forControlEvents:UIControlEventValueChanged];
    [self.recentMessages addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dataFetcher
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];

    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
         self.numberOfRows = objects.count;
         [self.recentMessages reloadData];
         [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    PFUser *user = [PFUser currentUser];
//    PFRelation *relation = [user relationForKey:@"texts"];
//    //= [[relation query] findObjects];
//    NSArray * tempValue;
//    [tempValue arrayByAddingObjectsFromArray:[[relation query] findObjects]];
//    return tempValue.count;
//
//    if (!tempValue)
//    {
//        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
//        {
//             [tempValue arrayByAddingObjectsFromArray:objects];
//        }];
//    }
//    else
//    {
//        return tempValue.count;
//    }
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentMessagesCell" forIndexPath:indexPath];

    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];
    
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
         self.numberOfRows = objects.count;
         PFObject *resultObejct = objects[indexPath.row];
         PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
         
         [query getObjectInBackgroundWithId:resultObejct.objectId block:^(PFObject * message, NSError * error)
         {
              cell.nameLabel.text = message[@"receiver"];
              NSArray * tempValue = message[@"textMessages"];
             
              NSString * temp = message[@"textMessages"][tempValue.count - 1];
              temp = [temp substringToIndex:temp.length - 1];
              cell.messageLabel.text = temp;
         }];
     }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];
    NSArray * tempValue = [[relation query] findObjects];
    self.receiverName = tempValue[indexPath.row][@"receiver"];
    [self performSegueWithIdentifier:@"toMessageSegue" sender:nil];
}

- (IBAction)findOtherAssistant:(id)sender
{
    [self performSegueWithIdentifier:@"availableAssistant" sender:nil];
}

- (IBAction)didTapLogout:(id)sender
{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SignUp" bundle:nil];
        loginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toMessageSegue"])
    {
        UINavigationController * navigationController = [segue destinationViewController];
        MessgingViewController * messgingViewController = (MessgingViewController*) navigationController.topViewController;
        messgingViewController.receiverUserName = self.receiverName;
    }
    else
    {
        UINavigationController * navigationController = [segue destinationViewController];;
        AvailableAssistantsViewController * messgingViewController = (AvailableAssistantsViewController*) navigationController.topViewController;
    }
}


@end

//
//  AvailableAssistantsViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/9/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "AvailableAssistantsViewController.h"
#import "AvailableAssistantsCell.h"
#import "MessgingViewController.h"
#import "Parse/Parse.h"

@interface AvailableAssistantsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *availableAssistants;
@property (strong, nonatomic) NSString * receiverString;
@property (strong, nonatomic) UIViewController * selfViewController;
@end

@implementation AvailableAssistantsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.availableAssistants.dataSource = self;
    self.availableAssistants.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"role" equalTo:@"AssistantProvider"];
    NSArray * results = [query findObjects];
    
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailableAssistantsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableAssistantsCell" forIndexPath:indexPath];
    PFQuery *query = [PFUser query];
    PFUser * user = [PFUser currentUser];
    //[query whereKey:@"username" notEqualTo:user.username];
    [query whereKey:@"role" equalTo:@"AssistantProvider"];
    NSArray * results = [query findObjects];
    cell.nameLabel.text = results[indexPath.row][@"username"];
    cell.distanceLabel.text = results[indexPath.row][@"location"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFQuery *query = [PFUser query];
    PFUser * user = [PFUser currentUser];
    //[query whereKey:@"username" notEqualTo:user.username];
    [query whereKey:@"role" equalTo:@"AssistantProvider"];
    NSArray * results = [query findObjects];
    self.receiverString = results[indexPath.row][@"username"];
    [self performSegueWithIdentifier:@"showMessage" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showMessage"])
    {
        UINavigationController * navigationController = [segue destinationViewController];;
        MessgingViewController * messgingViewController = (MessgingViewController*) navigationController.topViewController;
        messgingViewController.receiverUserName = self.receiverString;
    }
}


@end

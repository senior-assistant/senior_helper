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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PFQuery *query = [PFUser query];
    NSArray * results = [query findObjects];
    
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailableAssistantsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableAssistantsCell" forIndexPath:indexPath];
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"];
    NSArray * results = [query findObjects];
    cell.nameLabel.text = results[indexPath.row][@"username"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"];
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

//
//  MessgingViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/13/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "MessgingViewController.h"
#import "Parse/Parse.h"
#import "mesageViewCell.h"

@interface MessgingViewController () <UITableViewDataSource, UITableViewDelegate>
@property(strong, nonatomic) NSMutableArray * messageArray;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@end

@implementation MessgingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    self.messageArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendingMesage:(id)sender
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];

    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        PFObject *resultObejct = objects[0];
        NSLog(@"%@", resultObejct.objectId);
        PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
        
        [query getObjectInBackgroundWithId:resultObejct.objectId block:^(PFObject * message, NSError * error)
        {
            message[@"sender"] = user.username;
            message[@"receiver"] = @"zola";
            [self.messageArray addObject:self.messageTextField.text];
            NSArray *array = [[NSArray alloc] initWithArray:self.messageArray];
            [message addObjectsFromArray:array forKey:@"textMessages"];
            [message saveInBackground];
            [self. messageTableView reloadData];
        }];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    mesageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    NSString * temporary = self.messageArray[indexPath.row];
    NSLog(@"%@", indexPath);
    cell.messageTextView.text = temporary;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
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

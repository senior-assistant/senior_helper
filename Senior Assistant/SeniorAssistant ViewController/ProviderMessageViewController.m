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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
-(void) updateMessageForProvider:(PFObject *) result;
-(void) dataFetcher;
@end

@implementation ProviderMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.providerMessageTableView.dataSource = self;
    self.providerMessageTableView.delegate = self;
    self.providerMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.providerMessageCount = [[NSArray alloc] init];
    [self dataFetcher];
    [self cellOffsetCorrector];
    self.providerMessageTableView.rowHeight = UITableViewAutomaticDimension;
    self.providerMessageTableView.estimatedRowHeight = 2000;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(dataFetcher) forControlEvents:UIControlEventValueChanged];
    [self.providerMessageTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) cellOffsetCorrector
{
    if (self.providerMessageTableView.contentSize.height > self.providerMessageTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.providerMessageTableView.contentSize.height - self.providerMessageTableView.frame.size.height);
        [self.providerMessageTableView setContentOffset:offset animated:YES];
    }
}

-(void) dataFetcher
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
    [self.providerMessageTableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void) updateMessageForProvider:(PFObject *) result;
{
//    PFUser *user = [PFUser currentUser];
//    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
//    [query getObjectInBackgroundWithId:result.objectId block:^(PFObject * message, NSError * error)
//     {
         NSString * postIdentfier = @"0";
         self.providerTextField.text = [self.providerTextField.text stringByAppendingString:postIdentfier];
         [result addObject:self.providerTextField.text forKey:@"textMessages"];
         [result saveInBackground];
         self.providerMessageCount = result[@"textMessages"];
         [self.providerMessageTableView reloadData];
     //}];
    
    //    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    //    {
    //
    //    }];
}

- (IBAction)sendingProviderMessage:(id)sender
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
            NSString * temp = object[@"textMessages"][indexPath.row];
            NSString * singleChar = [NSString stringWithFormat:@"%c", [temp characterAtIndex:temp.length - 1]];
            
            if ([singleChar isEqual:@"0"])
            {
                temp = [temp substringToIndex:temp.length - 1];
                providercell.providerMessageTextView.textAlignment = NSTextAlignmentLeft;
                providercell.providerMessageTextView.text = temp;
            }
            else
            {
                temp = [temp substringToIndex:temp.length - 1];
                providercell.providerMessageTextView.textAlignment = NSTextAlignmentRight;
                providercell.providerMessageTextView.text = temp;
            }
            
        }
    }];

    return providercell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

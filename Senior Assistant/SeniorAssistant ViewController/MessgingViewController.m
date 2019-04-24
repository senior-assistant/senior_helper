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
#import "AssistantProviderViewController.h"
#import "ProviderMessageViewController.h"
#import "AssistantSeekerViewController.h"
#import "AvailableAssistantsViewController.h"

@interface MessgingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray * messageArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
-(PFObject*) createObject;
-(void) updateMessage:(PFObject *) result;
-(void) dataFetcher;
@end

@implementation MessgingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    self.messageArray = [[NSMutableArray alloc] init];
    [self dataFetcher];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(dataFetcher) forControlEvents:UIControlEventValueChanged];
    [self.messageTableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dataFetcher
{
    NSString* preFixText = @"To ";
    NSString * combined = [preFixText stringByAppendingString:self.receiverUserName];
    self.receiverUserLabelName.text = combined;
    bool found = false;
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];
    NSArray *temp = [[relation query]findObjects];
    PFObject * resultObejct;
    
    for (int i = 0; i < temp.count && !found; i++)
    {
        if ([temp[i][@"receiver"] isEqualToString:self.receiverUserName])
        {
            found = true;
            resultObejct = temp[i];
            self.messageArray = resultObejct[@"textMessages"];
        }
    }
    
    [self.messageTableView reloadData];
    [self.refreshControl endRefreshing];
}

-(PFObject*) createObject
{
    PFUser *user = [PFUser currentUser];
    NSArray* textMessages =  @[] ;
    PFObject *messages = [PFObject objectWithClassName:@"Messages"];
    messages[@"sender"] = user.username;
    messages[@"receiver"] = @"";
    messages[@"textMessages"] = textMessages;
    
    return messages;
}

-(void) updateMessage:(PFObject *) result;
{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query getObjectInBackgroundWithId:result.objectId block:^(PFObject * message, NSError * error)
    {
         message[@"sender"] = user.username;
         message[@"receiver"] = self.receiverUserName;
         [self.messageArray addObject:self.messageTextField.text];
         [message addObject:self.messageTextField.text forKey:@"textMessages"];
         [message saveInBackground];
         [self.messageTableView reloadData];
        
     }];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
//    {
//
//    }];
}

- (IBAction)sendingMesage:(id)sender
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];
    PFQuery *query = [PFUser query];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
        PFObject *resultObejct;
        BOOL found = false;

        for (int i = 0; i < objects.count && !found; i++)
        {
            if ([objects[i][@"receiver"] isEqualToString:self.receiverUserName])
            {
                found = true;
                resultObejct = objects[i];
            }
        }

        if (found)
        {
            [self updateMessage:resultObejct];
//            [query whereKey:@"username" equalTo:self.receiverUserName];
//            NSArray *receiverArray = [query findObjects];
//            PFObject * temp = receiverArray[0];
//            PFRelation * relation2 = [temp relationForKey:@"texts"];
        }
        else
        {
            PFObject * result = [self createObject];
            [relation addObject:result];
            [result save];
            [user save];
            [self updateMessage:result];
//            [query whereKey:@"username" equalTo:self.receiverUserName];
//            NSArray *receiverArray = [query findObjects];
//            receiverArray[0][@"texts"] = relation;
        }
     }];
}

- (IBAction)doneWithMessage:(id)sender
{
    //[[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
    UINavigationController * navigationController;
    AvailableAssistantsViewController * availbleAssistantView = [[AvailableAssistantsViewController alloc] init];
    availbleAssistantView = (AvailableAssistantsViewController*) navigationController.topViewController;
    [self showViewController:availbleAssistantView sender:self];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    mesageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"texts"];
    
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
    {
         bool found = false;
         PFObject *resultObejct;
        
         for (int i = 0; i < objects.count && !false; i++)
         {
            if ([objects[i][@"receiver"] isEqualToString:self.receiverUserName])
            {
                found = true;
                resultObejct = objects[i];
            }
         }

         if (found)
         {
             PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
             [query getObjectInBackgroundWithId:resultObejct.objectId block:^(PFObject * message, NSError * error)
             {
                  cell.messageTextView.text = message[@"textMessages"][indexPath.row];
             }];
         }
     }];

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

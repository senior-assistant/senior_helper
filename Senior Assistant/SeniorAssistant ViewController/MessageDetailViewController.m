//
//  MessageDetailViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 5/3/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailMessageStringValue = [self.detailMessageStringValue substringToIndex:self.detailMessageStringValue.length - 1];
    self.detailMessageView.text = self.detailMessageStringValue;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

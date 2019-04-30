//
//  InterstitalViewController.m
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/30/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import "InterstitalViewController.h"

@interface InterstitalViewController ()

@end

@implementation InterstitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLogin:(id)sender
{
    [self performSegueWithIdentifier:@"toLoginSegue"sender:nil];
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

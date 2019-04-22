//
//  ProviderMessageViewController.h
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/21/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *providerMessageTableView;
@property (weak, nonatomic) IBOutlet UITextField *providerTextField;
@property (weak, nonatomic) IBOutlet UIButton *providerSend;
@property (strong, nonatomic) NSString * messageSenderName;
@end

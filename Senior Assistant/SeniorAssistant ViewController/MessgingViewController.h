//
//  MessgingViewController.h
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/13/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessgingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton* sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property(strong, nonatomic) NSString* receiverUserName;
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UILabel *receiverUserLabelName;
@property (strong, nonatomic) NSString *messageString;
@end

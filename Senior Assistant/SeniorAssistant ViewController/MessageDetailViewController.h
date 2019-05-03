//
//  MessageDetailViewController.h
//  Senior Assistant
//
//  Created by Zelalem Terefe on 5/3/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *detailMessageView;
@property (weak, nonatomic) IBOutlet UILabel *labeField;
@property (strong, nonatomic) NSString * detailMessageStringValue;
@end

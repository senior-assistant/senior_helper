//
//  MessgingViewController.h
//  Senior Assistant
//
//  Created by Zelalem Terefe on 4/13/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessgingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (weak, nonatomic) IBOutlet UITextView *messageTextField;
@property(strong, nonatomic) NSString* currentUserName;
@end

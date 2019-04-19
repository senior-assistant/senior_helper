//
//  RecentMessagesCell.h
//  Senior Assistant
//
//  Created by chung Ng-a on 4/13/19.
//  Copyright © 2019 Zelalem Terefe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecentMessagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabelAP;
@property (weak, nonatomic) IBOutlet UILabel *messageLabelAP;



@end

NS_ASSUME_NONNULL_END

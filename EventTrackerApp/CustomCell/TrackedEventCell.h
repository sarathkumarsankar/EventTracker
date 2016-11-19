//
//  TrackedEventCell.h
//  EventTrackerApp
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackedEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *trackedImage;
@property (weak, nonatomic) IBOutlet UILabel *trackedName;
@property (weak, nonatomic) IBOutlet UILabel *trackedPlace;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UIButton *removeEvent;

@end

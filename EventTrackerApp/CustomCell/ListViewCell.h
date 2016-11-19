//
//  ListViewCell.h
//  KeepWorks
//
//  Created by sarathkumar s on 16/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *pay;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

@end

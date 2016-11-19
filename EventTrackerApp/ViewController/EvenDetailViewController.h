//
//  EvenDetailViewController.h
//  KeepWorks
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface EvenDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (strong, nonatomic)  NSString *image;
@property (strong, nonatomic)  NSString *name;
@property (strong, nonatomic)  NSString  *place;
@property (strong, nonatomic)  NSString *pay;
- (IBAction)TrackUser:(id)sender;

@end

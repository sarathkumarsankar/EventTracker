//
//  TrackedEventViewController.h
//  EventTrackerApp
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TrackedEventViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *trckedEventTableView;
@property (strong) NSMutableArray *events;
@end

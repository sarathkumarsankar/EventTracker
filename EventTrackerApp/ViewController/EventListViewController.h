//
//  EventViewController.h
//  KeepWorks
//
//  Created by sarathkumar s on 16/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventListViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *EventCollectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cellType;
@property (nonatomic,strong)NSMutableArray *eventNameArray;
@property (nonatomic,strong)NSMutableArray *eventPlaceArray;
@property (nonatomic,strong)NSDictionary * eventDictionory;
- (IBAction)mode:(id)sender;

@end

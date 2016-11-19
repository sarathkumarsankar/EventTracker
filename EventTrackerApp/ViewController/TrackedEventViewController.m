//
//  TrackedEventViewController.m
//  EventTrackerApp
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import "TrackedEventViewController.h"
#import "TrackedEventCell.h"
#import "CoreDataHandler.h"
#import "EvenDetailViewController.h"

@interface TrackedEventViewController ()
{
    NSString *userName;
}

@end

@implementation TrackedEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.trckedEventTableView addGestureRecognizer:longPress];
    userName =[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    [[CoreDataHandler instance] fetchDatabaseForEntity:@"Event" withUserName:userName onCompletion:^(NSMutableArray * eventListArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *tempArray=[[NSMutableArray alloc]init];
            for (NSDictionary *tempDic in eventListArray) {
                NSMutableDictionary *storeDetailDic=[[NSMutableDictionary alloc]init];
                [storeDetailDic setValue:[tempDic valueForKey:@"eventName"] forKey:@"eventName"];
                [storeDetailDic setValue:[tempDic valueForKey:@"eventPlace"] forKey:@"eventPlace"];
                [storeDetailDic setValue:[tempDic valueForKey:@"payment"] forKey:@"payment"];
                [storeDetailDic setValue:[tempDic valueForKey:@"eventImage"] forKey:@"eventImage"];
                [storeDetailDic setValue:[tempDic valueForKey:@"userName"] forKey:@"userName"];
                [storeDetailDic setValue:[tempDic valueForKey:@"order"] forKey:@"order"];
                [tempArray addObject:storeDetailDic];
            }
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
            self.events=[[tempArray sortedArrayUsingDescriptors:@[sort]] mutableCopy];
            [_trckedEventTableView reloadData];
        });
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate and DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackedCell";
    TrackedEventCell *cell = [_trckedEventTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *event = [self.events objectAtIndex:indexPath.row];
    cell.trackedImage.image =[UIImage imageNamed:[event valueForKey:@"eventImage"]];
    cell.trackedName.text = [event valueForKey:@"eventName"];
    cell.trackedPlace.text = [event valueForKey:@"eventPlace"];
    cell.payment.text = [event valueForKey:@"payment"];
    [cell.removeEvent addTarget:self action:@selector(removeEventMethod:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)removeEventMethod:(UIButton *)sender
{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:_trckedEventTableView];
    NSIndexPath *indexPath = [_trckedEventTableView indexPathForRowAtPoint:rootViewPoint];
    [[CoreDataHandler instance] deleterecordFromDatabaseForEntity:@"Event" withPredocate:[[self.events objectAtIndex:indexPath.row] valueForKey:@"eventName"] withUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    [self.events removeObjectAtIndex:indexPath.row];
    [_trckedEventTableView reloadData];
}

#pragma mark - Reorder list methods

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.trckedEventTableView];
    NSIndexPath *indexPath = [self.trckedEventTableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                TrackedEventCell *cell = [self.trckedEventTableView cellForRowAtIndexPath:indexPath];
                snapshot = [self customSnapshoFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.trckedEventTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                 
                    cell.alpha = 0.0;
                } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                NSMutableArray *tempArray=[self.events mutableCopy];
                NSString *firstOrderValue=[[tempArray objectAtIndex:indexPath.row] valueForKey:@"order"];
                NSString *secondOrderValue=[[tempArray objectAtIndex:sourceIndexPath.row] valueForKey:@"order"];
                [[self.events objectAtIndex:indexPath.row] setObject:secondOrderValue forKey:@"order"];
                [[self.events objectAtIndex:sourceIndexPath.row] setObject:firstOrderValue forKey:@"order"];
                [self.events exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.trckedEventTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
                [self cleardatabase];
            }
            break;
        }
        default: {
            UITableViewCell *cell = [self.trckedEventTableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
            break;
        }
    }
}

-(void)cleardatabase{
    
    [[CoreDataHandler instance] clearDatabaseForEntity:@"Event" withUserName:userName];
    [[CoreDataHandler instance] storeResultForEntity:@"Event" eventDetail:self.events];
}

#pragma mark - Helper methods

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"moveToDetail"]) {
        NSIndexPath *indexPath = [_trckedEventTableView indexPathForSelectedRow];
        NSManagedObject *event = [self.events objectAtIndex:indexPath.row];
        EvenDetailViewController *destViewController = segue.destinationViewController;
        destViewController.name = [event valueForKey:@"eventName"];
        destViewController.place =[event valueForKey:@"eventPlace"];
        destViewController.image =[event valueForKey:@"eventImage"];
        destViewController.pay =[event valueForKey:@"payment"];
    }
}
@end

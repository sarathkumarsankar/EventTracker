//
//  EventViewController.m
//  KeepWorks
//
//  Created by sarathkumar s on 16/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import "EventListViewController.h"
#import "ListViewCell.h"
#import "gridViewCell.h"
#import "EvenDetailViewController.h"
#import "TrackedEventViewController.h"
#import "CoreDataHandler.h"

@interface EventListViewController ()
{
    NSString *identifier;
    NSMutableArray *eventJson;
    TrackedEventViewController * TrackViewController;
    UIView *shadeView;
}
@end

@implementation EventListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EventsData" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    eventJson = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    self.cellType.tag=20;
    [self mode:self.cellType];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

-(void)viewWillAppear:(BOOL)animated{
    [_EventCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_EventCollectionView reloadData];
    
}
#pragma mark - collectionView Delegate and DataSource methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return eventJson.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 4.0;
    if([self.cellType tag]==10){
        return CGSizeMake(self.EventCollectionView.frame.size.width, 144);
    }
    else{
        return CGSizeMake(cellWidth+40, 231);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if([self.cellType tag]==20){
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else{
        return UIEdgeInsetsMake(10, 20, 0, 20);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([identifier  isEqual: @"EventListCell"]) {
        ListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.eventName.text =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Name"];
        cell.eventPlace.text =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"place"];
        cell.eventImage.image =[UIImage imageNamed:[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Image"]];
        cell.pay.text = [[eventJson objectAtIndex:indexPath.row]objectForKey:@"payment"];
        return cell;
    }
    else
    {
        gridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.eventName.text =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Name"];
        cell.eventImage.image =[UIImage imageNamed:[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Image"]];
        return cell;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"eventSegue"]) {
        NSIndexPath *indexPath = [[_EventCollectionView indexPathsForSelectedItems]firstObject];
        EvenDetailViewController *destViewController = segue.destinationViewController;
        destViewController.name =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Name"];
        destViewController.place =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"place"];
        destViewController.image =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"Image"];
        destViewController.pay =[[eventJson objectAtIndex:indexPath.row]objectForKey:@"payment"];
    }
}

- (IBAction)mode:(id)sender {
    if([_cellType tag]==20){
        identifier =@"EventListCell";
        self.cellType.tag=10;
        [self.cellType setImage:[UIImage imageNamed:@"list"]];
    }
    else{
        identifier =@"EventGridCell";
        self.cellType.tag=20;
        [self.cellType setImage:[UIImage imageNamed:@"grid"]];
    }
    [_EventCollectionView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [TrackViewController.view removeFromSuperview];
}
#pragma mark - swipe left and right methods

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    [TrackViewController.view removeFromSuperview];
    TrackViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TrackedEventView"];
    [self.view addSubview:TrackViewController.view];
    TrackViewController.view.frame=CGRectMake(5000, 64, 400, self.view.frame.size.height);
    [self addChildViewController:TrackViewController];
    CGRect basketTopFrame = TrackViewController.view.frame;
    basketTopFrame.origin.x = self.view.frame.size.width-400;
    shadeView=[[UIView alloc]init];
    shadeView.frame=CGRectMake(0, 0, self.view.frame.size.width-TrackViewController.view.frame.size.width, self.view.frame.size.height);
    shadeView.alpha=0.5;
    shadeView.backgroundColor=[UIColor grayColor];
    [TrackViewController.view bringSubviewToFront:shadeView];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        TrackViewController.view.frame = basketTopFrame;
    } completion:^(BOOL finished){
        [self.view addSubview:shadeView];
    }];
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer {
    CGRect basketTopFrame = TrackViewController.view.frame;
    basketTopFrame.origin.x = self.view.frame.size.width;
    [shadeView removeFromSuperview];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        TrackViewController.view.frame = basketTopFrame;
    } completion:^(BOOL finished){ }];
}
@end

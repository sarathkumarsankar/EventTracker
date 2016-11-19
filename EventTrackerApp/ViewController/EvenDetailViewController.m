//
//  EvenDetailViewController.m
//  KeepWorks
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import "EvenDetailViewController.h"
#import "CoreDataHandler.h"
#import "TrackedEventViewController.h"


@interface EvenDetailViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *events;
    BOOL Tracked;
    TrackedEventViewController *TrackViewController;
    UIView *shadeView;
}
@property(readwrite, nonatomic) BOOL slideFromSide;

@end

@implementation EvenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailImage.image =[UIImage imageNamed:_image];
    self.eventName.text =_name;
    self.eventPlace.text =_place;
    self.payment.text =_pay;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
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
        [[CoreDataHandler instance] fetchDatabaseForEntity:@"Event" withUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] onCompletion:^(NSMutableArray * eventListArray) {
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
                TrackViewController.events=[[tempArray sortedArrayUsingDescriptors:@[sort]] mutableCopy];
                [TrackViewController.trckedEventTableView reloadData];
            });
        }];

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

-(void)viewDidAppear:(BOOL)animated
{
    Tracked =NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)TrackUser:(id)sender
{
    events = [[NSMutableArray alloc]init];
    
    [[CoreDataHandler instance]fetchDatabaseForEntity:@"Event" withUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] withPredocate:_name onCompletion:^(BOOL status) {
        if(status==NO){
            [[CoreDataHandler instance] fetchDatabaseForEntity:@"Event" withUserName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"] onCompletion:^(NSMutableArray * eventListArray) {
                NSMutableDictionary *storeDetailDic=[[NSMutableDictionary alloc]init];
                NSString *userName =[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
                [storeDetailDic setValue:_name forKey:@"eventName"];
                [storeDetailDic setValue:_place forKey:@"eventPlace"];
                [storeDetailDic setValue:_pay forKey:@"payment"];
                [storeDetailDic setValue:_image forKey:@"eventImage"];
                [storeDetailDic setValue:userName forKey:@"userName"];
                [storeDetailDic setValue:[NSString stringWithFormat:@"%ld",(long)[eventListArray count]+1] forKey:@"order"];
                NSMutableArray *detailArray=[[NSMutableArray alloc]init];
                [detailArray addObject:storeDetailDic];
                [[CoreDataHandler instance] storeResultForEntity:@"Event" eventDetail:detailArray];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Event tracked" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Event Aleready you tracked" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } ];
    
}
@end

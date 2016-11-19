//
//  CoreDataHandler.h
//  KeepWorks
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface CoreDataHandler : UIViewController


+ (CoreDataHandler*)instance;
- (void)storeResultForEntity:(NSString *)entityName eventDetail:(NSMutableArray*)detailArray;
-(void)fetchRecordForEntity:(NSString*)entity onCompletion:(void(^)(NSMutableArray *))onCompletion;
-(void)deleteObjectForIndex:(NSIndexPath *)index;
-(void)deleterecordFromDatabaseForEntity:(NSString*)entity withPredocate:(NSString*)uniqueID withUserName:(NSString*)name;
-(void)fetchDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name onCompletion:(void(^)(NSMutableArray *))onCompletion;
-(void)clearDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name;
-(void)fetchDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name withPredocate:(NSString*)uniqueID onCompletion:(void(^)(BOOL))onCompletion;

@end

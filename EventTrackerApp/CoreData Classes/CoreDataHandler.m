//
//  CoreDataHandler.m
//  KeepWorks
//
//  Created by sarathkumar s on 17/11/16.
//  Copyright © 2016 sarathkumar s. All rights reserved.
//

#import "CoreDataHandler.h"
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"
#import "Event.h"


@implementation CoreDataHandler

+ (CoreDataHandler*)instance{
    static CoreDataHandler *whatever = nil;
    @synchronized([CoreDataHandler class])
    {
        if(!whatever)
            whatever = [[CoreDataHandler alloc] init];
    }
    return whatever;
}
#pragma mark -  Common Function to store data into specific Table
- (void)storeResultForEntity:(NSString *)entityName eventDetail:(NSMutableArray*)detailArray{
    @try {
        NSManagedObjectContext *context = [CoreDataHelper instance].managedObjectContext;
        for (NSDictionary *detailDic in detailArray) {
            NSManagedObject *objManaged = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            for (NSString *key in detailDic.keyEnumerator) {
                [objManaged setValue:detailDic[key] forKey:key];
            }
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
    }
}

#pragma mark - Fetch Event Record
-(void)fetchRecordForEntity:(NSString*)entity onCompletion:(void(^)(NSMutableArray *))onCompletion{
    
    NSFetchRequest *fetchRequest = nil;
    NSEntityDescription *listOfNameEntity = nil;
    NSError *error = nil;
    NSMutableArray *managedObjectsArray = nil;
    @try {
        fetchRequest = [[NSFetchRequest alloc]init];
        listOfNameEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataHelper instance].managedObjectContext];
        [fetchRequest setEntity:listOfNameEntity];
        managedObjectsArray = [[[CoreDataHelper instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:managedObjectsArray.count];
        [managedObjectsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Event *event = obj;
            NSArray *keys = [[[event entity] attributesByName] allKeys];
            NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys];
            [array addObject:dict];
        }];
        onCompletion(array);
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
        fetchRequest = nil;
    }
}

#pragma mark -  Delete  Record For Selected Entity From Database Table
-(void)deleterecordFromDatabaseForEntity:(NSString*)entity withPredocate:(NSString*)uniqueID withUserName:(NSString*)name{
    
    NSFetchRequest *fetchRequest = nil;
    NSEntityDescription *listOfNameEntity = nil;
    NSError *error = nil;
    NSMutableArray *managedObjectsArray = nil;
    
    @try {
        fetchRequest = [[NSFetchRequest alloc]init];
        listOfNameEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataHelper instance].managedObjectContext];
        [fetchRequest setEntity:listOfNameEntity];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(userName == %@) AND (eventName == %@)", name, uniqueID];
        managedObjectsArray = [[[CoreDataHelper instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        for (NSManagedObject *managedObject in managedObjectsArray)
        {
            [[CoreDataHelper instance].managedObjectContext deleteObject:managedObject];
        }
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
        fetchRequest = nil;
    }
}

#pragma mark -  Delete  Record For Selected Entity From Database Table
-(void)fetchDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name withPredocate:(NSString*)uniqueID onCompletion:(void(^)(BOOL))onCompletion{
    
    NSFetchRequest *fetchRequest = nil;
    NSEntityDescription *listOfNameEntity = nil;
    NSError *error = nil;
    NSMutableArray *managedObjectsArray = nil;
    
    @try {
        fetchRequest = [[NSFetchRequest alloc]init];
        listOfNameEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataHelper instance].managedObjectContext];
        [fetchRequest setEntity:listOfNameEntity];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(userName == %@) AND (eventName == %@)", name, uniqueID];
        managedObjectsArray = [[[CoreDataHelper instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        if([managedObjectsArray count]==0){
            onCompletion(false);
        }
        else{
            onCompletion(true);
        }
        
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
        fetchRequest = nil;
    }
}
-(void)deleteObjectForIndex:(NSManagedObject *)index;
{
    NSError *error = nil;
    NSManagedObjectContext * context = [CoreDataHelper instance].managedObjectContext;
    [context deleteObject:index];
    if (![context save:&error]) {
        NSLog(@"Can't delete! %@ %@", error, [error localizedDescription]);
    }
}
-(void)fetchDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name onCompletion:(void(^)(NSMutableArray *))onCompletion
{
    NSFetchRequest *fetchRequest = nil;
    NSEntityDescription *listOfNameEntity = nil;
    NSError *error = nil;
    NSMutableArray *managedObjectsArray = nil;
    
    @try {
        fetchRequest = [[NSFetchRequest alloc]init];
        listOfNameEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataHelper instance].managedObjectContext];
        [fetchRequest setEntity:listOfNameEntity];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(userName == %@)", name];
        managedObjectsArray = [[[CoreDataHelper instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:managedObjectsArray.count];
        [managedObjectsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Event *event = obj;
            NSArray *keys = [[[event entity] attributesByName] allKeys];
            NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys];
            [array addObject:dict];
        }];
        onCompletion(array);
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
        fetchRequest = nil;
    }
}
-(void)clearDatabaseForEntity:(NSString*)entity withUserName:(NSString*)name{
    NSFetchRequest *fetchRequest = nil;
    NSEntityDescription *listOfNameEntity = nil;
    NSError *error = nil;
    NSMutableArray *managedObjectsArray = nil;
    
    @try {
        fetchRequest = [[NSFetchRequest alloc]init];
        listOfNameEntity = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataHelper instance].managedObjectContext];
        [fetchRequest setEntity:listOfNameEntity];
        fetchRequest.predicate=[NSPredicate predicateWithFormat:@"(userName == %@)", name];
        managedObjectsArray = [[[CoreDataHelper instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
        for (NSManagedObject *managedObject in managedObjectsArray)
        {
            [[CoreDataHelper instance].managedObjectContext deleteObject:managedObject];
        }
    }
    @catch (NSException * e) {
        [NSException raise:[e name] format:[e description],nil];
    }
    @finally {
        fetchRequest = nil;
    }
}
@end

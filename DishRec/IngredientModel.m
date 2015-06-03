//
//  IngredientModel.m
//  DishRec
//
//  Created by Sherman Ng on 11/20/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import "IngredientModel.h"
#import "IngredientEntity.h"

@implementation IngredientModel

static IngredientModel *_sharedInstance = nil;

+ (IngredientModel*)sharedInstance
{
    if (!_sharedInstance)
    {
        _sharedInstance = [[IngredientModel alloc] init];
    }
    
    return _sharedInstance;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSManagedObjectContext*) managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel*) managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RefrigeratorModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RefrigeratorModel.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"error initializing persistent store coordinator: %@ %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;

}


-(NSURL*) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)saveChanges
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]) {
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Save failed %@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"Save succeeded");
        }
    }
}


-(NSMutableDictionary *) getExistingIngredientsWithIIDs:(NSArray *)iids
{
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] init];
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iid IN %@", iids];
    
    fetchrequest.predicate = predicate;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"IngredientEntity" inManagedObjectContext:context];
    
    fetchrequest.entity = entity;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"iid" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    fetchrequest.sortDescriptors = sortDescriptors;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchrequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    
    NSError *error = nil;
    
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray *fetchedObjects = fetchedResultsController.fetchedObjects;
    
    NSInteger resultCount = [fetchedObjects count];
    
    if (resultCount == 0) {
        return [NSMutableDictionary dictionary];
    }
    
    IngredientEntity *ingEnt;
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < resultCount; i++) {
        ingEnt = fetchedObjects[i];
        tmpDict[ingEnt.iid] = ingEnt;
    }
    
    return tmpDict;
    
}


@end

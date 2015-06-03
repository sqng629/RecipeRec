//
//  IngredientModel.h
//  DishRec
//
//  Created by Sherman Ng on 11/20/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientModel : NSObject

+ (IngredientModel*) sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveChanges;

-(NSMutableDictionary *) getExistingIngredientsWithIIDs:(NSArray *)iids;

@end

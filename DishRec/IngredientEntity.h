//
//  IngredientEntity.h
//  DishRec
//
//  Created by Sherman Ng on 11/20/13.
//  Copyright (c) 2013 Sherman Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IngredientEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ing_amount;
@property (nonatomic, retain) NSString * iid;


@end

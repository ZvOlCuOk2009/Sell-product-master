//
//  TSProduct+CoreDataProperties.h
//  Sell product
//
//  Created by Mac on 27.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TSProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *specification;
@property (nullable, nonatomic, retain) NSData *images;

@end

NS_ASSUME_NONNULL_END

//
//  Item+CoreDataProperties.h
//  TODO_V04
//
//  Created by Mac on 15/01/2025.
//
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *item;
@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, copy) NSString *itemKey;
@property (nullable, nonatomic, retain) Category *categories;

@end

NS_ASSUME_NONNULL_END

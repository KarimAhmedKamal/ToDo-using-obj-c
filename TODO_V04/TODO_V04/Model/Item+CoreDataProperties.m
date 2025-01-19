//
//  Item+CoreDataProperties.m
//  TODO_V04
//
//  Created by Mac on 15/01/2025.
//
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Item"];
}

@dynamic item;
@dynamic orderingValue;
@dynamic itemKey;
@dynamic categories;

@end

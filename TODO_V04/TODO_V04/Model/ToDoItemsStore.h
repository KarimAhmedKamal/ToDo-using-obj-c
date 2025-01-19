//
//  ToDoItemsStore.h
//  TODO_V02
//
//  Created by Mac on 14/01/2025.
//

#import <Foundation/Foundation.h>
#import "Item+CoreDataProperties.h"
@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface ToDoItemsStore : NSObject

@property (nonatomic) NSMutableArray *todoItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
- (void)loadAllItems;
- (Item *)createItem;
- (void)removeItem:(Item *)item;
//+ (instancetype)sharedStore;


@end

NS_ASSUME_NONNULL_END
